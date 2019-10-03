//
//  MultiBibiDepthManager.swift
//  Canonchain
//
//  Created by LEE on 7/24/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit
/*
 对于多个Group  manager的开发步骤
 1.实现单个Manger所具有的功能
 2.实现修改深度图价格位数的功能
 3.更新最新挂单价格
 4.检测销毁情况
 */
class MultiBibiDepthManager: NSObject {

    var sendDataDelegate : MultiBibiDepthManagerSendDataDelegate!
        //socket连接类
        
        {
        didSet{
            getDepthDataByHttp()
        }
    }
    var tSocketRocke : PKSocketRocke!
  
    //临时的数据存储  符合条件后再添加
    var temp_asksArray : [[String]]?
    var temp_bidsArray : [[String]]?
    //第一次连接或者重新连接http
    var firstConnctHttp = true
    //Last update ID
    var getHttpLastId : Int! = 0
    //  First update ID in event
    var pushSocketNewstId_U : Int! = 0
    // Final update ID in event
    var pushSocketNewstId_u : Int! = 0
    //上一次的 Final update ID in event 用于核查数据，不准则断线重连
    var pushSocketLastId_u : Int! = 0
    
    //线程同步保证数据的安全
    let semaphore = DispatchSemaphore(value: 1)
    let queue = DispatchQueue.global(qos: .default)
    
    //初始化的数据源
    var currencyPairDetailModel : CurrencyPairDetailModel!
    //包含5个model的卖盘ModelGroup
    var asksFiveDepthModelGroup : AsksKLineDepthModelGroup!
    //包含5个model的买盘ModelGroup
    var bidsFiveDepthModelGroup : BidsKLineDepthModelGroup!
    //包含10个model的卖盘ModelGroup
    var asksTenDepthModelGroup : AsksKLineDepthModelGroup!
    //包含10个model的买盘ModelGroup
    var bidsTenDepthModelGroup : BidsKLineDepthModelGroup!
    init(_ currencyPairDetailModel : CurrencyPairDetailModel!) {
        super.init()
        self.currencyPairDetailModel = currencyPairDetailModel
        //包含5个model的group进行初始化
        let fiveModelOptins : [KLineDepthModelGroupOption] = [.dealtArrayCount(5),.modelPriceDepth(currencyPairDetailModel.defalutdepthMergeUnit!),.modelPriceTotaldigit(currencyPairDetailModel.priceDecimalsInt)]
        asksFiveDepthModelGroup = AsksKLineDepthModelGroup.init(groupOPtion: fiveModelOptins)
        bidsFiveDepthModelGroup = BidsKLineDepthModelGroup.init(groupOPtion: fiveModelOptins)
        ////包含10个model的group进行初始化
        let tenModelOptins : [KLineDepthModelGroupOption] = [.dealtArrayCount(10),.modelPriceDepth(currencyPairDetailModel.defalutdepthMergeUnit!),.modelPriceTotaldigit(currencyPairDetailModel.priceDecimalsInt)]
        asksTenDepthModelGroup = AsksKLineDepthModelGroup.init(groupOPtion: tenModelOptins)
        bidsTenDepthModelGroup = BidsKLineDepthModelGroup.init(groupOPtion: tenModelOptins)
    }
    
    //通过http请求拉取Socket数据
    func getDepthDataByHttp() {
        firstConnctHttp = true
        let param : NSMutableDictionary = NSMutableDictionary()
        param["symbol"] = currencyPairDetailModel.symbol
        param["limit"] = 100
        let urlString : String = wGetDepthDataHttpURLString
        PKAlamofire.getDataWithURLStringAndParameterDic(urlString, param) {response in
            
            let dataDic : NSDictionary? = response.value as? NSDictionary
            
            if dataDic == nil || (dataDic?.isEqual(NSNull.init()))!{
                self.semaphore.signal()
                
                self.setUPSocketAndConnect()
                
                return
            }
            
            let asksArray : [[String]]? = dataDic!["asks"] as? [[String]]
            let bidsArray : [[String]]? = dataDic!["bids"] as? [[String]]
            self.temp_asksArray = asksArray
            self.temp_bidsArray = bidsArray
            self.getHttpLastId = dataDic!["lastUpdateId"] as? Int
            
            if self.temp_asksArray != nil{
                self.asksFiveDepthModelGroup.initData(array: self.temp_asksArray!)
                self.asksTenDepthModelGroup.initData(array: self.temp_asksArray!)
            }
            if self.temp_bidsArray != nil{
                self.bidsFiveDepthModelGroup.initData(array: self.temp_bidsArray!)
                self.bidsTenDepthModelGroup.initData(array: self.temp_bidsArray!)
            }
            self.sendGroupDataDic()
            self.semaphore.signal()
            self.setUPSocketAndConnect()
        }
        
    }
    
