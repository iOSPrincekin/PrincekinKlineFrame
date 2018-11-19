
//
//  PKKLineVolumeMAPainter.swift
//  PrincekinKlineFrame
//
//  Created by LEE on 7/11/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit

class PKKLineVolumeMAPainter: NSObject {
    
    /*
     func draw(context: CGContext, kline: PKKLine) {
     context.setLineWidth(PKKLineConfig.MALineWidth)
     var index = -1
     for ma in kline.volumeMAPositions.keys.sorted() {
     index += 1
     if let prevPosition = kline.prevKline.volumeMAPositions[ma] {
     if kline.prevKline.volumeMAs[ma]! < 0 {
     continue
     }
     context.setStrokeColor(PKKLineTheme.MAColors[index + 1].cgColor)
     context.strokeLineSegments(between: [prevPosition, kline.volumeMAPositions[ma]!])
     }
     }
     }
     */
    
    public func draw(context: CGContext, klineArray: [PKKLine]) {
        if klineArray.count == 0 {
            return
        }
        context.setLineWidth(PKKLineConfig.MALineWidth)
        var index = -1
        for ma in klineArray[0].volumeMAPositions.keys.sorted() {
            index += 1
            
            if ma == PKKLineParamters.KLineMAs.last{
                
                continue
            }
            let path = UIBezierPath()
            var start = false
            for kline in klineArray {
                if let position = kline.volumeMAPositions[ma], let maValue = kline.volumeMAs[ma] {
                    if maValue < 0 {
                        continue
                    }
                    if !start {
                        path.move(to: position)
                        start = true
                    } else {
                        path.addLine(to: position)
                    }
                }
            }
            if start {
                context.setStrokeColor(PKKLineTheme.MAColors[index + 1].cgColor)
                context.addPath(path.cgPath)
                context.drawPath(using: CGPathDrawingMode.stroke)
            }
        }
    }
    
}

