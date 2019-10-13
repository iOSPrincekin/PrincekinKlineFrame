//
//  ViewController.swift
//  PrincekinKlineFrameDemo
//
//  Created by LEE on 9/27/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit
import PrincekinKlineFrame
class ViewController: UIViewController {
	var _portaitVC: PKKLinePortraitViewController!
	var _fullVC: PKFullScreenKLineViewController!
	var PKDepthVC : KLineDepthViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func PortraitVCClick(_ sender: UIButton) {
        
        let portaitVC = PKKLinePortraitViewController()
        navigationController?.pushViewController(portaitVC, animated: true)
        _portaitVC = portaitVC;
        
        
    }
    @IBAction func FullScreenVCClick(_ sender: UIButton) {
        let depthVC = KLineDepthViewController()
		depthVC.currencyPairDetailModel = CurrencyPairDetailModel()
        depthVC.wSymbol = "BTC/USDT";
        PKDepthVC = depthVC
		navigationController?.pushViewController(depthVC, animated: true)

    }

		
}

