//
//  ViewController.swift
//  PrincekinKlineFrameDemo
//
//  Created by LEE on 9/27/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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
      
        
        
    }
    @IBAction func FullScreenVCClick(_ sender: UIButton) {
        let fullScreenVC = PKFullScreenKLineViewController()
        navigationController?.pushViewController(fullScreenVC, animated: true)
    }
    
}

