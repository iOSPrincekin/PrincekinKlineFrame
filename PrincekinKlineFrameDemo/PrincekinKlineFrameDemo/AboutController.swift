//
//  AboutController.swift
//  PrincekinKlineFrameDemo
//
//  Created by LEE on 12/29/19.
//  Copyright © 2019 LEE. All rights reserved.
//


import UIKit
class AboutController: UIViewController {
	@IBOutlet weak var versionLabel: UILabel!
	override func viewDidLoad() {
		super.viewDidLoad();
		self.title = "About";
		
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
		
		//First get the nsObject by defining as an optional anyObject
		let nsObject: AnyObject? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject?

		//Then just cast the object as a String, but be careful, you may want to double check for nil
		let version = nsObject as! String
		
		print("version----------\(version)");
		self.versionLabel.text = "Version:      \(version)";
	}
	@objc
	func backClick() {
		print("backClick--------")
		navigationController?.popViewController(animated: true);
	}
}
