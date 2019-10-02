//
//  SpotMarketModel.swift
//  Canonchain
//
//  Created by LEE on 3/28/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit
import Realm
class SpotMarketModel: RLMObject, NSCopying {
    required override init() {
        super.init()
    }
    var id: Int64 = 0
    // @synthesize ID=_ID;
    var amount = ""
    // @synthesize amount=_amount;
    var change = ""
    // @synthesize change=_change;
    var coin_symbol = ""
    var currency_symbol = ""
    // @synthesize currency_symbol=_currency_symbol;
    var currentVCIndex: Int64 = 0
    // @synthesize currentVCIndex=_currentVCIndex;
    var high = ""
    // @synthesize high=_high;
    var high_cny = ""
    // @synthesize high_usd=_high_usd;
    var isStore = false
    // @synthesize isStore=_isStore;
    var last = ""
    // @synthesize last=_last;
    var last_cny = ""
    // @synthesize last_cny=_last_cny;
    var last_usd = ""
    // @synthesize last_usd=_last_usd;
    var low = ""
    // @synthesize low=_low;
    var low_cny = ""
    // @synthesize low_cny=_low_cny;
    var low_usd = ""
    // @synthesize low_usd=_low_usd;
    var percent = ""
    // @synthesize percent=_percent;
    var sequence: Int64 = 0
    // @synthesize sequence=_sequence;
    var vol24H = ""
    
    // @synthesize coin_symbol=_coin_symbol;
    func copy(with zone: NSZone? = nil) -> Any {
       let spotMarketModelCopy = SpotMarketModel()
        spotMarketModelCopy.id = id
        spotMarketModelCopy.amount = amount
        spotMarketModelCopy.change = change
        spotMarketModelCopy.coin_symbol = coin_symbol
        spotMarketModelCopy.currency_symbol = currency_symbol
        spotMarketModelCopy.currentVCIndex = currentVCIndex
        spotMarketModelCopy.high = high
        spotMarketModelCopy.high_cny = high_cny
        spotMarketModelCopy.isStore = isStore
        spotMarketModelCopy.last = last
        spotMarketModelCopy.last_cny = last_cny
        spotMarketModelCopy.last_usd = last_usd
        spotMarketModelCopy.low = low
        spotMarketModelCopy.low_cny = low_usd
        spotMarketModelCopy.percent = percent
        spotMarketModelCopy.sequence = sequence
        spotMarketModelCopy.vol24H = vol24H
        return spotMarketModelCopy
    }
}
