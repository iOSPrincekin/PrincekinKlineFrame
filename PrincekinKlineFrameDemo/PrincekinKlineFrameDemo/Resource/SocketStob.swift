//
//  SocketStob.swift
//  CanonchainTests
//
//  Created by LEE on 8/22/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit

public class SocketStob: NSObject {
    //切断数据的bool值
    var wTimer : DispatchSource!
    typealias AsyncBlock = () -> Void
    func dispatch_main_async_safe(block: @escaping AsyncBlock)  {
        if Thread.isMainThread {
            block()
        }
        else {
            DispatchQueue.main.async(execute: block)
        }
    }
   
    
        var urlString : String!
        
        //是否销毁操作
        var destroy = false
        //切断数据的bool值
        var _turnOffData = false
        
        var socketDelegate : SocketStobDelegate!
        init(_ urlString : String) {
            super.init()
           socketDelegate?.socketRockeConnectSuccess()
            createDataMachine()
        }
   
        //虚拟数据产生器
    func createDataMachine() {
            // 一分钟内重复发送的次数
            let repeatCount = 50.0
        
        let pageStepTime: DispatchTimeInterval = .milliseconds(Int((60.0 / repeatCount) * 1000))
        
        let timer = DispatchSource.makeTimerSource() as? DispatchSource
       wTimer = timer
        timer?.schedule(deadline: .now(), repeating: pageStepTime )
        timer?.setEventHandler {
            self.socketDelegate?.sendData(self.createKlineData(Int(repeatCount)))
        }
        // 启动定时器
        timer?.resume()
        
       
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


public protocol SocketStobDelegate {
        //socket连接成功
        func socketRockeConnectSuccess()
        //发送数据Protocol 'Collection' can only be used as a generic constraint because it has Self or associated type requirements
        func sendData<T>(_ data : T)
}
    


