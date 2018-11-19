


//
//  PKKLineGroup.swift
//  PrincekinKlineFrame
//
//  Created by LEE on 7/10/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit

public class PKKLineGroup: NSObject {
    public var klineArray = [PKKLine]()
    
    /* 此方法在项目中根据返回的数据结构实现
     static func klineArray(klineJsonArray: [JSON]) -> [PKKLine] {
     var klineArray = [PKKLine]()
     for klineJson in klineJsonArray {
     let kline = PKKLine.init(json: klineJson)
     klineArray.insert(kline, at: 0)
     }
     return klineArray
     }
     */
    public func removeAllKline() {
        self.klineArray.removeAll()
    }
    public func insert(klineArray: [PKKLine]) {
        self.klineArray = klineArray + self.klineArray
        self.enumerateKlines()
    }
   
    public func insert(klineGroup: PKKLineGroup) {
        self.klineArray = klineGroup.klineArray + self.klineArray
        self.enumerateKlines()
    }
    public func append(klineArray: [PKKLine]) {

        for kline in klineArray {
            if kline.dateString == self.klineArray.last?.dateString{
                self.klineArray.removeLast()
            }
            self.klineArray.append(kline)
        }
        self.enumerateKlines()
    }
    public func append(klineGroup: PKKLineGroup) {
        for kline in klineGroup.klineArray {
            if kline.dateString == self.klineArray.last?.dateString{
                self.klineArray.removeLast()
            }
            self.klineArray.append(kline)
        }
        self.enumerateKlines()
    }
    public func enumerateKlines() {
        if self.klineArray.count == 0 {
            return
        }
        var prevKline = self.klineArray[0]
        prevKline.index = -1
        prevKline.sumLastClose = 0
        for kline in self.klineArray {
            kline.klineGroup = self
            kline.reset(prevKline: prevKline)
            prevKline = kline
        }

    }
    
    public func minTimeStamp() -> Double {
        if self.klineArray.count > 0 {
            return self.klineArray.first!.timeStamp
        }
        return Date().timeIntervalSince1970
    }
}
