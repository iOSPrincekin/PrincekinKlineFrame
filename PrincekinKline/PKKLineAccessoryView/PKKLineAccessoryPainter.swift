//
//  PKKLineAccessoryPainter.swift
//  PrincekinKlineFrame
//
//  Created by LEE on 7/11/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit

class PKKLineAccessoryPainter: NSObject {
    
    /*
     func draw(context: CGContext, kline: PKKLine) {
     switch PKKLineParamters.AccessoryType {
     case .MACD:
     context.setLineWidth(PKKLineConfig.MALineWidth)
     context.setStrokeColor(PKKLineTheme.MAColors[1].cgColor)
     context.strokeLineSegments(between: [kline.prevKline.klineMACD.DIFFPoint, kline.klineMACD.DIFFPoint])
     context.setStrokeColor(PKKLineTheme.MAColors[2].cgColor)
     context.strokeLineSegments(between: [kline.prevKline.klineMACD.DEAPoint, kline.klineMACD.DEAPoint])
     context.setLineWidth(PKKLineConfig.MACDWidth)
     context.setStrokeColor(kline.klineMACD.BAR > 0 ? PKKLineTheme.RiseColor.cgColor : PKKLineTheme.DownColor.cgColor)
     context.strokeLineSegments(between: [kline.klineMACD.zeroPoint, kline.klineMACD.BARPoint])
     case .KDJ:
     context.setStrokeColor(PKKLineTheme.MAColors[1].cgColor)
     context.strokeLineSegments(between: [kline.prevKline.klineKDJ.kPoint, kline.klineKDJ.kPoint])
     context.setStrokeColor(PKKLineTheme.MAColors[2].cgColor)
     context.strokeLineSegments(between: [kline.prevKline.klineKDJ.dPoint, kline.klineKDJ.dPoint])
     context.setStrokeColor(PKKLineTheme.MAColors[3].cgColor)
     context.strokeLineSegments(between: [kline.prevKline.klineKDJ.jPoint, kline.klineKDJ.jPoint])
     case .RSI:
     var index = 0
     for key in kline.klineRSI.klineRSIPositions.keys.sorted() {
     if let prevPoint = kline.prevKline.klineRSI.klineRSIPositions[key] {
     context.setStrokeColor(PKKLineTheme.MAColors[index + 1].cgColor)
     context.strokeLineSegments(between: [prevPoint, kline.klineRSI.klineRSIPositions[key]!])
     }
     index += 1
     }
     default: break
     }
     }
     */
    
    func draw(context: CGContext, klineArray: [PKKLine]) {
        if klineArray.count == 0 {
            return
        }
        switch PKKLineParamters.AccessoryType {
        case .MACD:
            let diffPath = UIBezierPath()
            let deaPath = UIBezierPath()
            var start = false
            for kline in klineArray {
                if !start {
                    diffPath.move(to: kline.klineMACD.DIFFPoint)
                    deaPath.move(to: kline.klineMACD.DEAPoint)
                    start = true
                } else {
                    diffPath.addLine(to: kline.klineMACD.DIFFPoint)
                    deaPath.addLine(to: kline.klineMACD.DEAPoint)
                }
                context.setLineWidth(PKKLineConfig.MACDWidth)
                context.setStrokeColor(kline.klineMACD.BAR > 0 ? PKKLineTheme.RiseColor.cgColor : PKKLineTheme.DownColor.cgColor)
                context.strokeLineSegments(between: [kline.klineMACD.zeroPoint, kline.klineMACD.BARPoint])
            }
            context.setLineWidth(PKKLineConfig.MALineWidth)
            context.setStrokeColor(PKKLineTheme.MAColors[1].cgColor)
            context.addPath(diffPath.cgPath)
            context.drawPath(using: CGPathDrawingMode.stroke)
            context.setStrokeColor(PKKLineTheme.MAColors[2].cgColor)
            context.addPath(deaPath.cgPath)
            context.drawPath(using: CGPathDrawingMode.stroke)
        case .KDJ:
            let kPath = UIBezierPath()
            let dPath = UIBezierPath()
            let jPath = UIBezierPath()
            var start = false
            for kline in klineArray {
                if !start {
                    kPath.move(to: kline.klineKDJ.kPoint)
                    dPath.move(to: kline.klineKDJ.dPoint)
                    jPath.move(to: kline.klineKDJ.jPoint)
                    start = true
                } else {
                    kPath.addLine(to: kline.klineKDJ.kPoint)
                    dPath.addLine(to: kline.klineKDJ.dPoint)
                    jPath.addLine(to: kline.klineKDJ.jPoint)
                }
            }
            context.setStrokeColor(PKKLineTheme.MAColors[1].cgColor)
            context.addPath(kPath.cgPath)
            context.drawPath(using: CGPathDrawingMode.stroke)
            context.setStrokeColor(PKKLineTheme.MAColors[2].cgColor)
            context.addPath(dPath.cgPath)
            context.drawPath(using: CGPathDrawingMode.stroke)
            context.setStrokeColor(PKKLineTheme.MAColors[3].cgColor)
            context.addPath(jPath.cgPath)
            context.drawPath(using: CGPathDrawingMode.stroke)
        case .RSI:
            var index = 0
            for key in klineArray.last!.klineRSI.klineRSIPositions.keys.sorted() {
                let path = UIBezierPath()
                var start = false
                for kline in klineArray {
                    if let point = kline.klineRSI.klineRSIPositions[key], kline.prevKline.klineRSI.klineRSIPositions[key] != nil {
                        if !start {
                            path.move(to: point)
                            start = true
                        } else {
                            path.addLine(to: point)
                        }
                    }
                }
                if start {
                    context.setStrokeColor(PKKLineTheme.MAColors[index + 1].cgColor)
                    context.addPath(path.cgPath)
                    context.drawPath(using: CGPathDrawingMode.stroke)
                }
                index += 1
            }
        default: break
        }
    }
    
}

