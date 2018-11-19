//
//  PKKLine.swift
//  PrincekinKlineFrame
//
//  Created by LEE on 7/10/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit

public class PKKLine: NSObject {
    public var timeStamp: Double = Double(0)
    public var open: Double = Double(0)
    public var close: Double = Double(0)
    public var low: Double = Double(0)
    public var high: Double = Double(0)
    public var volume: Double = Double(0)
    /* 此方法在项目中根据返回的数据结构实现
     convenience init(json: JSON) {
     self.init()
     self.timeStamp = json["timestamp"].doubleValue
     self.open = json["open"].doubleValue
     self.close = json["close"].doubleValue
     self.low = json["low"].doubleValue
     self.high = json["high"].doubleValue
     self.volume = json["volume"].doubleValue
     }
     */
    var dateString : String?{
        get{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd HH:mm"
           return dateFormatter.string(from: Date.init(timeIntervalSince1970: timeStamp))
        }
    }

    public weak var prevKline: PKKLine!
    public var index = 0
    public weak var klineGroup: PKKLineGroup!
    
    public var sumLastClose = Double(0)
    public var sumLastVolume = Double(0)
    public var klineMAs = [Int : Double]()
    public var volumeMAs = [Int : Double]()
    public var klineEMAs = [Int : Double]()
    
    public var klinePosition = PKKLinePosition()
    public var volumePosition = PKKLineVolumePosition()
    public var klineMAPositions = [Int : CGPoint]()
    public var volumeMAPositions = [Int : CGPoint]()
    public var klineEMAPositions = [Int : CGPoint]()
    
    public var klineBoll: PKKLineBoll?
    public var sumC_MA_Square = Double(0)
    
    public var klineMACD = PKKLineMACD()
    
    public var klineKDJ = PKKLineKDJ()
    
    public var klineRSI = PKKLineRSI()
}
