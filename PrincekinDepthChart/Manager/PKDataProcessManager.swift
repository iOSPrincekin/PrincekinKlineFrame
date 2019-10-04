//
//  PKDataProcessManager.swift
//  Canonchain
//
//  Created by LEE on 5/16/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit
import CryptoSwift
import DateToolsSwift
import CommonCrypto
//数据处理类
class PKDataProcessManager: NSObject {
    
    enum HMACAlgorithm {
        case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
        
        func toCCHmacAlgorithm() -> CCHmacAlgorithm {
            var result: Int = 0
            switch self {
            case .MD5:
                result = kCCHmacAlgMD5
            case .SHA1:
                result = kCCHmacAlgSHA1
            case .SHA224:
                result = kCCHmacAlgSHA224
            case .SHA256:
                result = kCCHmacAlgSHA256
            case .SHA384:
                result = kCCHmacAlgSHA384
            case .SHA512:
                result = kCCHmacAlgSHA512
            }
            return CCHmacAlgorithm(result)
        }
        
        func digestLength() -> Int {
            var result: CInt = 0
            switch self {
            case .MD5:
                result = CC_MD5_DIGEST_LENGTH
            case .SHA1:
                result = CC_SHA1_DIGEST_LENGTH
            case .SHA224:
                result = CC_SHA224_DIGEST_LENGTH
            case .SHA256:
                result = CC_SHA256_DIGEST_LENGTH
            case .SHA384:
                result = CC_SHA384_DIGEST_LENGTH
            case .SHA512:
                result = CC_SHA512_DIGEST_LENGTH
            }
            return Int(result)
        }
    }
    //MARK:==================SHA256========================
    func sha256(_ plaintext: String) -> String{
        if let stringData = plaintext.data(using: String.Encoding.utf8) {
            return hexStringFromData(input: digest(input: stringData as NSData))
        }
        return ""
    }
    
