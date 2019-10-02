//
//  WFSUser.swift
//  Canonchain
//
//  Created by LEE on 5/17/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit
import RealmSwift
class WFSUser: NSObject {
    @objc dynamic var createTime : String = ""
    @objc dynamic var emailAddress : String = ""
    @objc dynamic var emailAddressAuth : Bool = false
    @objc dynamic var enableModifyNickName : Bool = false
    @objc dynamic var hasAdminPwd : Bool = false
    @objc dynamic var hasGoogleAuthCode : Bool = false
    @objc dynamic var enableGoogleAuthCode : Bool = false
    @objc dynamic var mobile : String = ""
    @objc dynamic var mobileAuth : Bool = false
    @objc dynamic var countryNum : Int = 0
    @objc dynamic var nickName : String = ""
    @objc dynamic var userId : CLongLong = 0
    @objc dynamic var token : String = ""
}