    //进行socket请求
    func setUPSocketAndConnect() {
        if tSocketRocke == nil {
            //  ws://192.168.10.220:8070/ws/diff_depth@BTCUSDT
            let urlString = "ws://192.168.10.220:8070/ws/diff_depth@\(currencyPairDetailModel.symbol)"
            let socketRocke = PKSocketRocke.init(urlString)
            socketRocke.socketDelegate = self
            tSocketRocke = socketRocke
        }else{
            tSocketRocke?.turnOnData()
        }
    }
    //销毁socket  以便于进行释放self
    func destroyTSocketRocke() {
        tSocketRocke?.disConnect()
        tSocketRocke = nil
    }
    deinit {
        
    }
}
extension MultiBibiDepthManager : PKSocketRockeDelegate{
    func socketRockeConnectSuccess() {
        
    }
    //将socket推送过来的数据添加到源数据中
    func sendData<T>(_ data: T) {
        let dic : [String : Any] = data as! [String : Any]
        //   
        var asksArray : [[String]]? = dic["a"] as? [[String]]
        let bidsArray  : [[String]]? = dic["b"] as? [[String]]
        self.pushSocketNewstId_u = dic["u"] as? Int
        self.pushSocketNewstId_U = dic["U"] as? Int
        
        //       The first processed should have U <= lastUpdateId+1 AND u >= lastUpdateId+1
        //防止断开不及时，数据干扰
        
        //防止漏网的数据，造成误差
        if self.tSocketRocke._turnOffData{
            
            return
        }
        
        
        self.queue.async(execute: {
            self.semaphore.wait()
            //如果已经在重连，则快速释放已在队列中的任务
            if self.tSocketRocke._turnOffData{
                
                self.semaphore.signal()
                return
            }
            
            
            if self.firstConnctHttp {
                
                if self.getHttpLastId == nil{
                    
                    self.reConnect()
                    
                    return
                }
                if self.pushSocketNewstId_U! <= self.getHttpLastId! + 1 && self.pushSocketNewstId_u! >= self.getHttpLastId! + 1{
                    
                }else{
                    
                    
                    self.reConnect()
                    
                    return
                }
            }else{
                
                if self.pushSocketNewstId_U! == self.pushSocketLastId_u! + 1 {
                    
                }else{
                    
                    self.reConnect()
                    
                    return
                }
            }
            self.pushSocketLastId_u = self.pushSocketNewstId_u
            
            
            if asksArray != nil{
          
                self.asksFiveDepthModelGroup.appendData(array: asksArray!)
                self.asksTenDepthModelGroup.appendData(array: asksArray!)
            }
            if bidsArray != nil{
                self.bidsFiveDepthModelGroup.appendData(array: bidsArray!)
                self.bidsTenDepthModelGroup.appendData(array: bidsArray!)
            }
            self.sendGroupDataDic()
             self.firstConnctHttp = false
            self.semaphore.signal()
        })
    }
    //断线重连
    func reConnect() {
        //阻断数据
        
        self.tSocketRocke.turnOffData()
        self.semaphore.signal()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.getDepthDataByHttp()
        }
    }
    //执行代理的方法
    func sendGroupDataDic()  {
        let dataDic :  [String : KLineDepthModelGroup]  = [AsksFiveDepthModelGroupKey : self.asksFiveDepthModelGroup,AsksTenDepthModelGroupKey : self.asksTenDepthModelGroup,BidsFiveDepthModelGroupKey:self.bidsFiveDepthModelGroup,BidsTenDepthModelGroupKey:self.bidsTenDepthModelGroup]
        self.sendDataDelegate.sendDataDictionary(dataDictionary: dataDic)
    }
    
}
extension MultiBibiDepthManager{
    //切换深度图深度
    func changePriceDepthByNum(_ num : Int) {
        self.asksFiveDepthModelGroup.changePriceDepthByNum(num)
        self.asksTenDepthModelGroup.changePriceDepthByNum(num)
        self.bidsFiveDepthModelGroup.changePriceDepthByNum(num)
        self.bidsTenDepthModelGroup.changePriceDepthByNum(num)
        sendGroupDataDic()
    }
}
//深度manager发送数据的协议
protocol MultiBibiDepthManagerSendDataDelegate {
    func sendDataDictionary(dataDictionary : [String : KLineDepthModelGroup])
}

