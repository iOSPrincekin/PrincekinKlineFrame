


//
//  PKVerificationManager.swift
//  Canonchain
//
//  Created by LEE on 5/14/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit

//class PKVerificationManager: NSObject {
//    static let sharedInstance = PKVerificationEnumManager()
//    private  override init() {}
//    //判断手机号码，1开头的十一位数字
//    class func checkPhoneNumberInput(_ text: String?) -> Bool {
//        let Regex = "1\\d{10}"
//        let RegexTestMobile = NSPredicate.init(format: "SELF MATCHES %@", Regex)
//        return RegexTestMobile.evaluate(with: text)
//    }
//    //判断密码，6－16位
//    class func checkInputPassword(_ text: String?) -> Bool {
//        let Regex = "\\w{6,16}"
//        let emailTest = NSPredicate(format: "SELF MATCHES %@", Regex)
//        return emailTest.evaluate(with: text)
//    }
//
//    //正则验证
//    class func verifyText(_ text : String) -> Bool{
//        let MOBILE = "^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])//d{8}$"
//        let RegexTestMobile = NSPredicate.init(format: "SELF MATCHES %@", MOBILE)
//        return   RegexTestMobile.evaluate(with: text)
//    }
//
//}

enum PKVerificationEnumManager {
    case email(_: String)
    case phoneNum(_: String)
    case carNum(_: String)
    case username(_: String)
    //登录密码
    case password(_: String)
    //资金密码
    case payPSW(_: String)
    case nickname(_: String)
    
    case URL(_: String)
    case IP(_: String)
    //单个字符只允许输入数字和小数点
    case numberAndPoint(_:String)
    //正整数+0
    case positiveInteger(_:String)
    //正实数
    case arithmeticNumber(_:String)
    //含有小数点的字符串  例如"1.0" "1."都可以匹配
    case arithmeticContainPointNumber(_:String)
    //两位小数正实数
    case arithmeticTwoNumber(_:String)
    //八位小数正实数
    case arithmeticEightNumber(_:String)
    //前缀匹配交易对
    case matchPrefixCurrency(_ : String,_ : String)
    //后缀匹配交易对
    case matchSuffixCurrency(_ : String,_ : String)
    //匹配字母
    case matchCharacters(_ : String)
    //匹配汉字
    case ChineseCharacters(_ : String)
    //判断是否含有中文字符
    case containChineseCharacters(_ : String)
    //判断是否是正确的谷歌验证码
    case matchGoogleCode(_ : String)
    //判断是否是正确的短信验证码
    case matchSMSCode(_ : String)
    //判断是否是正确的邮箱验证码
    case matchEmailCode(_ : String)
    var isRight: Bool {
        var predicateStr:String!
        var currObject:String!
        switch self {
        case let .email(str):
            predicateStr = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
            currObject = str
            break
        case let .phoneNum(str):
            //  predicateStr = "^((13[0-9])|(15[^4,\\D]) |(17[0,0-9])|(18[0,0-9]))\\d{8}$"
            //     predicateStr = "^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])//d{8}$"
            predicateStr = "1\\d{10}"
            currObject = str
            break
        case let .carNum(str):
            predicateStr = "^[A-Za-z]{1}[A-Za-z_0-9]{5}$"
            currObject = str
            break
        case let .username(str):
            predicateStr = "^[A-Za-z0-9]{6,20}+$"
            currObject = str
            break
        case let .password(str):
            predicateStr = "^[a-zA-Z0-9]{8,20}+$"
            currObject = str
            break
        case let .payPSW(str):
            predicateStr = "^[a-zA-Z0-9]{8,20}+$"
            currObject = str
            break
        case let .nickname(str):
            predicateStr = "^[\\u4e00-\\u9fa5]{4,8}$"
            currObject = str
            break
        case let .URL(str):
            predicateStr = "^(https?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?$"
            currObject = str
            break
        case let .IP(str):
            predicateStr = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
            currObject = str
            break
        case let .numberAndPoint(str):
            predicateStr = "^(\\.|[0-9]*)$"
            currObject = str
            break
            
        case let .arithmeticNumber(str):
            predicateStr = "^([0-9][0-9]*)+(.[0-9]*)?$"
            currObject = str
            break
         //含有小数点的字符串  例如"1.0" "1."都可以匹配
        case let .arithmeticContainPointNumber(str):
            predicateStr = "^([0-9][0-9]*)+\\.[0-9]*$"
            currObject = str
            break
        case let .arithmeticTwoNumber(str):
//
             predicateStr = "^(([0-9][0-9]*)\\.([0-9]{2}))"
            currObject = str
            break
        case let .arithmeticEightNumber(str):
            //            predicateStr = "^(([1-9][0-9]*)\\.([0-9]{2}))|[0]\\.([0-9]{2})$"
            predicateStr = "^(([0-9][0-9]*)\\.([0-9]{8}))"
            currObject = str
            break
        case let .matchPrefixCurrency(str1,str2):
            //            predicateStr = "^(([1-9][0-9]*)\\.([0-9]{2}))|[0]\\.([0-9]{2})$"
            predicateStr = "^\(str1).*?$"
            currObject = str2
            break
        case let .matchSuffixCurrency(str1,str2):
            predicateStr = "^.*?\(str2)$"
            currObject = str1
            break
        case let .matchCharacters(str):
            predicateStr = "^[a-zA-Z]$"
            currObject = str
            break
        case let .ChineseCharacters(str):
            predicateStr = "^[\\u4e00-\\u9fa5]*$"
            currObject = str
            break
        //正整数+0
        case let .positiveInteger(str):
            predicateStr = "^\\d+$"
            currObject = str
            break
            //判断是否含有中文字符
        case let .containChineseCharacters(str):
            predicateStr = ".*[\\u4e00-\\u9fa5].*"
            currObject = str
            break
        //判断是否是正确的谷歌验证码
        case let .matchGoogleCode(str):
            predicateStr = "^\\d{6}$"
            currObject = str
            break
        //判断是否是正确的短信验证码
        case let .matchSMSCode(str):
            predicateStr = "^\\d{6}$"
            currObject = str
            break
        //判断是否是正确的邮箱验证码
        case let .matchEmailCode(str):
            predicateStr = "^\\d{6}$"
            currObject = str
            break
        }
        
        let predicate =  NSPredicate(format: "SELF MATCHES %@" ,predicateStr)
        return predicate.evaluate(with: currObject)
    }
    
}


//        Validate.email("Dousnail@@153.com").isRight //false
//        
//        Validate.URL("https://www.baidu.com").isRight //true
//        
//        Validate.IP("11.11.11.11").isRight //true



