//
//  PKKLineConfig.swift
//  PrincekinKlineFrame
//
//  Created by LEE on 7/10/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit

public struct PKKLineConfig {
    
    /// KLine 蜡烛初始默认宽度
    public static let KLineDefaultWidth = CGFloat(10)
    /// KLine 蜡烛宽度
    public static var KLineWidth: CGFloat {
        get {
            return KLineDefaultWidth * PKKLineParamters.getZoomScale()
        }
    }
    
    /// KLine 蜡烛 最小 高度
    public static let KLineMinHeight = CGFloat(1)
    /// KLine 蜡烛影线宽度
    public static let KLineHatchedWidth = CGFloat(1)
    /// KLine 蜡烛间隙
    public static let KLineGap = CGFloat(1)
    
    /// KLine 分时线宽度
    public static let LineWidth = CGFloat(1)
    
    /// KLine 缩放比 下限
    public static let ZoomScaleLowerLimit = CGFloat(0.2)
    /// KLine 缩放比 上线
    public static let ZoomScaleUpperLimit = CGFloat(2)
    /// kLine 缩放比变化阈值
    public static let ZoomScaleLimit = CGFloat(0.03)
    /// KLine 缩放因子
    public static let ZoomScaleFactor = CGFloat(0.1)
    
    /// KLine MA线宽
    public static let MALineWidth = CGFloat(1)
    /// MACD 柱状初始默认宽度
    public static let MACDDefaultWidth = CGFloat(5)
    /// MACD 柱状宽度
    public static var MACDWidth: CGFloat {
        get {
            return MACDDefaultWidth * PKKLineParamters.getZoomScale()
        }
    }
    
    /// K线图 右侧 Y轴视图宽度
    public static let RightYViewWidth = CGFloat(50)
    /// k线图显示信息框的宽度
    public static let PortraitValueViewWidth = xFitWithDown(160)
    public static let PortraitValueViewHeight = xFitWithDown(170)
    /// 分时图显示信息框的宽度
    public static let TimePortraitValueViewWidth = xFitWithDown(160)
    public static let TimePortraitValueViewHeight = xFitWithDown(60)
    public static let PortraitValueViewMargin = CGFloat(20)
    /// K线图 右侧 Y轴显示的坐标值数量
    public static let KLineViewRightYCount = 5
    /// 成交量图 右侧 Y轴显示的坐标值数量
    public static let VolumeViewRightYCount = 3
    /// 底部MACD/KDJ图 右侧 Y轴显示的坐标值数量
    public static let AccessoryViewRightYCount = 3
    public static let DateShowCount = 5
    public static var WIDTH : CGFloat = UIScreen.main.bounds.width
    public static var HEIGHT : CGFloat = UIScreen.main.bounds.height
    
    // 当前屏幕宽度与6s宽度的比例
    
    public static var widthSCALE : CGFloat = WIDTH / 375.0
    public static var heightSCALE : CGFloat = HEIGHT / 667.0
  
    
    public static func xFit(_ x : CGFloat) -> CGFloat
    {
        return  widthSCALE * x
    }
    public static func yFit(_ y : CGFloat) -> CGFloat
    {
        return  heightSCALE * y
    }
    //只有向下的比例
    public static func yFitWithDown(_ y : CGFloat) -> CGFloat
    {
        return  heightSCALE > 1 ? y : heightSCALE * y
    }
    //只有向下的比例
   public static func xFitWithDown(_ x : CGFloat) -> CGFloat
    {
        return  widthSCALE > 1 ? x : widthSCALE * x
    }


    //日期间的间隔
    public static var DateStep : CGFloat = WIDTH / CGFloat(DateShowCount - 1)
    //全屏状态下的参数
    public static var fullScreenTopViewHeight : CGFloat = 44    //top
    public static var fullScreenBottomViewHeight : CGFloat = 35    //bottom
    /// K线图 占 K线图+成交量图+底部MACD/KDJ图总高度 之比
    ///
    /// - Returns: K线图 占 K线图+成交量图+底部MACD/KDJ图总高度 之比
    public static func KLineViewHeightRate() -> CGFloat {
        if PKKLineParamters.AccessoryType != .NONE {
            return CGFloat(0.6)
        } else {
            return CGFloat(0.75)
        }
    }
    
    /// 成交量图 占 K线图+成交量图+底部MACD/KDJ图总高度 之比
    ///
    /// - Returns: 成交量图 占 K线图+成交量图+底部MACD/KDJ图总高度 之比
    public static func VolumeViewHeightRate() -> CGFloat {
        if PKKLineParamters.AccessoryType != .NONE {
            return CGFloat(0.2)
        } else {
            return CGFloat(0.25)
        }
    }
    
    /// 底部MACD/KDJ图 占 K线图+成交量图+底部MACD/KDJ图总高度 之比
    ///
    /// - Returns: 底部MACD/KDJ图 占 K线图+成交量图+底部MACD/KDJ图总高度 之比
    public static func AccessoryViewHeightRate() -> CGFloat {
        return CGFloat(0.2)
    }
    
    /// 显示数据的最少有效位数 (亦可理解为最多小数位数)
    public static let DataDecimals = 6
    //处理数据的多线程
    public static let PKKlineDealDataQueue = "PKKlineDealDataQueue"
    
    //为了在多线程中计算K线图,设置如下参数，记录views相应的值
//    //scrollview的x偏移值
//    public static var superScrollViewContentOffsetX : CGFloat = 0
//  //  scrollview的宽度
//   public static var superScrollViewWidth : CGFloat = 0
// //  PKKLineView的宽度
//   public static var kLineViewWidth : CGFloat = 0
// //  PKKLineView的高度
//   public static var kLineViewHeight : CGFloat = 0
//    //  PKKLineVolumeView的高度
//    public static var kLineVolumeViewHeight : CGFloat = 0
//    //  PKKLineAccessoryView的高度
//    public static var kLineAccessoryViewHeight : CGFloat = 0
    /// KLine 时段默认设置选项
    public static let KLineTimeFrames = [
        "1m",
        "5m",
        "15m",
        "30m",
        "1h",
        "2h",
        "4h",
        "1d",
        "3d",
        "5d",
        "1w"
    ]
    
    
}



