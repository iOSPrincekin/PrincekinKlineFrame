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
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        klineView.wSymbol = "BTC/USDT"
    }
}
