//
//  CurrencyPairDetailModel.swift
//  Canonchain
//
//  Created by LEE on 6/11/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit
import RealmSwift
import MJExtension
//CurrencyPairModel + CurrencyPair24hrModel
class CurrencyPairDetailModel: Object {
    //默认4
    @objc dynamic var amountDecimals = "4"
    @objc dynamic var base = ""
    @objc dynamic var depthMergeUnits = ""
        {
        didSet{
        }
    }
    @objc dynamic var depthMergeUnitsArray : [Int] {
        get{
            let stringArr = depthMergeUnits.components(separatedBy: ",")
            if stringArr.count > 0 {
                return stringArr.map{ str in
                    return Int(str) ?? 4
                }
            }else{
                return [Int]()
            }
        }
    }
    var defalutdepthMergeUnit : Int?{
        return depthMergeUnitsArray.last ?? 4
    }
    @objc dynamic var priceDecimals : String = ""
//        {
//        didSet{
//            priceDecimalsInt = Int(priceDecimals)!
//        }
//    }
    var priceDecimalsInt = 4
    @objc dynamic var quote = ""
    @objc dynamic var symbol = ""
    //带有斜杠的symbol
    @objc dynamic var slashSymbol = ""
    @objc dynamic var totalDecimals = ""
    
    @objc dynamic var Volume : String = ""
    @objc dynamic var askPrice : String = ""
    @objc dynamic var bidPrice : String = ""
    @objc dynamic var count : String = ""
    @objc dynamic var highPrice : String = ""
    @objc dynamic var lastPrice : String = ""
    @objc dynamic var lowPrice  : String = ""
    @objc dynamic var openPrice : String = ""
    @objc dynamic var priceChange : String = ""
    @objc dynamic var priceChangePercent : String = ""
    @objc dynamic var quoteVolume : String = ""
    @objc dynamic var weightedAvgPrice : String = ""
    
    //通过自己计算获得最新的跌涨比
    @objc dynamic var calculatePriceChangePercent : Double = 0
    
    override func mj_setKeyValues(_ keyValues: Any!, context: NSManagedObjectContext!) -> CurrencyPairDetailModel! {
        var newKeyValues = NSMutableDictionary()
        if let tKeyValues = keyValues as? [String : Any]{
            if tKeyValues["e"] as? String == "24hrTicker"{
                newKeyValues["Volume"] = tKeyValues["v"]
                newKeyValues["lastPrice"] = tKeyValues["c"]
                newKeyValues["priceChangePercent"] = tKeyValues["P"]
                newKeyValues["priceChange"] = tKeyValues["p"]
                newKeyValues["openPrice"] = tKeyValues["o"]
                newKeyValues["lowPrice"] = tKeyValues["l"]
                newKeyValues["askPrice"] = tKeyValues["a"]
                newKeyValues["bidPrice"] = tKeyValues["b"]
                newKeyValues["highPrice"] = tKeyValues["h"]
                newKeyValues["lastPrice"] = tKeyValues["c"]
                newKeyValues["symbol"] = tKeyValues["s"]
                getbaseAndQuote(&newKeyValues)
                let currencyPairModelList = CurrencyPairModelGroup.sharedInstance.currencyPairModelList
                currencyPairModelList.forEach{ model in
                    let tSymbol : String = newKeyValues["symbol"] as! String
                    if model.symbol == tSymbol{
                        newKeyValues["amountDecimals"] = model.amountDecimals
                        newKeyValues["depthMergeUnits"] = model.depthMergeUnits
                        newKeyValues["priceDecimals"] = model.priceDecimals
                        newKeyValues["totalDecimals"] = model.totalDecimals
                    }
                }
            }else{
                newKeyValues = NSMutableDictionary.init(dictionary: tKeyValues)
            }
            if let baseString = newKeyValues["base"] as? String, let quoteString = newKeyValues["quote"] as? String{
             newKeyValues["slashSymbol"] =  baseString + "/" + quoteString
            }
        }
        
        let model = super.mj_setKeyValues(newKeyValues, context: context) as! CurrencyPairDetailModel?
        //进行位数处理
        model?.Volume = PKDataProcessManager.formatterArithmeticString(model?.Volume ?? "", Int(model?.totalDecimals  ?? "") ?? 8)
        model?.lastPrice = PKDataProcessManager.formatterArithmeticString(model?.lastPrice ?? "", priceDecimalsInt)
        model?.priceDecimalsInt = Int(model?.priceDecimals ?? "") ?? 4
        if model?.openPrice.count == 0 || model?.lastPrice.count == 0 {
            model?.calculatePriceChangePercent = 0
        }else{
            let lastPrice = Double(model!.lastPrice) ?? 0
            let openPrice = Double(model!.openPrice) ?? 0
            
            let percent : Double = (lastPrice - openPrice) / openPrice
            model?.calculatePriceChangePercent = percent
        }
        return model
    }
    //根据symbol获取 quote和base
    func getbaseAndQuote(_ dicPointer : AutoreleasingUnsafeMutablePointer<NSMutableDictionary>) {
        let paramterDic : NSMutableDictionary = dicPointer.pointee
           if let symbolString = paramterDic["symbol"] as? String {
                    for titleString in CurrencyPairDetailModelGroup.sharedInstance.titleArray{
                        if PKVerificationEnumManager.matchSuffixCurrency(symbolString , titleString).isRight{
                            paramterDic["quote"] = titleString
                            paramterDic["base"] = symbolString.components(separatedBy: titleString).first
                        }
                    }
          
             }
    }

    override static func mj_replacedKey(fromPropertyName121 propertyName: String!) -> Any! {
        return propertyName
    }
    //根据两种model合并CurrencyPairDetailModel
    class func returnCurrencyPairDetailModel(_ currencyPairModel : CurrencyPairModel, _ currencyPair24hrModel : CurrencyPair24hrModel) -> CurrencyPairDetailModel{
        let currencyPairModelDic : [String : Any] = currencyPairModel.mj_keyValues() as! [String : Any]
        let currencyPair24hrModelDic : [String : Any] = currencyPair24hrModel.mj_keyValues() as! [String : Any]
        //字典的+运算
        let currencyPairDetailModelDic = currencyPairModelDic + currencyPair24hrModelDic
        let currencyPairDetailModel = CurrencyPairDetailModel.mj_object(withKeyValues: currencyPairDetailModelDic)
        return currencyPairDetailModel!
    }
}
