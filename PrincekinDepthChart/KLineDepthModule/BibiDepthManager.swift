//
//  BibiDepthManager.swift
//  Canonchain
//
//  Created by LEE on 7/24/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit
import OHHTTPStubs
import PrincekinKlineFrame
//此类用于行情模块深度图数据的请求与返回
/*
1.获取http的数据并返回
2.获取socket数据并返回，当前数据处理在主线程，观察是否有崩机情况
3.开辟新线程，处理卡顿问题
4.检测销毁情况



*/

public class BibiDepthManager: NSObject {
	public var sendDataDelegate : BibiDepthManagerSendDataDelegate!
		//socket连接类
		
		{
		didSet{
			getDepthDataByHttp()
		}
	}
	var tSocketRocke : SocketRocketTest!
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
	
	//处理数据的的队列，异步串行
	// let dealDataQueue : DispatchQueue = DispatchQueue(label: BibiDepthManagerDealDepthDataQueue)
	
	
	//线程同步保证数据的安全  鉴于 dealDataQueue.async(execute: dealDepthDataTask)效率太慢，使用信号量
	let semaphore = DispatchSemaphore(value: 1)
	// let queue = DispatchQueue.global(qos: .default)
	let queue = DispatchQueue(label: BibiDepthManagerDealDepthDataQueue)
	
	
	//初始化的数据源
	var currencyPairDetailModel : CurrencyPairDetailModel!
	
