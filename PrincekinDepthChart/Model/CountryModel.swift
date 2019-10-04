//
//  CountryModel.swift
//  Canonchain
//
//  Created by LEE on 5/15/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit
import RealmSwift
class CountryModel: NSObject {
    @objc dynamic var countryNum : Int = 0
    @objc dynamic var country : String = ""
    
   convenience init(nameAndNumString : String) {
        self.init()
        let strArr = nameAndNumString.components(separatedBy: "+")
        self.country = strArr.first!.replacingOccurrences(of: " ", with: "")
        self.countryNum = Int(strArr.last!.replacingOccurrences(of: " ", with: ""))!
    }
}

