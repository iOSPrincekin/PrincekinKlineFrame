//
//  PKLanguageManager.swift
//  Canonchain
//
//  Created by LEE on 8/1/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit
//关于语言的设置
/*
 1.首先进入App，读取本地存储的语言，根据存储的语言设置App内语言
 2.进入当前MineVC，首先根据languageType设置当前UI显示中文/English
 3.点击切换语言，选择目标语言，如何未选择或者为统一语言则不做任何更改
 4.如果点击了不同语言，则修改languageType，代码切换语言，并更新minevcUI
 
 
 
 */
enum PKLanguageType : String {
    case Chinese = "zh-Hans", English = "en"
    public static func enumValue(_ rawValue: String) -> PKLanguageType {
        return PKLanguageType.init(rawValue: rawValue)!
    }
}
fileprivate var kBundleKey = 0
class PKLanguageManager : NSObject {
    //网络请求时，加入header给后台
    var netRequestLanguage : String!
    typealias ChangeLanguageBlock = (PKLanguageType)->Int
    static let sharedInstance = PKLanguageManager()
    //修改语言的block
    var changeLanguageBlock : ChangeLanguageBlock?
    private override init() {
        super.init()
        let langArr1 = def.value(forKey: "AppleLanguages") as? [Any]
        var language1 = langArr1?.first as! String
        print("模拟器语言切换之前：\(language1 ?? "")")
        language1 = language1.replacingOccurrences(of: "-CN", with: "")
        language1 = language1.replacingOccurrences(of: "-US", with: "")
        languageType = PKLanguageType.init(rawValue: language1)
        if languageType == .Chinese{
            netRequestLanguage = "zh"
        }else{
            netRequestLanguage = "en"
        }
        var path = Bundle.main.path(forResource:language1 , ofType: "lproj")
        if path == nil {
            path = Bundle.main.path(forResource:"en" , ofType: "lproj")
        }
        let arr = ["1","2"]
        arr.filter{_ in 
          return  1==2
        }
        
        bundle = Bundle(path: path!)
        changeLanguageBlock = { (h) in 9
        }
    }
    let def = UserDefaults.standard
    var bundle : Bundle!
    
    func valueWithKey(key: String!) -> String {
        let str = bundle.localizedString(forKey: key, value: nil, table: nil)
        return str
    }
    

    //默认中文
    var languageType : PKLanguageType!{
        set{
            if newValue != languageType{
                let langArr1 = def.value(forKey: "AppleLanguages") as? [Any]
                                let language1 = langArr1?.first as? String
                                print("模拟器语言切换之前：\(language1 ?? "")")
                                // 切换语言
                                let lans = [newValue.rawValue]
                                def.set(lans, forKey: "AppleLanguages")
                                // 切换语言后
                                let langArr2 = def.value(forKey: "AppleLanguages") as? [Any]
                                let language2 = langArr2?.first as? String
                                print("模拟器语言切换之后：\(language2 ?? "")")
                UserDefaults.standard.synchronize()
                let path = Bundle.main.path(forResource:newValue.rawValue , ofType: "lproj")
                bundle = Bundle(path: path!)
                objc_setAssociatedObject(Bundle.main, &kBundleKey, bundle, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)

                changeTabBarVC()
                if newValue == .Chinese{
                    netRequestLanguage = "zh"
                }else{
                    netRequestLanguage = "en"
                }
            }
        }
       
        get{
            let langArr1 = def.value(forKey: "AppleLanguages") as? [Any]
            var language1 = langArr1?.first as! String
            language1 = language1.replacingOccurrences(of: "-CN", with: "")
            language1 = language1.replacingOccurrences(of: "-US", with: "")
            return PKLanguageType.init(rawValue: language1)
        }
    }
    func changeTabBarVC() {}
    //在切换语言后，要重新设置
    func reloadPKUserManagerAndCountrysInfo() {}
    deinit {
      //  NotificationCenter.default.removeObserver(self)
    }
}
class PKLocalizableBundle: Bundle {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        let bundle: Bundle? = objc_getAssociatedObject(self, &kBundleKey) as? Bundle
        if bundle != nil {
            return bundle!.localizedString(forKey: key, value: value, table: tableName)
        } else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }

    }
}

extension Bundle: SelfAware {
    static func awake() {
        Bundle.classInit()
    }
    static func classInit() {
        swizzleMethod
    }
    private static let swizzleMethod: Void = {
    object_setClass(Bundle.main, PKLocalizableBundle.self)
    }()
}