	var asksDepthModelGroup : AsksKLineDepthModelGroup!
	var bidsDepthModelGroup : BidsKLineDepthModelGroup!
	init(_ currencyPairDetailModel : CurrencyPairDetailModel!) {
		super.init()
		PKTimerHelper().timerHelperBlock = { v1,v2 in
			//            print(v1,v2)
		}
		self.currencyPairDetailModel = currencyPairDetailModel
		let optins : [KLineDepthModelGroupOption] = [.dealtArrayCount(20),.modelPriceDepth(currencyPairDetailModel.defalutdepthMergeUnit!),.modelPriceTotaldigit(currencyPairDetailModel.priceDecimalsInt)]
		asksDepthModelGroup = AsksKLineDepthModelGroup.init(groupOPtion: optins)
		bidsDepthModelGroup = BidsKLineDepthModelGroup.init(groupOPtion: optins)
	}
	var tstTarger = 0
	func createGetDepthDataByHttpStub() {
		
		stub(condition: isHost(iOSPrincekinTestBaseURLHost)) {
			req in
			print(req)
			let dataDic = ["asks":[["298.84300000", "0.00080000"], ["298.84320000", "0.00870000"], ["298.84330000", "0.00450000"], ["298.84340000", "0.00550000"], ["298.84360000", "0.01500000"], ["298.84380000", "0.00890000"], ["298.84400000", "0.00320000"], ["298.84410000", "0.01930000"], ["298.84420000", "0.00150000"], ["298.84440000", "0.01030000"], ["298.84450000", "0.00810000"], ["298.84460000", "0.00980000"], ["298.84470000", "0.01130000"], ["298.84480000", "0.00020000"], ["298.84490000", "0.00260000"], ["298.84500000", "0.00530000"], ["298.84530000", "0.00830000"], ["298.84570000", "0.03120000"], ["298.84580000", "0.02000000"], ["298.84590000", "0.02270000"], ["298.84600000", "0.00480000"], ["298.84610000", "0.00420000"], ["298.84620000", "0.02700000"], ["298.84670000", "0.00620000"], ["298.84690000", "0.02330000"], ["298.84700000", "0.01940000"], ["298.84730000", "0.01480000"], ["298.84740000", "0.00970000"], ["298.84750000", "0.00130000"], ["298.84760000", "0.00040000"], ["298.84780000", "0.00310000"], ["298.84790000", "0.00600000"], ["298.84800000", "0.01180000"], ["298.84810000", "0.01200000"], ["298.84850000", "0.00840000"], ["298.84860000", "0.03260000"], ["298.84890000", "0.00890000"], ["298.84900000", "0.00860000"], ["298.84910000", "0.01180000"], ["298.84950000", "0.00660000"], ["298.84960000", "0.00660000"], ["298.84980000", "0.00260000"], ["298.84990000", "0.01110000"], ["298.85000000", "0.00950000"], ["298.85010000", "0.01670000"], ["298.85020000", "0.01830000"], ["298.85050000", "0.01210000"], ["298.85060000", "0.01110000"], ["298.85070000", "0.00410000"], ["298.85080000", "0.01550000"], ["298.85090000", "0.01030000"], ["298.85110000", "0.00700000"], ["298.85120000", "0.00050000"], ["298.85130000", "0.00040000"], ["298.85140000", "0.01860000"], ["298.85160000", "0.00160000"], ["298.85200000", "0.00680000"], ["298.85220000", "0.01080000"], ["298.85230000", "0.01090000"], ["298.85250000", "0.00890000"], ["298.85270000", "0.01000000"], ["298.85290000", "0.00410000"], ["298.85300000", "0.01720000"], ["298.85310000", "0.00700000"], ["298.85330000", "0.00940000"], ["298.85340000", "0.00180000"], ["298.85360000", "0.01920000"], ["298.85370000", "0.00090000"], ["298.85390000", "0.00720000"], ["298.85420000", "0.01340000"], ["298.85430000", "0.01060000"], ["298.85450000", "0.01070000"], ["298.85480000", "0.00560000"], ["298.85490000", "0.00820000"], ["298.85510000", "0.00040000"], ["298.85520000", "0.00170000"], ["298.85530000", "0.01540000"], ["298.85540000", "0.00050000"], ["298.85610000", "0.00730000"], ["298.85620000", "0.01000000"], ["298.85630000", "0.00180000"], ["298.85640000", "0.00700000"], ["298.85650000", "0.00870000"], ["298.85680000", "0.01230000"], ["298.85720000", "0.00050000"], ["298.85750000", "0.00290000"], ["298.85760000", "0.00820000"], ["298.85780000", "0.00710000"], ["298.85800000", "0.01880000"], ["298.85810000", "0.01020000"], ["298.85820000", "0.01160000"], ["298.85830000", "0.00270000"], ["298.85860000", "0.01040000"], ["298.85870000", "0.00340000"], ["298.85910000", "0.00060000"], ["298.85920000", "0.01400000"], ["298.85930000", "0.01600000"], ["298.85950000", "0.01250000"], ["298.85960000", "0.01620000"], ["298.85970000", "0.00420000"]],"bids":[["298.84220000", "0.00250000"], ["298.39000000", "0.01050000"], ["298.38690000", "0.01130000"], ["298.38550000", "0.00910000"], ["298.38510000", "0.00430000"], ["298.38450000", "0.00710000"], ["298.38430000", "0.01230000"], ["298.38260000", "0.00060000"], ["298.38220000", "0.00920000"], ["298.38180000", "0.00330000"], ["298.38120000", "0.00610000"], ["298.38080000", "0.00820000"], ["298.38000000", "0.00440000"], ["298.37930000", "0.00460000"], ["298.37920000", "0.01040000"], ["298.37860000", "0.01000000"], ["298.37820000", "0.01180000"], ["298.37790000", "0.00100000"], ["298.37730000", "0.00400000"], ["298.37670000", "0.01050000"], ["298.37600000", "0.00890000"], ["298.37490000", "0.00010000"], ["298.37480000", "0.00330000"], ["298.37360000", "0.00450000"], ["298.37320000", "0.00140000"], ["298.37120000", "0.00850000"], ["298.37040000", "0.00030000"], ["298.36910000", "0.00490000"], ["298.36880000", "0.00540000"], ["298.36640000", "0.01100000"], ["298.36620000", "0.01080000"], ["298.36610000", "0.01020000"], ["298.36580000", "0.00150000"], ["298.36340000", "0.00590000"], ["298.36310000", "0.01180000"], ["298.36220000", "0.01050000"], ["298.36130000", "0.00250000"], ["298.36010000", "0.00780000"], ["298.35950000", "0.00200000"], ["298.35770000", "0.00480000"], ["298.35660000", "0.00860000"], ["298.35560000", "0.01080000"], ["298.35080000", "0.00950000"], ["298.34840000", "0.01420000"], ["298.34750000", "0.00180000"], ["298.34620000", "0.00060000"], ["298.34360000", "0.01100000"], ["298.34300000", "0.00500000"], ["298.34270000", "0.01130000"], ["298.34170000", "0.00170000"], ["298.34060000", "0.00560000"], ["298.34030000", "0.00690000"], ["298.33720000", "0.01230000"], ["298.33630000", "0.00630000"], ["298.33580000", "0.00100000"], ["298.33270000", "0.00660000"], ["298.33220000", "0.00840000"], ["298.33190000", "0.00880000"], ["298.32950000", "0.00050000"], ["298.32860000", "0.01080000"], ["298.32790000", "0.00430000"], ["298.32730000", "0.01260000"], ["298.32640000", "0.00110000"], ["298.32580000", "0.00060000"], ["298.32100000", "0.00540000"], ["298.31830000", "0.01100000"], ["298.31800000", "0.00460000"], ["298.31710000", "0.00880000"], ["298.31560000", "0.01740000"], ["298.31520000", "0.00580000"], ["298.30900000", "0.00400000"], ["298.30660000", "0.01350000"], ["298.30540000", "0.00030000"], ["298.30510000", "0.00690000"], ["298.30450000", "0.00600000"], ["298.30290000", "0.01160000"], ["298.30230000", "0.00250000"], ["298.30150000", "0.00770000"], ["298.30140000", "0.00040000"], ["298.30120000", "0.01180000"], ["298.30090000", "0.00750000"], ["298.29920000", "0.00470000"], ["298.29840000", "0.01020000"], ["298.29790000", "0.00840000"], ["298.29640000", "0.00520000"], ["298.29460000", "0.01160000"], ["298.29360000", "0.01010000"], ["298.29340000", "0.00030000"], ["298.29200000", "0.00570000"], ["298.28980000", "0.00740000"], ["298.28890000", "0.01230000"], ["298.28710000", "0.00440000"], ["298.28700000", "0.00730000"], ["298.28610000", "0.01450000"], ["298.28550000", "0.01220000"], ["298.28450000", "0.01160000"], ["298.27870000", "0.00790000"], ["298.27780000", "0.00060000"], ["298.27740000", "0.00030000"], ["298.27690000", "0.00400000"]]]
			
			let stubData = try! JSONSerialization.data(withJSONObject: dataDic, options: .prettyPrinted)
			//   let stubData = "Hello World!".data(using: String.Encoding.utf8)
			return OHHTTPStubsResponse(data: stubData, statusCode:200, headers:nil).responseTime(2)
		}
	}
	//通过http请求拉取Socket数据
	func getDepthDataByHttp() {
		createGetDepthDataByHttpStub()
		var param : [String : Any] = [String : Any]()
		param["symbol"] = "BTCUSDT"
		param["limit"] = 100
		let urlString = iOSPrincekinTestBaseURL
		PKAlamofire.getResponseDataInTestTarget(urlString,param) { response in
			//  print(response)
			let data = response.value
			let dataDic : [String : Any] = try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : Any]
			
			let asksArray : [[String]]? = dataDic["asks"] as? [[String]]
			let bidsArray : [[String]]? = dataDic["bids"] as? [[String]]
			print("asksArray--\(asksArray)--bidsArray--\(bidsArray)")
			self.temp_asksArray = asksArray
			self.temp_bidsArray = bidsArray
			//   self.getHttpLastId = dataDic!["lastUpdateId"] as? Int
			if self.temp_asksArray != nil{
				self.asksDepthModelGroup.initData(array: self.temp_asksArray!)
			}
			
			if self.temp_bidsArray != nil{
				self.bidsDepthModelGroup.initData(array: self.temp_bidsArray!)
			}
			self.sendDataDelegate.sendData(asksModelArray: self.asksDepthModelGroup.dealtDepthModelArray, bidsModelArray: self.bidsDepthModelGroup.dealtDepthModelArray)
			
			
			self.semaphore.signal()
			self.setUPSocketAndConnect()
			
		}
	}
	//进行socket请求
	func setUPSocketAndConnect() {
		if tSocketRocke == nil {
			//  ws://192.168.10.220:8070/ws/diff_depth@BTCUSDT
			let urlString = iOSPrincekinTest_Depth_URL
			let socketRocke = SocketRocketTest.init(urlString)
			socketRocke.socketDelegate = self
			tSocketRocke = socketRocke
		}else{
			tSocketRocke?.turnOnData()
		}
		
	}
	deinit {
	}
}
extension BibiDepthManager : PKSocketRockeTestDelegate{
	
	
	public func socketRockeConnectSuccess() {
		
	}
	/*
	这里涉及到多线程的同步操作，较为复杂
	1.当第一次进入时，有可能满足条件和不满足条件
	(1).如果满足，默认操作
	(2).如果不满足，则进行重连操作
	
	*/
	//将socket推送过来的数据添加到源数据中
	