    private func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }
    
    private  func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        
        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }
        
        return hexString
    }
    
    //MARK:==================hmacSHA256========================
    class func hmac(algorithm: HMACAlgorithm,_ plaintext: String?, withKey key: String?) -> String? {
        let hmac = try! HMAC(key: key!.bytes, variant: .sha256).authenticate(plaintext!.bytes)
        let hmacHexString = hmac.toHexString()
        //    let hmacString = hmacHexString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet(charactersIn:"`#%^{}\"[]|\\<> ").inverted)
        return hmacHexString
        
    }
    class func hmacSHA256(_ plaintext: String?, withKey key: String?) -> String? {
        return hmac(algorithm: HMACAlgorithm.SHA256, plaintext, withKey: key)
    }
    class func hmacSHA256WithKey(_ plaintext: String?) -> String? {
        return hmac(algorithm: HMACAlgorithm.SHA256, plaintext, withKey: "JdNWblU37FIoqCWYGiAHON2JsfLGCzYKLgWSlkUwXDuqk3hTJk3b7t9WagX0AUDL")
    }
    class func dealParamsDicAndReturnhmacSHA256(_ dic : [String : Any]?) -> String? {
        let resultDic = dic!.sorted {$0.0 < $1.0}
        var plaintext = ""
        for (key, value) in resultDic {
            plaintext += "\(key)=\(value)&"
        }
        plaintext.removeLast()
        
        print("字典字符串是=====\(plaintext)")
        return hmacSHA256WithKey(plaintext)
    }
    class func dealDicWithTimestampAndSHA256(_ dicPointer : AutoreleasingUnsafeMutablePointer<NSMutableDictionary?>) {}
    //MARK:============================================================================格式化String======================================================
    //保留两位Double小数运算
    class func keepTwoDoublesOperation(_ a : Double) -> Double {
        return keepMultidigitDoublesOperation(a, 2)
    }
    //保留Double小数运算
    class func keepMultidigitDoublesOperation(_ a : Double,_ multidigit : Int) -> Double {
        let divisor = pow(10.0, Double(multidigit))
        let b = (a * divisor).rounded(.down) / divisor
        return b
    }
    //保留两位Double小数运算toString
    class func keepTwoDoublesOperationToString(_ a : Double) -> String {
        return keepMultidigitDoublesOperationToString(a, 2)
    }
    //保留Double小数运算toString
    class func keepMultidigitDoublesOperationToString(_ a : Double,_ multidigit : Int) -> String {
//        var multidigit1 = multidigit + 0
//        var divisor1 : Int = NSDecimalNumber.init(decimal: pow(10, multidigit1 - 1)).intValue
//        while Int(a) / divisor1 == 0 {
//           multidigit1 += 1
//            divisor1 = NSDecimalNumber.init(decimal: pow(10, multidigit1 - 1)).intValue
//        }
       let divisor = pow(10.0, Double(multidigit))
    //    let b = (a * divisor).rounded(.down) / divisor
       //  let b =  Double(Int(a * divisor)) / divisor
        let b = rint(a * divisor) / divisor

        return String.init(format: "%.\(multidigit)f", b)
    }
    //保留两位Decimal小数运算
    class func keepTwoDecimalsOperation(_ a : Decimal) -> Decimal {
        return keepMultidigitDecimalsOperation(a,2)
    }
    //保留八位Decimal小数运算
    class func keepEightDecimalsOperation(_ a : Decimal) -> Decimal {
        return keepMultidigitDecimalsOperation(a,8)
    }
    //保留Decimal小数运算
    class func keepMultidigitDecimalsOperation(_ a : Decimal,_ multidigit : Int) -> Decimal {
        let b = NSDecimalNumber.init(decimal: a)
        let c = b.rounding(accordingToBehavior: NSDecimalNumberHandler(roundingMode: .down, scale: Int16(multidigit), raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false))
        let d = c.decimalValue
        return d
        
    }
    //保留Decimal小数四舍五入运算
    class func keepMultidigitDecimalsOperationPlain(_ a : Decimal,_ multidigit : Int) -> Decimal {
        let b = NSDecimalNumber.init(decimal: a)
        let c = b.rounding(accordingToBehavior: NSDecimalNumberHandler(roundingMode: .plain, scale: Int16(multidigit), raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false))
        let d = c.decimalValue
        return d
        
    }
    //将NSDecimalNumber 格式化为响应的位数
    class func returnNSDecimalNumberFormatterString(_ decimalNumber : NSDecimalNumber,_ multidigit : Int) -> String {
        let nf = NumberFormatter()
        nf.numberStyle = NumberFormatter.Style.decimal
        nf.minimumFractionDigits = multidigit
        nf.maximumFractionDigits = multidigit
        nf.minimumIntegerDigits = 1
        nf.roundingMode = NumberFormatter.RoundingMode.down
        let tString = nf.string(from: decimalNumber)!
        let decimalString = tString.replacingOccurrences(of: ",", with: "")
        return decimalString
    }
    
    //    //将Decimal 格式化为响应的位数
    //    class func returnDecimalFormatterString(_ decimal : Decimal,_ multidigit : Int) -> String {
    //        let nf = NumberFormatter()
    //        nf.numberStyle = NumberFormatter.Style.decimal
    //        nf.minimumFractionDigits = multidigit
    //        nf.minimumIntegerDigits = 1
    //        let decimalNumber = NSDecimalNumber.init(decimal: decimal)
    //        let tString = nf.string(from: decimalNumber)!
    //        let decimalString = tString.replacingOccurrences(of: ",", with: "")
    //        return decimalString
    //    }
    
    //将NSDecimalNumber格式化为两位
    class func formatterTwoDecimalNumber(_ number : NSDecimalNumber) -> String {
        return returnNSDecimalNumberFormatterString(number,2)
    }
    //将NSDecimalNumber格式化为四位
    class func formatterFourDecimalNumber(_ number : NSDecimalNumber) -> String {
        return returnNSDecimalNumberFormatterString(number,4)
    }
    //将NSDecimalNumber格式化为八位
    class func formatterEightDecimalNumber(_ number : NSDecimalNumber) -> String {
        return returnNSDecimalNumberFormatterString(number,8)
    }
    
    //将Decimal 格式化为响应的位数
    class func returnFormatterDecimalString(_ decimal : Decimal,_ multidigit : Int) -> String {
        return returnNSDecimalNumberFormatterString(NSDecimalNumber.init(decimal: decimal), multidigit)
    }
