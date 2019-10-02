//
//  CountryModelGroup.swift
//  Canonchain
//
//  Created by LEE on 5/17/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit
import RealmSwift
class CountryModelGroup: NSObject {
    static let sharedInstance = CountryModelGroup()
    private override init() {}
    @objc dynamic var groupId = 0
    @objc dynamic var countrys : [CountryModel]? = nil
    @objc dynamic var countryList : [CountryModel]?{
        set{
            
        }
        get{

            return countrys
        }
    }
    func searchCountryModelWithName(_ countryName : String) -> CountryModel {
        return  (countryList?.filter{ model in
            return model.country == countryName
            
            }.first)!
    }
}
