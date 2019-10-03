//
//  PKEssentialDataManager.swift
//  Canonchain
//
//  Created by LEE on 5/16/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit
//基础数据处理类
class PKEssentialDataManager: NSObject {
    static let sharedInstance = PKEssentialDataManager()
    private override init() {}
  //  var tFiatmoneyrate : Decimal?
    
    var fiatmoneyrate : Decimal?
    typealias FiatmoneyrateBlock = (Decimal)->Void
    //获取当前时间戳
    class func timeInterval() -> CLongLong {
        let date = NSDate()
        let timeInterval :CLongLong = CLongLong(date.timeIntervalSince1970 * 1000)
        return timeInterval
    }
    class func createQRCodeImage(with string: String?, andSize size: CGFloat) -> UIImage? {
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        let data: Data? = string?.data(using: .utf8)
        filter?.setValue(data, forKeyPath: "inputMessage")
        let outputImage: CIImage? = filter?.outputImage
        let extent: CGRect = (outputImage?.extent.integral)!
        let scale: CGFloat = min(size / extent.width, size / extent.height)
        let width = size_t(extent.width * scale)
        let height = size_t(extent.height * scale)
        let cs = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo:0)
        
        let context = CIContext(options: nil)
        let bitmapImage = context.createCGImage(outputImage!, from: extent)
        bitmapRef!.interpolationQuality = CGInterpolationQuality.none
        bitmapRef!.scaleBy(x: scale, y: scale)
        bitmapRef!.draw(bitmapImage!, in: extent);
        let scaleImage = bitmapRef!.makeImage()
        let codeImage = UIImage(cgImage: scaleImage!)
        return codeImage
    }
    //获取人民币汇率
    func getFiatmoneyrate(_ block : @escaping FiatmoneyrateBlock){
        if fiatmoneyrate == nil {
        let urlString = wGeGtfiatmoneyrateHttpURLString
        let paramterDic : NSMutableDictionary? = NSMutableDictionary.init()
        paramterDic!["symbol"] = "USD/CNY"
        PKAlamofire.getDataWithURLStringAndParameterDic(urlString, paramterDic) { respondData in
            print("网络请求返回的用户data------------\(respondData)")
            if respondData.result.isSuccess {
                print("返回成功")
            }else{
                block(6.356)
                self.fiatmoneyrate = 6.356
                return
            }
            let valueDic : [String : Any] = respondData.value as! [String : Any]
            let dataDic : Double? = valueDic["data"] as? Double
            if dataDic == nil {
                 block(6.356)
                 self.fiatmoneyrate = 6.356
                return
            }
            let rate : Decimal = Decimal(dataDic!)
            self.fiatmoneyrate = rate
            block(rate)
            }
        }else{
            block(fiatmoneyrate!)
        }
    }
}
