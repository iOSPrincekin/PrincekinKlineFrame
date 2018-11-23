////
////  PKKLineDemoView.swift
////  Canonchain
////
////  Created by LEE on 4/11/18.
////  Copyright © 2018 LEE. All rights reserved.
////
//

import UIKit
import PrincekinKlineFrame
import Alamofire
import OHHTTPStubs
let iOSPrincekinTestBaseURLHost = "www.iOSPrincekinTestBaseURLHost.com"
let iOSPrincekinTestBaseURL = "http://\(iOSPrincekinTestBaseURLHost)"
class PKKLineDemoView: PKKLineContainerView{
    weak var socket =  SocketStob.init("")
    var klineArray : [PKKLine]?{
        get{
            return mainView.scrollView.klineView.klineGroup.klineArray
        }
    }
    weak var fullVC : PKFullScreenKLineViewController?
    var wSymbol : String = ""{
        didSet{
            buttonClickBlock(String.localized_b2b_time_15m)
        }
    }
    
    func initFullVCData()  {
        fullVC?.reloadData(klineArray: klineArray ?? [PKKLine]())
    }
    func appendFullVCData()  {
        fullVC?.appendData(klineArray: klineArray ?? [PKKLine]())
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.kLineChangeTypeDelegate = self
    }
    // 创建https的虚拟数据
    func createGetKLineDataByHttpStub() {
        //  transferArrayToJson()
        //  getJsonArrayString()
        weak var weakSelf : PKKLineDemoView! = self
        stub(condition: isHost(iOSPrincekinTestBaseURLHost)) {
            req in
            print(req)
            let dataDic = ["1":"2"]
            let stubData = try! JSONSerialization.data(withJSONObject: dataDic, options: .prettyPrinted)
            return OHHTTPStubsResponse(fileAtPath: OHPathForFile("data.json", type(of: weakSelf))!,statusCode: 200,headers: ["Content-Type":"application/json"])
            
        }
    }
    func getDataFromHttp(){
        weak var weakSelf : PKKLineDemoView! = self
        createGetKLineDataByHttpStub()
        var param : [String : Any] = [String : Any]()
        param["symbol"] = wSymbol   //"CZRETH"
        let urlString : String = iOSPrincekinTestBaseURL + "/kline"
        Alamofire.request(urlString, method: .get, parameters: param, encoding:  URLEncoding.default, headers: nil).responseJSON {response in
            let dataArray : [[String]]? = response.value as? [[String]]
            
            if dataArray == nil{
                return
            }
            let klineGroup = PKKLineGroup()
            klineGroup.klineArray = PKKLineGroup.klineArray(klineStringArray: dataArray!)
            weakSelf.initData(klineArray: klineGroup.klineArray)
            weakSelf.initFullVCData()
            weakSelf.socket?.socketDelegate = weakSelf
        }
    }
    //销毁socket  以便于进行释放self
    func destroyTSocketRocke() {
        socket?.disConnect()
        socket = nil
    }
    deinit {
        print("PKKLineDemoView-----销毁了")
    }
    
}
//时间按钮点击时，相应的代理事件
extension PKKLineDemoView : PKKLineChangeKlineTypeDelegate {
    func changeKlineType() {
        print("当前的klineType是---------\(PKKLineParamters.KLineType)")
        switch PKKLineParamters.KLineType {
            
        case .Line:   //时分
            //  getTimeLineData()
            PKKLineParamters.KLineStyle = .curve
            break
        case .fifteenM: //15min
            getKline()
            break
        case .oneH:    //1hour
            getKline()
            break
        case .fourH:   //4hour
            getKline()
            break
        case .oneD:    //1day
            getKline()
            break
        case .oneM:    //1min
            getKline()
            break
        case .fiveM:   //5min
            getKline()
            break
        case .thirtyM:  //30min
            getKline()
            break
        case .twoH:     //2hour
            getKline()
            break
        case .sixH:     //6hour
            getKline()
            break
        case .twelveH:   //12hour
            getKline()
            break
        case .oneW:     //1week
            getKline()
            break
        }
    }
    func getKline() {
        print("点击-------->>>>>>>次数")
        PKKLineParamters.KLineStyle = .standard
        getDataFromHttp()
    }
}
//socket数据推送更新
extension PKKLineDemoView : SocketStobDelegate{
    func socketRockeConnectSuccess() {
        
    }
    
    func sendData<T>(_ data: T) {
        let kDic : [String : Any] = data as! [String : Any]
        let klineGroup = PKKLineGroup()
        klineGroup.klineArray = PKKLineGroup.klineArray(klineStringDictionary: [kDic])
        weak var weakSelf : PKKLineDemoView! = self
        DispatchQueue.main.async(execute: {
            weakSelf.appendData(klineArray:  klineGroup.klineArray)
            //self.appendFullVCData(klineGroup.klineArray)
        })
    }
    
    
}
