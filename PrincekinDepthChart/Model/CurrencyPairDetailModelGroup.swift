//
//  CurrencyPairDetailModelGroup.swift
//  Canonchain
//
//  Created by LEE on 6/11/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit
import MJExtension
//import RealmSwift
class CurrencyPairDetailModelGroup : NSObject{
    static let sharedInstance = CurrencyPairDetailModelGroup()
   
    private override init() {}
    @objc dynamic var currencyPairDetailModelList = [CurrencyPairDetailModel]()
    //涨幅榜数据源
    var increaseCurrencyPairDetailModelArray : [CurrencyPairDetailModel]{
        get{
            return currencyPairDetailModelList.filter{ model in
                return (model.calculatePriceChangePercent) > 0
            }
        }
    }
    @objc dynamic var titleArray : [String]
        {
        get{
            if quoteArray.count == 0 {
                return  ["Favorites","USDT","BTC","ETH"]
            }else{
                var tQuoteArray = quoteArray
                tQuoteArray.insert("Favorites", at: 0)
                return tQuoteArray
            }
        }
    }
    @objc dynamic var quoteArray = [String]()
    @objc dynamic var baseArray = [String]()
    @objc dynamic var quoteUSDTArray : [String]?{
        get{
            var symbolArr = [String]()
            for str in quoteArray {
                if str != "USDT"{
                 symbolArr.append("\(str)USDT")
                }
            }
            return symbolArr
        }
    }
    //自选symbol
    @objc dynamic var favouriteSymbolArray = [String]()
    //判断是不是自选交易对
    //查询是否为自选
    func searchSymbolIsInFavourite(_ symbol : String) -> Bool {
        return favouriteSymbolArray.contains(symbol)
    }
    //查询是否为自选
    func searchSlashSymbolIsInFavourite(_ slashSymbol : String) -> Bool {
        let stringArr = slashSymbol.components(separatedBy: "/")
        let symbolString = stringArr.joined()
        return favouriteSymbolArray.contains(symbolString)
    }
    //自选model
     @objc dynamic var favouriteModelArray = [CurrencyPairDetailModel]()
    //获取自选交易对的第一个modelSymbol，在币币交易里面会用到
    @objc dynamic var favouriteFirstModelSlashSymbol : String?{
        get{
            let model = favouriteModelArray.first
            return model?.slashSymbol ?? nil
        }
    }
    //获取行情交易对的第一个modelSymbol，在币币交易里面会用到
    @objc dynamic var marketFirstModelSlashSymbol : String{
        get{
            if titleArray.count > 0{
                let modelArr = searchWithWithQuote(titleArray[1])
                return (modelArr.first?.slashSymbol)!
            }else{
                return ""
            }
       
        }
    }
    //获取自选交易对的第一个SlashSymbol，在币币交易里面会用到
    @objc dynamic var bibiSlashSymbol : String{
        get{
            if favouriteFirstModelSlashSymbol != nil {
                return favouriteFirstModelSlashSymbol!
            }else{
                return marketFirstModelSlashSymbol
            }
        }
    }
    
    //获取自选交易对的第一个modelSymbol，在币币交易里面会用到
    @objc dynamic var favouriteFirstModelSymbol : String?{
        get{
            let model = favouriteModelArray.first
            return model?.symbol ?? nil
        }
    }
    //获取行情交易对的第一个modelSymbol，在币币交易里面会用到
    @objc dynamic var marketFirstModelSymbol : String{
        get{
            if titleArray.count > 1{
                let modelArr = searchWithWithQuote(titleArray[1])
                return modelArr.first?.symbol ?? ""
            }else{
                return ""
            }
            
        }
    }
    //获取自选交易对的第一个SlashSymbol，在币币交易里面会用到
    @objc dynamic var bibiSymbol : String{
        get{
            if favouriteFirstModelSlashSymbol != nil {
                return favouriteFirstModelSymbol!
            }else{
                return marketFirstModelSymbol
            }
        }
    }
    //symbol的集合
    @objc dynamic var symbolArray : [String]{
        get{
            return currencyPairDetailModelList.map{ model in
                return model.symbol
            }
        }
    }
    //带有"/"symbol的集合
    @objc dynamic var slashSymbolArray : [String]{
        get{
            return currencyPairDetailModelList.map{ model in
                return model.slashSymbol
            }
        }
    }
    //获取自选交易对的第一个model，在币币交易里面会用到
    @objc dynamic var bibiModel : CurrencyPairDetailModel?{
        return searchWithWithSymbol(bibiSymbol).first ?? nil
    }
    func searchWithWithQuote(_ quote : String) -> [CurrencyPairDetailModel]{
       return currencyPairDetailModelList.filter{ model in
        //后缀匹配
            return PKVerificationEnumManager.matchSuffixCurrency(model.symbol, quote).isRight
        }
    }
    func searchWithWithSymbol(_ symbol : String) -> [CurrencyPairDetailModel]{
        return currencyPairDetailModelList.filter{ model in
            return model.symbol == symbol
        }
    }
    func searchWithWithSlashSymbol(_ slashSymbol : String) -> [CurrencyPairDetailModel]{
        let stringArr = slashSymbol.components(separatedBy: "/")
        let symbolString = stringArr.joined()
        return currencyPairDetailModelList.filter{ model in
            return model.symbol == symbolString
        }
    }
    //对USDT的比率
    func getRateToUSDT(_ quote : String) -> Decimal {
        if quote == "USDT" {
            return 1
        }else{
        let symbolString = quoteUSDTArray?.filter{
            symbol in
            return PKVerificationEnumManager.matchSuffixCurrency(symbol, quote).isRight
        }.first
        let model : CurrencyPairDetailModel? = searchWithWithSymbol(symbolString ?? "").first
        return Decimal(Double(model?.lastPrice ?? "") ?? 1)
        }
    }
    //添加或者更新
    func addOrReplaceCurrencyPairDetailModelDataArray(_ dataArr : [[String : Any]])  {
        let modelArr : [CurrencyPairDetailModel] = CurrencyPairDetailModel.mj_objectArray(withKeyValuesArray: dataArr) as! [CurrencyPairDetailModel]
        var deleteIndex : Int?
        for model in modelArr {
            currencyPairDetailModelList.map{ tModel in
                if tModel.symbol == model.symbol{
                 deleteIndex = currencyPairDetailModelList.index(of: tModel)
                }
            }
            if deleteIndex != nil{
                currencyPairDetailModelList.remove(at: deleteIndex!)
               
            }
             currencyPairDetailModelList.append(model)
        }
    }
}
