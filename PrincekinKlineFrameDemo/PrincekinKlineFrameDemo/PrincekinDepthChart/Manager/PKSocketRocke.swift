//
//  PKSocketRocke.swift
//  Canonchain
//
//  Created by LEE on 8/14/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit
import SocketRocket

/*
 本类是作为替换TSocketRocke的App内部的socket总管家
 之所以替换TSocketRock原因如下:
 1.在一些场景中，我们需要对socket连接的同一个地址进行频繁的断开、连接,由于TSocketRocke在每次重连连接时都要与服务器重新连接一次，浪费了大量的时间，增大了错误的几率
 2.方法过于多，看起来凌乱
 3.无法清除定义服务器断开与App内程序员断开
 
 
 
 新类PKSocketRocke应该具有的功能:
 1.简单的初始化，当前只有一个init url的方法；有重连功能、主动断开功能
 2.主动断开，主动重连的功能，验证SocketRocket  open和close方法能不能达到类似效果，最终会采用在didReceiveMessage屏蔽代理方法的形式，来达到主动断开、重连的功能  根据测试:(1).Cannot call -(void)open on SRWebSocket more than once
 (2).SRWebSockets are intended for one-time-use only.  Open should be called once and only once.我们只能采用采用在didReceiveMessage屏蔽代理方法的形式来达到主动断开重连的效果，这也是最优的形式
 3.实现代理方法
 4.往外部发送数据的delegate
 
 */
typealias AsyncBlock = () -> Void
func dispatch_main_async_safe(block: @escaping AsyncBlock)  {
    if Thread.isMainThread {
        block()
    }
    else {
        DispatchQueue.main.async(execute: block)
    }
}
class PKSocketRocke: NSObject {
    var urlString : String!
    var webSocket:SRWebSocket!
    var heartBeat:Timer!
    var reConnectTime:TimeInterval = TimeInterval()
    //是否销毁操作
    var destroy = false
    //切断数据的bool值
    var _turnOffData = false
    
   weak var socketDelegate : PKSocketRockeDelegate!
    init(_ urlString : String) {
        super.init()
        webSocket = SRWebSocket.init(url: URL.init(string: urlString))
       self.urlString = urlString
        webSocket?.delegate = self
        let queue = OperationQueue.init()
        queue.maxConcurrentOperationCount = 1
        webSocket?.setDelegateOperationQueue(queue)
        //连接
        webSocket?.open()
    }
    //断线了  重新连接
    func reInitSocket() {
        webSocket = SRWebSocket.init(url: URL.init(string: urlString))
        webSocket?.delegate = self
        reConnectTime = 0
        let queue = OperationQueue.init()
        queue.maxConcurrentOperationCount = 1
        webSocket?.setDelegateOperationQueue(queue)
        //连接
        webSocket?.open()
    }
    //取消心跳
    func destoryHeartBeat() {
        if heartBeat != nil {
            heartBeat!.invalidate()
            heartBeat = nil
        }
    }
    //初始化心跳
    func initHeartBeat() {
        weak var weakSelf = self
        dispatch_main_async_safe {
            weakSelf!.destoryHeartBeat()
            weakSelf!.heartBeat = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(weakSelf!.createHeart), userInfo: nil, repeats: true)
            RunLoop.current.add((weakSelf?.heartBeat!)!, forMode: .commonModes)
        }
    }
    @objc func createHeart() {
        print("heart")
        //和服务端约定好发送什么作为心跳标志，尽可能的减小心跳包大小
        //  self.sendMsg(msg: "heart")
        self.ping()
    }
    func ping() {
        webSocket?.sendPing(nil)
    }
    //断开连接
    func disConnect()  {
        if webSocket != nil{
            webSocket?.close()
            webSocket = nil
            destoryHeartBeat()
        }
    }
    //重连机制
    func reConnect()  {
        self.disConnect()
        //超过一分钟就不重连，所以只会重连5次  2^5 = 64
        if reConnectTime > 64 {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(reConnectTime * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {() -> Void in
            self.webSocket = nil
            self.reInitSocket()
        })
        //重连时间2的指数级增长
        if reConnectTime == 0{
            reConnectTime = 2
        }else{
            reConnectTime *= 2
        }
    }
    //屏蔽数据
    func turnOffData() {
      _turnOffData = true
    }
    //连接上数据
    func turnOnData() {
        _turnOffData = false
    }
    //销毁webSocket,等于将要释放PKSocketRocke
    func destroyWebSocket() {
        destroy = true
        webSocket?.close()
        webSocket = nil
        destoryHeartBeat()
    }
    deinit {
        
    }
}
extension PKSocketRocke : SRWebSocketDelegate{
    func webSocket(_ webSocket: SRWebSocket!, didReceiveMessage message: Any!) {
        //切断数据
        if _turnOffData {
           return
        }
        dispatch_main_async_safe {
        let data : Data = message as! Data
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            self.socketDelegate.sendData(json)
        }catch{
            print("失败")
            
        }
        }
    }
    func webSocketDidOpen(_ webSocket: SRWebSocket!) {
        print("连接成功")
        socketDelegate.socketRockeConnectSuccess()
        //连接成功了开始发送心跳
        initHeartBeat()
    }
    func webSocket(_ webSocket: SRWebSocket!, didFailWithError error: Error!) {
        print("连接出现错误------\(error)")
    }
    func webSocket(_ webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        print("被关闭连接，code:\(code),reason:\(reason),wasClean:\(wasClean)")
        if !destroy {
            reConnect()
        }
    }
    func webSocket(_ webSocket: SRWebSocket!, didReceivePong pongPayload: Data!) {
        print("收到pong回调")
    }
    func webSocketShouldConvertTextFrame(toString webSocket: SRWebSocket!) -> Bool {
        print("webSocketShouldConvertTextFrame")
        return false
    }
    
    
}
public protocol PKSocketRockeDelegate : NSObjectProtocol{
    //socket连接成功
    func socketRockeConnectSuccess()
   //发送数据Protocol 'Collection' can only be used as a generic constraint because it has Self or associated type requirements
    func sendData<T>(_ data : T)
}

