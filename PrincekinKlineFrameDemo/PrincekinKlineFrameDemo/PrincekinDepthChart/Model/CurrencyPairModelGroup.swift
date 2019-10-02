

//
//  CurrencyPairModelGroup.swift
//  Canonchain
//
//  Created by LEE on 5/31/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit

class CurrencyPairModelGroup: NSObject {
    static let sharedInstance = CurrencyPairModelGroup()
    private override init() {}
    @objc dynamic var currencyPairModelList = [CurrencyPairModel]()
}
