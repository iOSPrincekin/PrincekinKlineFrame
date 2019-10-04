

//
//  PKTimerManager.swift
//  Canonchain
//
//  Created by LEE on 4/18/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit

class PKTimerManager: NSObject {
    var queue = DispatchQueue.global(qos: .default)
    var timerHelperDictionary : [String:PKTimerHelper] = [String:PKTimerHelper]()
    //用于存放临时定时器 增加强引用  驱动定时器
    var tempTimerArray = [DispatchSource]()
    
    static let sharedInstance = PKTimerManager()
    private  override init() {}
    
    
    func createTimerHelperWithHelperID(helperID:String) -> PKTimerHelper  {
        var timerHelper : PKTimerHelper? = timerHelperDictionary[helperID]
        if timerHelper == nil{
            timerHelper = PKTimerHelper()
            timerHelper?.helperID = helperID
            timerHelperDictionary[helperID] = timerHelper
        }
        return timerHelper!
    }
    
    
    func removeTimerHelperWithHelperID(helperID:String) {
        timerHelperDictionary.removeValue(forKey: helperID)
    }
    //创建一个简单的倒计时，供测试时使用
    class func createCountDownTimer(_ interval : Int,_ completeBlcok : @escaping ()->Void)  {
        // 定义需要计时的时间
        var timeCount = interval
        // 在global线程里创建一个时间源
        let codeTimer = DispatchSource.makeTimerSource(queue:      DispatchQueue.global())
        // 设定这个时间源是每秒循环一次，立即开始
        codeTimer.schedule(deadline: .now(), repeating: .seconds(1))
        // 设定时间源的触发事件
        codeTimer.setEventHandler(handler: {
            // 每秒计时一次
            timeCount = timeCount - 1
            // 时间到了取消时间源
            if timeCount <= 0 {
                codeTimer.cancel()
            }
            // 返回主线程处理一些事件，更新UI等等
            DispatchQueue.main.async {
             completeBlcok()
            }
        })
        // 启动时间源
        codeTimer.resume()
        
    
    }

    
    
 
}
//注意：PKTimerHelper对象必须作为属性，否则无法启动
class PKTimerHelper: NSObject {
    var minuteNumber : Int?
    var secondNumber : Int?
    var wTimer : DispatchSource?
    var helperID : String?
    typealias PKTimerHelperBlock = (_ minuteNumber : Int,_ secondNumber : Int) -> Void
    var timerHelperBlock : PKTimerHelperBlock?
    
    override init() {
        super.init()
        createTimer()
    }
    
    func createTimer() {
        let pageStepTime: DispatchTimeInterval = .seconds(1)
        var totalNumber : Int = 900
        weak var weakSelf = self
        if wTimer == nil {
          
            wTimer = DispatchSource.makeTimerSource(queue: PKTimerManager.sharedInstance.queue) as? DispatchSource
            wTimer?.schedule(deadline: .now(), repeating: pageStepTime )
            wTimer?.setEventHandler {
                totalNumber -= 1
                if totalNumber < 0{
                    PKTimerManager.sharedInstance.timerHelperDictionary.removeValue(forKey: (weakSelf?.helperID)!)
                    print("\(String(describing: weakSelf?.wTimer))--------\(String(describing: weakSelf))")
                    return
                }
                weakSelf?.minuteNumber = totalNumber / 60
                weakSelf?.secondNumber = totalNumber % 60
                DispatchQueue.main.async(execute: {
                 weakSelf?.timerHelperBlock?((weakSelf?.minuteNumber)!,(weakSelf?.secondNumber)!)
                })
               
            
            }
            // 启动定时器
            wTimer?.resume()
        } 
    }
    //每间隔一段时间执行  主线程   类方法 直到程序结束才会销毁
   class func createTimerByInterval(_ interval : Int,_ IntimeBlcok : @escaping ()->Void) {
        let pageStepTime: DispatchTimeInterval = .milliseconds(interval)
    
          let timer = DispatchSource.makeTimerSource(queue: PKTimerManager.sharedInstance.queue) as! DispatchSource
            PKTimerManager.sharedInstance.tempTimerArray.append(timer)
    timer.schedule(deadline: .now(), repeating: pageStepTime )
            timer.setEventHandler {
                DispatchQueue.main.async(execute: {
                    IntimeBlcok()
                })
            }
            // 启动定时器
            timer.resume()
        }
    
    //每间隔一段时间执行  其他线程  类方法 直到程序结束才会销毁
   class func asyncTimerByInterval(_ interval : Int,_ IntimeBlcok : @escaping ()->Void) {
        let pageStepTime: DispatchTimeInterval = .milliseconds(interval)
    let timer = DispatchSource.makeTimerSource(queue: PKTimerManager.sharedInstance.queue) as! DispatchSource
    PKTimerManager.sharedInstance.tempTimerArray.append(timer)
    timer.schedule(deadline: .now(), repeating: pageStepTime )
    timer.setEventHandler {
            IntimeBlcok()
    }
    }
    //每间隔一段时间执行  其他线程   对象方法
    func asyncTimerByInterval(_ interval : Int,_ IntimeBlcok : @escaping ()->Void) {
        let pageStepTime: DispatchTimeInterval = .milliseconds(interval)
        let timer = DispatchSource.makeTimerSource(queue: PKTimerManager.sharedInstance.queue) as! DispatchSource
        wTimer = timer
     //   PKTimerManager.sharedInstance.tempTimerArray.append(timer)
        timer.schedule(deadline: .now(), repeating: pageStepTime )
        timer.setEventHandler {
            IntimeBlcok()
        }
    // 启动定时器
    timer.resume()
    }
    
    func deinitTimer() {
        wTimer?.cancel()
        wTimer = nil
    }
    deinit {
    
        deinitTimer()
        print("销毁了")
    }
}
    
    
    
    
    
    


