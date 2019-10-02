//
//  PKKLinePortraitViewController.swift
//  Canonchain
//
//  Created by LEE on 4/11/18.
//  Copyright © 2018 LEE. All rights reserved.
//

//socket推送过来最新价格

import UIKit
//tag占用情况   100~   "深度"和"最新成交"button    //200~   买入和卖出button   //300~  scrollView
class PKKLinePortraitViewController: UIViewController{
    @IBOutlet weak var klineView: PKKLineDemoView!
	weak var _fullVC : PKFullScreenKLineViewController?

	
    override func viewDidLoad() {
        
        super.viewDidLoad()
		klineView.wSymbol = "BTC/USDT"
    }
	//fullVC  右边的“index”按钮的点击事件传递给kLineView
    func clickKlineIndexView(_ str : String) {
        klineView.indexButtonBeClickedBlock!(str)
    }
     //fullVC  底部按钮的点击事件传递给kLineView
    func clickKlineView(_ title : String) {
        klineView.buttonClickBlock(title)
    }
	@IBAction func fullScreen(_ sender: Any) {
	if _fullVC == nil {
	    let fullVC = PKFullScreenKLineViewController()
		_fullVC = fullVC
		fullVC.klineArray = klineView.klineArray
		fullVC.kLinePortraitVC = self;
		klineView.fullVC = fullVC;
		present(fullVC, animated: true, completion: nil)

	}else{
		_fullVC!.klineArray = klineView.klineArray
		present(_fullVC!, animated: true, completion: nil)

		}
	}
	deinit{
      
        klineView.destroyTSocketRocke()
        print("ViewController---销毁了")
    }
}
