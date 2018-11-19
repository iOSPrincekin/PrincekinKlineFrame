

//
//  PKFullScreenKLineViewController.swift
//  Canonchain
//
//  Created by LEE on 7/19/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit
import PrincekinKlineFrame
class PKFullScreenKLineViewController: UIViewController {
   weak var kLinePortraitVC : PKKLinePortraitViewController!
     var klineArray : [PKKLine]?
    @IBOutlet var fullView: PKKLineFullScreenView!
    override func viewDidLoad() {
        super.viewDidLoad()
        fullView.bottomButtonClickDelegate = self
        weak var weakSelf = self
        fullView.closeBlock = {
            weakSelf!.dismiss(animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
  
    }
    func reloadData(klineArray : [PKKLine]) {
         fullView.reloadData(klineArray: klineArray)
    }
    func appendData(klineArray : [PKKLine]) {
        fullView.appendData(klineArray: klineArray)
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

//        if #available(iOS 10.0, *) {
//            (UIApplication.shared.delegate as! AppDelegate).interfaceOrientation = .landscape
//        } else {
//            // Fallback on earlier versions
//        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
          reloadData(klineArray: klineArray ?? [PKKLine]())
      //  UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        let nav : WFSNavigationViewController = self.navigationController as! WFSNavigationViewController
//        nav.supportLandscape = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //更新topView信息
    func updateVlaues(symbol : String,virtualPriceString : String,upOrDownString : String,legalPriceString : String, HString : String, LString : String,TwentyFourHString : String) {
        fullView.updateVlaues(symbol: symbol, virtualPriceString: virtualPriceString,upOrDownString : upOrDownString, legalPriceString: legalPriceString, HString: HString, LString: LString, TwentyFourHString: TwentyFourHString)
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .landscapeRight
    }
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return .landscapeRight
    }
    
    
    deinit {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension PKFullScreenKLineViewController : FullScreenButtonClickDelegate {
    func indexButtonClick(_ str: String) {
      
    }
    
    func buttonClick(_ title: String) {
    //    print("当前点击的title是------\(title)")
       
    }
    
    
}

