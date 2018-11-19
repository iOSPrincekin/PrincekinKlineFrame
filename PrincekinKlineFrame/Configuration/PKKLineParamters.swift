//
//  PKKLineParamters.swift
//  PrincekinKlineFrame
//
//  Created by LEE on 7/11/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit

//let LineType = "Line"
//let fifteenMType = "15min"
//let oneHType = "1hour"
//let fourHType = "4hour"
//let oneDType = "1day"
//let oneMType = "1min"
//let fiveMType = "5min"
//let thirtyMType = "30min"
//let oneWType = "1week"
//let oneMonType = "1mon"

/// KLine MA 类型设置选项
public enum PKKLineType: String {
    case Line = "Line", fifteenM = "15min", oneH = "1hour", fourH = "4hour",oneD = "1day",oneM = "1min", fiveM = "5min", thirtyM = "30min",twoH = "2hour",sixH = "6hour",twelveH = "12hour", oneW = "1week"
    public static func enumValue(string: String) -> PKKLineType {
        return PKKLineType.init(rawValue: string)!
    }
}


/// KLine MA 类型设置选项
public enum PKKLineMAType: String {
    case NONE = "Close", MA = "MA", EMA = "EMA", BOLL = "BOLL"
    public static func enumValue(string: String) -> PKKLineMAType {
        return PKKLineMAType.init(rawValue: string)!
    }
    //    public static let RawValues = ["MA", "EMA", "BOLL", "Close"]
    //    public static func enumValue(index: Int) -> PKKLineMAType {
    //        return PKKLineMAType.init(rawValue: RawValues[index])!
    //    }
}

/// KLine 底部MACD/KDJ图 类型设置选项
public enum PKKLineAccessoryType: String {
    case NONE = "Close", MACD = "MACD", KDJ = "KDJ", RSI = "RSI"
    public static func enumValue(string: String) -> PKKLineAccessoryType {
        return PKKLineAccessoryType.init(rawValue: string)!
    }
    //    public static let RawValues = ["MACD", "KDJ", "RSI", "Close"]
    //    public static func enumValue(index: Int) -> PKKLineAccessoryType {
    //        return PKKLineAccessoryType.init(rawValue: RawValues[index])!
    //    }
}

/// KLine 风格设置选项
public enum PKKLineStyle: Int {
    case standard = 0, hollow = 1, line = 2, curve = 3
    public static func enumValue(_ rawValue: Int) -> PKKLineStyle {
        return PKKLineStyle.init(rawValue: rawValue)!
    }
}



public class PKKLineParamters: NSObject {
   
    
    /// 需要显示的 MA值
    public static var KLineMAs = [7, 15, 30, 60]
    /// 需要显示的 EMS值
    public static var KLineEMAs = [7, 25, 99]
    /// 需要显示的 BOLL线的参数值
    public static var KLineBollPramas = ["N":20, "P":2]
    /// 需要显示的 MACD图的参数值
    public static var KLineMACDPramas = [12, 26, 9]
    /// 需要显示的 KDJ图的参数值
    public static var KLineKDJPramas = [3, 3, 9]
    /// 需要显示的 RSI图的参数值
    public static var KLineRSIPramas = [6, 12, 24]
    
    // MARK: - 缩放比
    /// KLine 缩放比
    private static var ZoomScale = CGFloat(1)
    public static func changeZoomScale(changeScale: CGFloat) -> Bool {
        let zoomScale = ZoomScale + changeScale
        if zoomScale > PKKLineConfig.ZoomScaleUpperLimit || zoomScale < PKKLineConfig.ZoomScaleLowerLimit {
            return false
        }
        ZoomScale = zoomScale
        return true
    }
    public static func setZoomScale(scale: CGFloat) {
        if scale > PKKLineConfig.ZoomScaleUpperLimit || scale < PKKLineConfig.ZoomScaleLowerLimit {
            return
        }
        ZoomScale = scale
    }
    public static func getZoomScale() -> CGFloat {
        return ZoomScale
    }
    /// KLine 显示的 kLine 类型
    public static var KLineType: PKKLineType = .Line {
        willSet {
            klineTypeChanged =  newValue != KLineType
        }
        didSet {
            if klineTypeChanged {
                NotificationCenter.default.post(name: PKKLineTypeChanged, object: nil)
            }
        }
    }
    private static var klineTypeChanged = false
    public static let PKKLineTypeChanged = NSNotification.Name.init("PKKLineTypeChanged")
    /// KLine 显示的 MA 类型
    public static var KLineMAType: PKKLineMAType = .MA {
        willSet {
            klineMATypeChanged =  newValue != KLineMAType
        }
        didSet {
            if klineMATypeChanged {
                NotificationCenter.default.post(name: PKKLineMATypeChanged, object: nil)
            }
        }
    }
    private static var klineMATypeChanged = false
    public static let PKKLineMATypeChanged = NSNotification.Name.init("PKKLineMATypeChanged")
    
    /// KLine 底部MACD/KDJ图 显示类型
    public static var AccessoryType: PKKLineAccessoryType = .MACD {
        willSet {
            accessoryTypeChanged =  newValue != AccessoryType
        }
        didSet {
            if accessoryTypeChanged {
                NotificationCenter.default.post(name: PKKLineAccessoryTypeChanged, object: nil)
            }
        }
    }
    private static var accessoryTypeChanged = false
    public static let PKKLineAccessoryTypeChanged = NSNotification.Name.init("PKKLineAccessoryTypeChanged")
    
    /// KLine 显示风格
    public static var KLineStyle: PKKLineStyle = .standard {
        willSet {
            kLineStyleChanged =  newValue != KLineStyle
        }
        didSet {
            if kLineStyleChanged {
                NotificationCenter.default.post(name: PKKLineStyleChanged, object: nil)
            }
        }
    }
    private static var kLineStyleChanged = false
    public static let PKKLineStyleChanged = NSNotification.Name.init("PKKLineStyleChanged")
    public static let FullScreenButtonClickNot = NSNotification.Name.init("FullScreenButtonClickNot")
        public static let FullScreenRightViewButtonClickNot = NSNotification.Name.init("FullScreenRightViewButtonClickNot")
    
    /// 时间帧 集合 【用于显示】
    public static var KLineTimeFrames = [String]()
    
    /// KLine 数据保留的小数位数
    public static var KLineDataDecimals = 6
    public static func setKLineDataDecimals(_ v1: Double, _ v2: Double) {
        KLineDataDecimals = PKKLineTool.dataDecimals(v1, v2)
    }
    /// KLine Volume 数据保留的小数位数
    public static var VolumeDataDecimals = 6
    public static func setVolumeDataDecimals(_ v1: Double, _ v2: Double) {
        VolumeDataDecimals = PKKLineTool.dataDecimals(v1, v2)
    }
    /// KLine 底部MACD/KDJ图 数据保留的小数位数
    public static var AccessoryDataDecimals = 6
    public static func setAccessoryDataDecimals(_ v1: Double, _ v2: Double) {
        AccessoryDataDecimals = PKKLineTool.dataDecimals(v1, v2)
    }
    
    // MARK: - 复位
    public static func reset() {
        ZoomScale = CGFloat(1)
        KLineMAType = .MA
        AccessoryType = .MACD
    }
    
}

