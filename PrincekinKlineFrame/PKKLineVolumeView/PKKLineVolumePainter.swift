//
//  PKKLineVolumePainter.swift
//  PrincekinKlineFrame
//
//  Created by LEE on 7/11/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit

class PKKLineVolumePainter: NSObject {
    
    public func draw(context: CGContext, kline: PKKLine) {
        let paintColor = kline.close < kline.open ? PKKLineTheme.DownColor : PKKLineTheme.RiseColor
        context.setStrokeColor(paintColor.cgColor)
        context.setLineWidth(PKKLineConfig.KLineWidth)
        context.strokeLineSegments(between: [kline.volumePosition.zeroPoint, kline.volumePosition.volumePoint])
    }
}

