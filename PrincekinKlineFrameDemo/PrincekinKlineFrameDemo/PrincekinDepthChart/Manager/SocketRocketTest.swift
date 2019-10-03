//
//  SocketRocketTest.swift
//  CanonchainTests
//
//  Created by LEE on 8/22/18.
//  Copyright © 2018 LEE. All rights reserved.
//

let XCTestUrlSuffix_Kline = "/Kline"
let XCTestUrlSuffix_Depth = "/Depth"
import UIKit
public class SocketRocketTest: NSObject {
    //切断数据的bool值
   
    typealias AsyncBlock = () -> Void
    func dispatch_main_async_safe(block: @escaping AsyncBlock)  {
        if Thread.isMainThread {
            block()
        }
        else {
            DispatchQueue.main.async(execute: block)
        }
    }
    var timerHelp : PKTimerHelper!
    
        var urlString : String!
        
        //是否销毁操作
        var destroy = false
        //切断数据的bool值
        var _turnOffData = false
        
        var socketDelegate : PKSocketRockeTestDelegate!
        init(_ urlString : String) {
            super.init()
           socketDelegate?.socketRockeConnectSuccess()
          //  var urlStr = urlString
            let lastPathComponent = urlString.components(separatedBy: "/").last
            
            createDataMachine("/" + lastPathComponent!)
        }
   
        //虚拟数据产生器
    func createDataMachine(_ type : String) {
        switch type {
        case XCTestUrlSuffix_Kline:
            // 一分钟内重复发送的次数
            let repeatCount = 50.0
            
            PKTimerHelper.createTimerByInterval(Int((60.0 / repeatCount) * 1000.0)) {
      self.socketDelegate?.sendData(self.createKlineData(Int(repeatCount)))
            }
            break
        case XCTestUrlSuffix_Depth:
            // 1s
            PKTimerHelper.createTimerByInterval(1000) {
                self.socketDelegate?.sendData(self.createDepthData())
            }
            break
        default: break
            
        }
        
        }
        //生成深度图的测试数据
        func createDepthData() ->  [String : [[String]]]{
            let dataCount = arc4random_uniform(1000)
            var asksArray = [[String]]()
            var bidsArray = [[String]]()
            for _ in 0...dataCount {
                let price = 298.5 + Double(arc4random_uniform(20)) / 19.0
                let amount = Double(arc4random_uniform(60)) / 600.0
                let priceString = String(price)
                let amountString = String(amount)
                let arr = [priceString,amountString]
                asksArray.append(arr)
                
            }
            for _ in 0...dataCount {
                let price = 298.5 + Double(arc4random_uniform(20)) / 19.0
                let amount = Double(arc4random_uniform(60)) / 600.0
                let priceString = String(price)
                let amountString = String(amount)
                let arr = [priceString,amountString]
                bidsArray.append( arr)
            }
            return ["a" : asksArray,"b" : bidsArray]
            
        }
    //生成k线图的测试数据  repeatCount是需要重复的次数
   var klineDataCount : Int = 0
    var basicTime : CLongLong = 1535662800
    func createKlineData(_ repeatCount : Int) ->  [String : Any]{
       
        
       
        if klineDataCount > repeatCount {
            basicTime += 60
            klineDataCount = 0
        }
        var dataArray = [Double]()
        for _ in 0..<4 {
            let value = Double(16000) + Double(arc4random() % 2000000) / 1666.6
            dataArray.append(value)
        }
        
       dataArray.sort{$0 < $1}
        let low = dataArray.first
        let high = dataArray.last
        var open = 0.0
        var close = 0.0
        let volume = Double(arc4random() % 100000) / 6.66
        
        let randomNum = arc4random() % 10
        
        if randomNum % 2 == 1 {
          open = dataArray[1]
           close = dataArray[2]
        }else{
            open = dataArray[2]
            close = dataArray[1]
        }
        var dataDic = [String : Any]()
        dataDic["T"] = basicTime
        dataDic["o"] = String(open)
        dataDic["h"] = String(high!)
        dataDic["l"] = String(low!)
        dataDic["c"] = String(close)
        dataDic["v"] = String(volume)
        
        
//        var doubleDataArray = [basicTime,open,high,low,close]
//        let stringDataArray = doubleDataArray.map{
//            value in
//            return String(value!)
//        }
       klineDataCount += 1
        return dataDic
        
    }
      
       
      
       
     
      
        //屏蔽数据
        func turnOffData() {
            _turnOffData = true
        }
        //连接上数据
        func turnOnData() {
            _turnOffData = false
        }
       
    }


public protocol PKSocketRockeTestDelegate {
        //socket连接成功
        func socketRockeConnectSuccess()
        //发送数据Protocol 'Collection' can only be used as a generic constraint because it has Self or associated type requirements
        func sendData<T>(_ data : T)
}
    


