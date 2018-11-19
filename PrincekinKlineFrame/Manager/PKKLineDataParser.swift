//
//  PKKLineDataParser.swift
//  Canonchain
//
//  Created by LEE on 7/18/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit
extension PKKLine {
    
  public convenience init(array : [String]) {
        self.init()
   //     self.timeStamp = Double(array[0])!
        var time : CLongLong =  CLongLong(array[0])!
        if time > 10000000000   {
            time = time / 1000
        }
        self.timeStamp = Double(time)
        self.open = Double(array[1])!
        self.high = Double(array[2])!
        self.low = Double(array[3])!
        self.close = Double(array[4])!
        self.volume = Double(array[5])!
    }
   public convenience init(dictionary : [String : Any]) {
        self.init()
      //  print("socket返回的K线图字典是------\(dictionary)")
        var time : CLongLong =  dictionary["T"] as! CLongLong
        if time > 10000000000   {
            time = time / 1000
        }
        self.timeStamp = Double(time)
        self.open = Double(dictionary["o"] as! String)!
        self.close = Double(dictionary["c"] as! String)!
        self.low = Double(dictionary["l"] as! String)!
        self.high = Double(dictionary["h"] as! String)!
        self.volume = Double(dictionary["v"] as! String)!
    }
    
}

extension PKKLineGroup {
   public static func klineArray(klineStringArray: [[String]]) -> [PKKLine] {
        var klineArray = [PKKLine]()
        for klineString in klineStringArray {
            let kline = PKKLine.init(array: klineString)
           // klineArray.insert(kline, at: 0)
            klineArray.append(kline)
        }
        return klineArray
    }
   public static func klineArray(klineStringDictionary: [[String : Any]]) -> [PKKLine] {
        var klineArray = [PKKLine]()
        for klineString in klineStringDictionary {
            let kline = PKKLine.init(dictionary: klineString)
            klineArray.append(kline)
        }
        return klineArray
    }
}
