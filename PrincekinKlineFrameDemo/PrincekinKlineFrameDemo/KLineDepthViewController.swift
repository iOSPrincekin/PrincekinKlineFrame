//
//  KLineDepthViewController.swift
//  Canonchain
//
//  Created by LEE on 4/12/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit
import Alamofire
import PrincekinKlineFrame
//已占用tag 200~  tableView
public class KLineDepthViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
	
	//买盘
	@IBOutlet weak var buyorderLabel: UILabel!
	//买盘数量label
	@IBOutlet weak var buyAmountLabel: UILabel!
	//价格label
	@IBOutlet weak var priceLabel: UILabel!
	//卖盘数量label
	@IBOutlet weak var saleAmountLabel: UILabel!
	//卖盘
	@IBOutlet weak var saleOrderLabel: UILabel!
	
	public var wSymbol : String = ""
	{
		didSet{
			let strArr = wSymbol.components(separatedBy: "/")
			base = strArr[0];
			quote = strArr[1];
		}
	}
	var base : String = ""
	var quote : String = ""
	public var currencyPairDetailModel : CurrencyPairDetailModel!
	var asksModelArray: [KLineDepthModel]?{
		didSet{
			DispatchQueue.main.async(execute: {
				//  if !PKDepthUIHelper.sharedInstance.scrolling{
				self.saleTableView.reloadData()
				//   }
			})
		}
	}
	var bidsModelArray: [KLineDepthModel]?{
		didSet{
			
			DispatchQueue.main.async(execute: {
				//   if !PKDepthUIHelper.sharedInstance.scrolling{
				self.buyTableView.reloadData()
				//   }
			})
			
			
		}
	}
	
	@IBOutlet weak var buyTableView: UITableView!
	@IBOutlet weak var saleTableView: UITableView!
	//深度图数据处理类
	var wDepthManager : BibiDepthManager?
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		//  fatalError("init(coder:) has not been implemented")
	}
	override public func viewDidLoad() {
		super.viewDidLoad()
		self.title = "DepthChart"
		setUPUI()
		
		//"CZRETH"
		//    let depthManager : BibiDepthManager = BibiDepthManager.createHttpAndSocket(wSymbol,20,.kline,currencyPairDetailModel.priceDecimalsInt)
		let depthManager : BibiDepthManager = BibiDepthManager(currencyPairDetailModel)
		depthManager.sendDataDelegate = self
		wDepthManager = depthManager
		let leftBtnX = 0
		let leftBtnY = 0
		let leftBtnW = 56 + 20
		let leftBtnH = leftBtnW
		
		let leftBtn = UIButton.init(frame: CGRect(x: leftBtnX, y: leftBtnY, width: leftBtnW, height: leftBtnH))
		leftBtn.addTarget(self, action:#selector(backClick) , for: .touchUpInside)
		leftBtn.setImage(UIImage.init(named: "back"), for: .normal)
		leftBtn.contentHorizontalAlignment = .left;
		let leftItem = UIBarButtonItem.init(customView: leftBtn)
		self.navigationItem.leftBarButtonItem = leftItem
	}
	@objc
	func backClick() {
		print("backClick--------")
		navigationController?.popViewController(animated: true);
	}
	func setUPUI()  {
		buyorderLabel.text = "Buy Order"
		buyAmountLabel.text = String.init(format: "Amount(%@)",base)
		priceLabel.text = String.init(format: "Price(%@)", quote)
		saleAmountLabel.text = String.init(format: "Amount(%@)", base)
		saleOrderLabel.text = "Sell Order"
	}
	override public func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		//深度图的socket推送彻底销毁
		wDepthManager!.destroyTSocketRocke()
		wDepthManager = nil
		
	}
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if tableView.tag == 200 {
			return (bidsModelArray?.count == nil) ? 0 : bidsModelArray!.count
		}else{
			return (asksModelArray?.count == nil) ? 0 : asksModelArray!.count
		}
	}
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if tableView.tag == 200 {
			let DepthBuyTableViewCellIdentifier = "DepthBuyTableViewCellIdentifier"
			
			var  buyTableViewCell : DepthBuyTableViewCell? = tableView.dequeueReusableCell(withIdentifier: DepthBuyTableViewCellIdentifier) as? DepthBuyTableViewCell
			if  buyTableViewCell == nil {
				buyTableViewCell = DepthBuyTableViewCell.returnDepthBuyTableViewCell()
			}
			buyTableViewCell?.amountdigit = Int(currencyPairDetailModel.amountDecimals)!
			buyTableViewCell?.setUPCellWithKLineDepthModel(model: bidsModelArray![indexPath.row])
			buyTableViewCell?.isOpaque = false
			//            buyTableViewCell?.layer.shouldRasterize = true
			//            buyTableViewCell?.layer.rasterizationScale = UIScreen.main.scale
			return buyTableViewCell!
		}else{
			let DepthSaleTableViewCellIdentifier = "DepthSaleTableViewCellIdentifier"
			
			var  saleTableViewCell : DepthSaleTableViewCell? = tableView.dequeueReusableCell(withIdentifier: DepthSaleTableViewCellIdentifier) as? DepthSaleTableViewCell
			if  saleTableViewCell == nil {
				saleTableViewCell = DepthSaleTableViewCell.returnDepthSaleTableViewCell()
			}
			saleTableViewCell?.amountdigit = Int(currencyPairDetailModel.amountDecimals)!
			saleTableViewCell?.setUPCellWithKLineDepthModel(model: asksModelArray![indexPath.row])
			saleTableViewCell?.isOpaque = false
			//            saleTableViewCell?.layer.shouldRasterize = true
			//            saleTableViewCell?.layer.rasterizationScale = UIScreen.main.scale
			return saleTableViewCell!
		}
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 24
	}
	override public func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	deinit {
		
	}
}
extension KLineDepthViewController: BibiDepthManagerSendDataDelegate{
	public func sendData(asksModelArray: [KLineDepthModel]?, bidsModelArray: [KLineDepthModel]?) {
		//    print("返回的数据是----55555------------\(asksModelArray)------\(bidsModelArray)-------\(Thread.current)")
		
		self.asksModelArray = asksModelArray
		self.bidsModelArray = bidsModelArray
	}
	
	
}

