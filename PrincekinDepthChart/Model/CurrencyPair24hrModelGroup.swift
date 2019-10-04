//
//  CurrencyPair24hrModelGroup.swift
//  Canonchain
//
//  Created by LEE on 6/11/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit

class CurrencyPair24hrModelGroup: NSObject {
    static let sharedInstance = CurrencyPair24hrModelGroup()
    private override init() {}
    @objc dynamic var currencyPair24hrModelList = [CurrencyPair24hrModel]()
}
