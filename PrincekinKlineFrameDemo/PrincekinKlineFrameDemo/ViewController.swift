//
//  ViewController.swift
//  PrincekinKlineFrameDemo
//
//  Created by LEE on 9/27/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit

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
    /*
        let sureAction = UIAlertAction.init(title: "确定", style: .default) { (action) in
          UIApplication.shared.openURL(URL(string: "https://github.com/iOSPrincekin/PrincekinKlineFrame")!)
        }
        let tmpAlertVC = UIAlertController.init(title: "提示", message: "需要深度图的同学，动动您的手指star一下吧，稍后将会奉上！", preferredStyle: .alert)
        tmpAlertVC.addAction(sureAction)
        present(tmpAlertVC, animated: true, completion: nil)

*/
        let depthVC = KLineDepthViewController()
		depthVC.currencyPairDetailModel = CurrencyPairDetailModel()
        depthVC.wSymbol = "BTC/USDT";
        PKDepthVC = depthVC
		navigationController?.pushViewController(depthVC, animated: true)

    }

		
}

