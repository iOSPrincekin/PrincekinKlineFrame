//
//  CanonchainVCCenter.swift
//  Canonchain
//
//  Created by LEE on 3/23/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit

@objc
open class CanonchainVCCenter: NSObject {
    enum SwitchVCType : Int{
        case push
        case pop
    }
    //标记行情VC
//    var marketVC : WFSMarketViewController?{
//        get{
//            return CanonchainVCCenter.getViewController(WFSMarketViewController.self) as! WFSMarketViewController
//        }
//    }
    
   
    //当前VC的状态，是pop  或  push
    var switchVCType : SwitchVCType?
    //整个App当前显示的VC
     @objc open var nowShowVC : UIViewController?

    
    //全局获取VC       类名必须正确
    var VCDictionary = [String:UIViewController]()
    static let sharedInstance = CanonchainVCCenter()
    private  override init() {}
    @objc open class   func sharedCanonchainVCCenter() -> CanonchainVCCenter{
        return sharedInstance
    }
    public class func getViewController(_ VCClass:UIViewController.Type) -> UIViewController {
        let VCString:String = NSStringFromClass(VCClass)
        var VC = sharedInstance.VCDictionary[VCString]
        if VC == nil {
            VC = VCClass.init()
            sharedInstance.VCDictionary[VCString] = VC
        }
        return VC!
    }

    func changeTabbarVC() {

    }
}
