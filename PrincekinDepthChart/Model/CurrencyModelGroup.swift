

//
//  CurrencyModelGroup.swift
//  Canonchain
//
//  Created by LEE on 5/25/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit

class CurrencyModelGroup: NSObject {
    static let sharedInstance = CurrencyModelGroup()
    private override init() {}
    @objc dynamic var totalBTC = 0.0
    @objc dynamic var totalUSD = 0.0
    @objc dynamic var totalCNY = 0.0
    @objc dynamic var currencyModelList = [CurrencyModel]()
    @objc dynamic var myPositionCurrencyModelList : [CurrencyModel]{
        get{
            return currencyModelList.filter{ model in
                return model.available > 0
            }
        }
    }
    //    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
    //        return ["currencyModelList": "CurrencyModel"]
    //    }
}
