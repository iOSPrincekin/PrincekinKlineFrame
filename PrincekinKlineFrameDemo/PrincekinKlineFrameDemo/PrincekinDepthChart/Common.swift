//
//  Common.swift
//  Canonchain
//
//  Created by LEE on 3/19/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import Foundation
////import Masonry
import UIKit
////宏定义
//let wGreenColor = UIColorFromRGB(rgbValue : )
//
//MARK:================================================方法=======================================================
// 获得RGB颜色

func UIColorFromRGB(rgbValue:Int) ->UIColor
{
    return UIColorFromRGBAndAlpha(rgbValue: rgbValue, alpha: 1)
}
func UIColorFromRGBAndAlpha(rgbValue:Int,alpha:CGFloat) ->UIColor
{
    return UIColor.init(red: CGFloat(((Float)((rgbValue & 0xFF0000) >> 16))/255.0), green: CGFloat(((Float)((rgbValue & 0xFF00) >> 8))/255.0), blue: CGFloat(((Float)(rgbValue & 0xFF))/255.0), alpha: alpha)
}

//半透明绿色
let PKTranslucenceGreenColor = UIColorFromRGBAndAlpha(rgbValue:  0x00B066, alpha: CGFloat(0.2))
//半透明橙色
let PKTranslucenceOrangeColor = UIColorFromRGBAndAlpha(rgbValue: 0xFF8617,alpha: CGFloat(0.2))
////===================队列=====================
//BibiDepthManager处理数据的队列
let BibiDepthManagerDealDepthDataQueue = "PKBibiDepthManagerDealDethDataQueue"


//MARK:=====================================泛型运算符==========================
//字典的+=运算
func += <KeyType, ValueType> ( left: inout Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}
//字典的+运算
func + <KeyType, ValueType> ( left: Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) -> Dictionary<KeyType, ValueType> {
    var dic : Dictionary<KeyType, ValueType> =  Dictionary<KeyType, ValueType>()
    dic = left
    for (k, v) in right {
        dic.updateValue(v, forKey: k)
    }
    return dic
}

//MARK:================================================网络配置=======================================================
let iOSPrincekinTestBaseURLHost = "www.iOSPrincekinTestBaseURLHost.com"
let iOSPrincekinTestBaseURL = "http://www.iOSPrincekinTestBaseURLHost.com"
let iOSPrincekinTest_Kline_URL = "www.iOSPrincekinTestBaseURLHost.com/Kline"
let iOSPrincekinTest_Depth_URL = "www.iOSPrincekinTestBaseURLHost.com/Depth"
let iOSPrincekinTestURL_Suffix_Kline = "/Kline"
let iOSPrincekinTestURL_Suffix_Depth = "/Depth"
