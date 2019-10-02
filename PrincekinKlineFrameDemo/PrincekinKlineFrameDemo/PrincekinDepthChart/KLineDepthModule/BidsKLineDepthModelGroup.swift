

//
//  BidsKLineDepthModelGroup.swift
//  Canonchain
//
//  Created by LEE on 7/24/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit

class BidsKLineDepthModelGroup: KLineDepthModelGroup {
    //   let options: [PopoverViewOption] = [.type(.down), .showBlackOverlay(false),.showShadowy(true),.arrowPositionRatio(120 / 140.0),.arrowSize(CGSize(width: 14, height: 10)),.color(wColor(43, 51, 58))]
    //这个方法里面已经确定卖出的Grouo是反序，所以在方法中写死，同时只要传入 .dealtArrayCount、.modelPriceDepth、.modelPriceTotaldigit 即可
    override init(groupOPtion : [KLineDepthModelGroupOption]!) {
        var newGroupOPtion :  [KLineDepthModelGroupOption] = groupOPtion
        newGroupOPtion.append(.priceSortType(.inverted))
        super.init(groupOPtion: newGroupOPtion)
    }
}
