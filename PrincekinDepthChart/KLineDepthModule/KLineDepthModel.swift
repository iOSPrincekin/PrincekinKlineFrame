//
//  KLineDepthModel.swift
//  Canonchain
//
//  Created by LEE on 7/23/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit

public class KLineDepthModel: NSObject{
    var price:String = ""
    var amount:Double = 0.0
    var serial:Int = 0
    var percentage:CGFloat = 0.0
 
    
}

class KLineDepthEmptyModel: KLineDepthModel{

    
}

extension KLineDepthModel: NSCopying{
	public func copy(with zone: NSZone? = nil) -> Any {
        let copy = KLineDepthModel()
        copy.price = price
        copy.amount = amount
        return copy
    }
}
extension KLineDepthModel {
    convenience init(array : [Any]) {
        self.init()
        price = array[0] as! String
        amount = Double(array[1] as! String)!
    }
    convenience init(dict : (key: String, value: Double)) {
        self.init()
        price = dict.key
        amount = dict.value
    }
    
}