	public func sendData<T>(_ data: T) {
		let dic : [String : Any] = data as! [String : Any]
		//   WLog("数据---\(dic)")
		var asksArray : [[String]]? = dic["a"] as? [[String]]
		let bidsArray  : [[String]]? = dic["b"] as? [[String]]
		self.getHttpLastId = 2
		self.pushSocketNewstId_u = 3
		self.pushSocketNewstId_U = 3
		
		//       The first processed should have U <= lastUpdateId+1 AND u >= lastUpdateId+1
		
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
				self.pushSocketLastId_u = 2
				self.pushSocketNewstId_U = 3
				if self.pushSocketNewstId_U! == self.pushSocketLastId_u! + 1 {
					
				}else{
					self.reConnect()
					
					return
				}
			}
			self.pushSocketLastId_u = self.pushSocketNewstId_u
			if asksArray != nil {
				if asksArray!.count > 0 {
					self.asksDepthModelGroup.appendData(array: asksArray!)
				}
			}
			if bidsArray != nil {
				if bidsArray!.count > 0 {
					self.bidsDepthModelGroup.appendData(array: bidsArray!)
				}
			}
			self.sendDataDelegate.sendData(asksModelArray: self.asksDepthModelGroup.dealtDepthModelArray, bidsModelArray: self.bidsDepthModelGroup.dealtDepthModelArray)
			self.firstConnctHttp = false
			self.semaphore.signal()
		})
		
	}
	
	
	//断线重连
	func reConnect() {
		//阻断数据
		self.tSocketRocke.turnOffData()
		self.semaphore.signal()
		//  sleep(2)
		
		//        DispatchQueue.main.async(execute: {
		//            self.getDepthDataByHttp()
		//        })
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
			self.getDepthDataByHttp()
		}
		//    self.semaphore.signal()
	}
	//销毁socket  以便于进行释放self
	public func destroyTSocketRocke() {
		
		tSocketRocke = nil
	}
}
//深度manager发送数据的协议
public protocol BibiDepthManagerSendDataDelegate {
	func sendData( asksModelArray : [KLineDepthModel]?,bidsModelArray : [KLineDepthModel]?)
}
