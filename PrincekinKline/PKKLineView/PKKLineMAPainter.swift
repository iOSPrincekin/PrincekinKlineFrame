//
//  PKKLineMAPainter.swift
//  PrincekinKlineFrame
//
//  Created by LEE on 7/11/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit

class PKKLineMAPainter: NSObject {
    /*
     func draw(context: CGContext, kline: PKKLine) {
     context.setLineWidth(PKKLineConfig.MALineWidth)
     switch PKKLineParamters.KLineMAType {
     case .MA:
     let positions = kline.klineMAPositions
     let prevPositions = kline.prevKline.klineMAPositions
     var index = 0
     for ma in positions.keys.sorted() {
     if let prevPosition = prevPositions[ma] {
     if kline.prevKline.klineMAs[ma]! < 0 {
     continue
     }
     context.setStrokeColor(PKKLineTheme.MAColors[index + 1].cgColor)
     context.strokeLineSegments(between: [prevPosition, positions[ma]!])
     }
     index += 1
     }
     case .EMA:
     let positions = kline.klineEMAPositions
     let prevPositions = kline.prevKline.klineEMAPositions
     var index = 0
     for ma in positions.keys.sorted() {
     if let prevPosition = prevPositions[ma] {
     if PKKLineParamters.KLineMAType == .MA && kline.prevKline.klineMAs[ma]! < 0 {
     continue
     }
     context.setStrokeColor(PKKLineTheme.MAColors[index + 1].cgColor)
     context.strokeLineSegments(between: [prevPosition, positions[ma]!])
     }
     index += 1
     }
     case .BOLL:
     if let klineBoll = kline.klineBoll, let prevKlineBoll = kline.prevKline.klineBoll {
     context.setStrokeColor(PKKLineTheme.MAColors[1].cgColor)
     context.strokeLineSegments(between: [prevKlineBoll.MBPoint, klineBoll.MBPoint])
     context.setStrokeColor(PKKLineTheme.MAColors[2].cgColor)
     context.strokeLineSegments(between: [prevKlineBoll.UPPoint, klineBoll.UPPoint])
     context.setStrokeColor(PKKLineTheme.MAColors[3].cgColor)
     context.strokeLineSegments(between: [prevKlineBoll.DNPoint, klineBoll.DNPoint])
     }
     default: break
     }
     }
     */
    
    func draw(context : CGContext, klineArray : [PKKLine]) {
       if klineArray.count == 0 || PKKLineParamters.KLineStyle == .curve{
            return
        }
        context.setLineWidth(PKKLineConfig.MALineWidth)
        switch PKKLineParamters.KLineMAType {
        case .MA:
            var index = -1
            for ma in klineArray[0].klineMAPositions.keys.sorted() {
                   index += 1
          
                    if ma == PKKLineParamters.KLineMAs.last{
                        
                        continue
                    }
                
                let path = UIBezierPath()
                var start = false
                for kline in klineArray {
                    if let position = kline.klineMAPositions[ma], let maValue = kline.klineMAs[ma] {
                        if maValue < 0 {
                            continue
                        }
                        if !start {
                            path.move(to: position)
                            start = true
                        } else {
                            path.addLine(to: position)
                        }
                        if index == 0{
                    
                        }
                    }
                }
                if start {
                    context.setStrokeColor(PKKLineTheme.MAColors[index + 1].cgColor)
                    context.addPath(path.cgPath)
                    context.drawPath(using: CGPathDrawingMode.stroke)
                }
          
            }
        case .EMA:
            var index = 0
            for ema in klineArray[0].klineEMAPositions.keys.sorted() {
                let path = UIBezierPath()
                var start = false
                for kline in klineArray {
                    if let position = kline.klineEMAPositions[ema], let emaValue = kline.klineEMAs[ema] {
                        if emaValue < 0 {
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
                index += 1
            }
        case .BOLL:
            let mbPath = UIBezierPath()
            let upPath = UIBezierPath()
            let dnPath = UIBezierPath()
            var mbStart = false
            var upStart = false
            var dnStart = false
            for kline in klineArray {
                if let klineBoll = kline.klineBoll {
                    if !mbStart {
                        mbPath.move(to: klineBoll.MBPoint)
                        mbStart = true
                    } else {
                        mbPath.addLine(to: klineBoll.MBPoint)
                    }
                    if !upStart {
                        upPath.move(to: klineBoll.UPPoint)
                        upStart = true
                    } else {
                        upPath.addLine(to: klineBoll.UPPoint)
                    }
                    if !dnStart {
                        dnPath.move(to: klineBoll.DNPoint)
                        dnStart = true
                    } else {
                        dnPath.addLine(to: klineBoll.DNPoint)
                    }
                }
            }
            if mbStart {
                context.setStrokeColor(PKKLineTheme.MAColors[1].cgColor)
                context.addPath(mbPath.cgPath)
                context.drawPath(using: CGPathDrawingMode.stroke)
            }
            if upStart {
                context.setStrokeColor(PKKLineTheme.MAColors[2].cgColor)
                context.addPath(upPath.cgPath)
                context.drawPath(using: CGPathDrawingMode.stroke)
            }
            if dnStart {
                context.setStrokeColor(PKKLineTheme.MAColors[3].cgColor)
                context.addPath(dnPath.cgPath)
                context.drawPath(using: CGPathDrawingMode.stroke)
            }
        default: break
        }
    }
    
    func drawCurve(context : CGContext, klineArray : [PKKLine]) {
        if klineArray.count == 0 {
            return
        }
        context.setLineWidth(PKKLineConfig.MALineWidth)
        switch PKKLineParamters.KLineMAType {
        case .MA:
            let lastMA : Int = PKKLineParamters.KLineMAs.last!
            let lastMAIndex = PKKLineParamters.KLineMAs.count
                let path = UIBezierPath()
                var start = false
                for kline in klineArray {
                    if let position = kline.klineMAPositions[lastMA], let maValue = kline.klineMAs[lastMA] {
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
                    context.setStrokeColor(PKKLineTheme.MAColors[lastMAIndex].cgColor)
                    context.addPath(path.cgPath)
                    context.drawPath(using: CGPathDrawingMode.stroke)
                }
            
          
         
            
        case .EMA:
            break
        case .BOLL:
            let mbPath = UIBezierPath()
            var mbStart = false
            for kline in klineArray {
                if let klineBoll = kline.klineBoll {
                    if !mbStart {
                        mbPath.move(to: klineBoll.MBPoint)
                        mbStart = true
                    } else {
                        mbPath.addLine(to: klineBoll.MBPoint)
                    }
                }
            }
            if mbStart {
                context.setStrokeColor(PKKLineTheme.MAColors[1].cgColor)
                context.addPath(mbPath.cgPath)
                context.drawPath(using: CGPathDrawingMode.stroke)
            }
            break
        default:
            break
        }
      
    }

    
    
    
    
}