//    //将Decimal格式化为String 存在位数问题
//    class func formatterDecimal(_ decimal : Decimal) -> String {
//        let nf = NumberFormatter()
//        nf.numberStyle = NumberFormatter.Style.decimal
//        nf.minimumIntegerDigits = 1
//        nf.roundingMode = NumberFormatter.RoundingMode.down
//        let tString = nf.string(from: NSDecimalNumber.init(decimal: decimal))!
//        let decimalString = tString.replacingOccurrences(of: ",", with: "")
//        return decimalString
//    }
    //将Decimal格式化为两位
    class func formatterTwoDecimal(_ decimal : Decimal) -> String {
        return formatterTwoDecimalNumber(NSDecimalNumber.init(decimal: decimal))
    }
    //将Decimal格式化为四位
    class func formatterFourDecimal(_ decimal : Decimal) -> String {
        return formatterFourDecimalNumber(NSDecimalNumber.init(decimal: decimal))
    }
    //将Decimal格式化为八位
    class func formatterEightDecimal(_ decimal : Decimal) -> String {
        return formatterEightDecimalNumber(NSDecimalNumber.init(decimal: decimal))
    }
    //根据位数格式化实数string
    class func formatterArithmeticString(_ arithmeticString : String,_ multidigit : Int) -> String {
        if PKVerificationEnumManager.arithmeticNumber(arithmeticString).isRight{
            var arithmeticString = arithmeticString

            if PKVerificationEnumManager.positiveInteger(arithmeticString).isRight{
                arithmeticString.append(".")
            }
            let pointIndex = arithmeticString.index(of: ".")
            let pointPosition = arithmeticString.positionOf(sub: ".")
            let endPosition = pointPosition + multidigit
            var subString = ""
            if endPosition > arithmeticString.count - 1{
                subString = arithmeticString
                let differenceValue = endPosition - (arithmeticString.count - 1)
                for i in 0..<differenceValue{
                    subString.append("0")
                }
            }else{
                let endIndex = arithmeticString.index(pointIndex!, offsetBy: multidigit)
                subString = String(arithmeticString[arithmeticString.startIndex...endIndex])
            }
            return subString
        }else{
            return ""
        }
        
    }
    //根据位数格式化实数string totaldigit 总位数
    class func formatterArithmeticStringByTotaldigit(_ arithmeticString : String,_ multidigit : Int,_ totaldigit : Int) -> String {
   let str1 = formatterArithmeticString(arithmeticString, multidigit)
        let str2 = formatterArithmeticString(str1, totaldigit)
        return str2
    }
    //根据2位数格式化实数string
    class func formatterArithmeticStringTwoMultidigit(_ arithmeticString : String) -> String {
        return formatterArithmeticString(arithmeticString, 2)
    }
    //根据4位数格式化实数string
    class func formatterArithmeticStringFourMultidigit(_ arithmeticString : String) -> String {
        return formatterArithmeticString(arithmeticString, 4)
    }
    //根据8位数格式化实数string
    class func formatterArithmeticStringEightMultidigit(_ arithmeticString : String) -> String {
        return formatterArithmeticString(arithmeticString, 8)
    }
    //"HH:mm MM/dd"
    //根据秒数返回日期
    class func getNowDateBySecond(_ seconds : CLongLong, _ format : String)-> String {
        let date = Date.init(timeIntervalSince1970: TimeInterval(seconds))
        let dateString = date.format(with: format)
        return dateString
    }
    //根据毫秒数返回日期
    class func getNowDateByillisSecond(_ milliseconds : CLongLong,_ format : String)-> String {
        let seconds = milliseconds / 1000
        return  getNowDateBySecond(seconds,format)
    }
    //将图片转换为String类型
    class func base64EncodeImageString(withName name: String?) -> String? {
        let image = UIImage(named: name ?? "")
        let data: Data? = UIImagePNGRepresentation(image!)
        let base64Data = data?.base64EncodedData(options: [])
        var baseString: String? = nil
        if let aData = base64Data {
            baseString = String(data: aData, encoding: .utf8)
        }
        return baseString
    }
    //将图片转换为String类型
    class func base64EncodeImageData(withName name: String?) -> Data? {
        let image = UIImage(named: name ?? "")
        let data: Data? = UIImagePNGRepresentation(image!)
        let base64Data = data?.base64EncodedData(options: [])
        return base64Data
    }
}
