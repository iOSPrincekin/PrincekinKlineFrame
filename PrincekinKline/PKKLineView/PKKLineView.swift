//
//  PKKLineView.swift
//  PrincekinKlineFrame
//
//  Created by LEE on 7/11/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit

public protocol PKKLineViewUpdateDelegate: NSObjectProtocol {
    func updateKlineRightYRange(min: Double, max: Double)
    func updateTimeRange(beginTimeStamp: TimeInterval,secondTimeStamp: TimeInterval,thirdTimeStamp: TimeInterval,fourthTimeStamp: TimeInterval, endTimeStamp: TimeInterval)
}


public class PKKLineView: UIView {
    var isFirst = true
    weak var sendNewstDelegate : PKKLineSendNewstModelDelegate?
    //线程同步保证数据的安全
    let semaphore = DispatchSemaphore(value: 1)
    let queue = DispatchQueue.global(qos: .default)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var kLineViewHeight : CGFloat = 0
    //获取当前kLineview的高度
    public override func layoutSubviews() {
        super.layoutSubviews()
        kLineViewHeight = frame.height
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    public convenience init() {
        self.init(frame: CGRect.zero)
        self.layer.isOpaque = false
    }
    
    public weak var superScrollView: PKKLineScrollView!
    
    public weak var updateDelegate: PKKLineViewUpdateDelegate?
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()!
        context.clear(rect)
            if self.needDrawKlineArray.count == 0 {
                self.superScrollView.volumeView.draw(klineArray: self.needDrawKlineArray)
                return
            }
            // 绘制 Y轴参考虚线
            let referenceLineCount = PKKLineConfig.KLineViewRightYCount - 2
            let step = rect.height / CGFloat(referenceLineCount + 1)
            context.setLineWidth(1)
            context.setStrokeColor(PKKLineTheme.BorderColor.cgColor)
            context.setLineDash(phase: 0, lengths: [1, 1])
            for index in 0...referenceLineCount {
                context.strokeLineSegments(between: [CGPoint.init(x: 0, y: CGFloat(index) * step), CGPoint.init(x: rect.width, y: CGFloat(index) * step)])
            }
            // 绘制 k线
            context.setLineDash(phase: 0, lengths: [])
        // 绘制 MA线
        let klineMaPainter = PKKLineMAPainter()
        if PKKLineParamters.KLineStyle == .curve {
            klineMaPainter.drawCurve(context: context, klineArray: self.needDrawKlineArray)
        }
            let klinePainter = PKKLinePainter()
            klinePainter.draw(context: context, klineArray: self.needDrawKlineArray, size: rect.size)
            
        
            klineMaPainter.draw(context: context, klineArray: self.needDrawKlineArray)
            if PKKLineParamters.KLineStyle != .curve {
                // 绘制 最小值 指示文字
                let lowPoint = self.minKline.klinePosition.lowPoint
                if self.minKline.klinePosition.lowPoint.x - self.superScrollView.contentOffset.x > self.superScrollView.frame.width / 2 {
                    let ocStr = "\(self.minKline.low)→" as NSString
                    let textSize = ocStr.size(withAttributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: PKKLineTheme.TipTextFontSize)])
                    ocStr.draw(at: CGPoint.init(x: lowPoint.x - textSize.width, y: lowPoint.y - textSize.height / 2), withAttributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: PKKLineTheme.TipTextFontSize), NSAttributedStringKey.foregroundColor:PKKLineTheme.HLTextColor])
                } else {
                    let ocStr = "←\(self.minKline.low)" as NSString
                    let textSize = ocStr.size(withAttributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: PKKLineTheme.TipTextFontSize)])
                    ocStr.draw(at: CGPoint.init(x: lowPoint.x, y: lowPoint.y - textSize.height / 2), withAttributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: PKKLineTheme.TipTextFontSize), NSAttributedStringKey.foregroundColor:PKKLineTheme.HLTextColor])
                }
                // 绘制 最大值 指示文字
                let highPoint = self.maxKline.klinePosition.highPoint
                if self.maxKline.klinePosition.lowPoint.x - self.superScrollView.contentOffset.x > self.superScrollView.frame.width / 2 {
                    let ocStr = "\(self.maxKline.high)→" as NSString
                    let textSize = ocStr.size(withAttributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: PKKLineTheme.TipTextFontSize)])
                    ocStr.draw(at: CGPoint.init(x: highPoint.x - textSize.width, y: highPoint.y - textSize.height / 2), withAttributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: PKKLineTheme.TipTextFontSize), NSAttributedStringKey.foregroundColor:PKKLineTheme.HLTextColor])
                } else {
                    let ocStr = "←\(self.maxKline.high)" as NSString
                    let textSize = ocStr.size(withAttributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: PKKLineTheme.TipTextFontSize)])
                    ocStr.draw(at: CGPoint.init(x: highPoint.x, y: highPoint.y - textSize.height / 2), withAttributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: PKKLineTheme.TipTextFontSize), NSAttributedStringKey.foregroundColor:PKKLineTheme.HLTextColor])
                }
            }
    }
    
  
    public var klineGroup = PKKLineGroup()
    
    public var viewWidth = CGFloat(0)
    public func updateViewWidth() {
        var klineViewWidth : CGFloat = 0
        let screenWidth = UIScreen.main.bounds.width
        
        klineViewWidth = CGFloat(self.klineGroup.klineArray.count) * (PKKLineConfig.KLineGap + PKKLineConfig.KLineWidth) + PKKLineConfig.KLineGap < screenWidth ? screenWidth : CGFloat(self.klineGroup.klineArray.count) * (PKKLineConfig.KLineGap + PKKLineConfig.KLineWidth) + PKKLineConfig.KLineGap
        
        self.viewWidth = klineViewWidth
        self.snp.updateConstraints { (maker) in
            maker.width.equalTo(klineViewWidth)
        }
    }
    public var needDrawKlineArray = [PKKLine]()
    func calculateBeforeDraw() -> [PKKLine]{
        self.extractNeedDrawKlineArray()
        self.setKlinePosition()
        return self.needDrawKlineArray
    }
    public func draw() {
        _ = calculateBeforeDraw()
         self.setNeedsDisplay()
    }
    
    public var needDrawStartIndex: Int {
        get {
            let scrollViewOffsetX = superScrollView.superScrollViewContentOffsetX < 0 ? 0 : superScrollView.superScrollViewContentOffsetX;
            return Int(abs((scrollViewOffsetX - PKKLineConfig.KLineGap) / (PKKLineConfig.KLineWidth + PKKLineConfig.KLineGap)))
        }
    }
    public var startXPosition: CGFloat {
        return CGFloat(self.needDrawStartIndex + 1) * PKKLineConfig.KLineGap + CGFloat(self.needDrawStartIndex) * PKKLineConfig.KLineWidth + PKKLineConfig.KLineWidth / 2
    }

    
    // MARK: - 提取需要绘制的数据
    private func extractNeedDrawKlineArray() {
        let klineWidth = PKKLineConfig.KLineWidth
        let klineGap = PKKLineConfig.KLineGap
        let needDrawCount = Int((superScrollView.superScrollViewWidth - klineGap) / (klineWidth + klineGap)) + 1
        //起始位置
        let needDrawKlineStartIndex: Int
        needDrawKlineStartIndex = self.needDrawStartIndex
        self.needDrawKlineArray.removeAll()
        if needDrawKlineStartIndex < self.klineGroup.klineArray.count {
            if needDrawKlineStartIndex + needDrawCount < self.klineGroup.klineArray.count {
                self.needDrawKlineArray += self.klineGroup.klineArray[needDrawKlineStartIndex...(needDrawKlineStartIndex + needDrawCount)]
            } else {
                self.needDrawKlineArray += self.klineGroup.klineArray[needDrawKlineStartIndex...(self.klineGroup.klineArray.count - 1)]
            }
        }
     
        if self.needDrawKlineArray.count > 5 {
            let countStep = Double(self.needDrawKlineArray.count) / Double(PKKLineConfig.DateShowCount - 1)
            let beginTimeStamp = self.needDrawKlineArray.first!.timeStamp
            let secoundTimeStamp = self.needDrawKlineArray[Int(round(countStep * 1))].timeStamp
            let thirdTimeStamp = self.needDrawKlineArray[Int(round(countStep * 2))].timeStamp
            let fourthTimeStamp = self.needDrawKlineArray[Int(round(countStep * 3))].timeStamp
            let endTimeStamp = self.needDrawKlineArray.last!.timeStamp
           
                DispatchQueue.main.async(execute: {
                            self.updateDelegate?.updateTimeRange(beginTimeStamp: beginTimeStamp, secondTimeStamp: secoundTimeStamp, thirdTimeStamp: thirdTimeStamp, fourthTimeStamp: fourthTimeStamp, endTimeStamp: endTimeStamp)
                      })
        }
    }
   
    
    public var minKline = PKKLine()
    public var maxKline = PKKLine()
    
    // MARK: - 设置数据在画布上的Position
    private func setKlinePosition() {
        if self.needDrawKlineArray.count == 0 {
            return
        }
        self.minKline = self.needDrawKlineArray[0]
        self.maxKline = self.needDrawKlineArray[0]
        var maxValue = self.maxKline.high
        var minValue = self.minKline.low
        
        switch PKKLineParamters.KLineMAType {
        case .MA:
            for kline in self.needDrawKlineArray {
                if kline.high > self.maxKline.high {
                    self.maxKline = kline
                }
                if kline.low < self.minKline.low {
                    self.minKline = kline
                }
                let maxMA = kline.maxMA
                if maxMA < 0 {
                    maxValue = max(maxValue, kline.high)
                } else {
                    maxValue = max(maxValue, kline.high, maxMA)
                }
                let minMA = kline.minMA
                if minMA < 0 {
                    minValue = min(minValue, kline.low)
                } else {
                    minValue = min(minValue, kline.low, minMA)
                }
                
                
            }
        case .EMA:
            for kline in self.needDrawKlineArray {
                if kline.high > self.maxKline.high {
                    self.maxKline = kline
                }
                if kline.low < self.minKline.low {
                    self.minKline = kline
                }
                maxValue = max(maxValue, kline.high, kline.maxEMA)
                minValue = min(minValue, kline.low, kline.minEMA)
                
                let maxEMA = kline.maxEMA
                if maxEMA < 0 {
                    maxValue = max(maxValue, kline.high)
                } else {
                    maxValue = max(maxValue, kline.high, maxEMA)
                }
                let minEMA = kline.minEMA
                if minEMA < 0 {
                    minValue = min(minValue, kline.low)
                } else {
                    minValue = min(minValue, kline.low, minEMA)
                }
            }
        case .BOLL:
            for kline in self.needDrawKlineArray {
                if kline.high > self.maxKline.high {
                    self.maxKline = kline
                }
                if kline.low < self.minKline.low {
                    self.minKline = kline
                }
                if let boll = kline.klineBoll {
                    maxValue = max(maxValue, kline.high, boll.UP)
                    minValue = min(minValue, kline.low, boll.DN)
                } else {
                    maxValue = max(maxValue, kline.high)
                    minValue = min(minValue, kline.low)
                }
            }
        case .NONE:
            for kline in self.needDrawKlineArray {
                if kline.high > self.maxKline.high {
                    self.maxKline = kline
                }
                if kline.low < self.minKline.low {
                    self.minKline = kline
                }
            }
            maxValue = self.maxKline.high
            minValue = self.minKline.low
        }
        // 上下留点margin
//        maxValue *= 1.001
//        minValue *= 0.999
        maxValue *= 1.001
        minValue *= 0.999
        PKKLineParamters.setKLineDataDecimals(maxValue, minValue)
        let minY = CGFloat(0)
        let maxY = kLineViewHeight
        let unitValue = (maxValue - minValue) / Double(maxY - minY)
        for index in 0..<self.needDrawKlineArray.count {
            let kline = self.needDrawKlineArray[index]
            let xPosition = self.startXPosition + CGFloat(index) * (PKKLineConfig.KLineGap + PKKLineConfig.KLineWidth)
            kline.klinePosition.highPoint = CGPoint.init(x: xPosition, y: maxY - CGFloat((kline.high - minValue) / unitValue))
            kline.klinePosition.lowPoint = CGPoint.init(x: xPosition, y: maxY - CGFloat((kline.low - minValue) / unitValue))
            var openPoint = CGPoint.init(x: xPosition, y: maxY - CGFloat((kline.open - minValue) / unitValue))
            var closePoint = CGPoint.init(x: xPosition, y: maxY - CGFloat((kline.close - minValue) / unitValue))
            if abs(openPoint.y - closePoint.y) < PKKLineConfig.KLineMinHeight {
                if openPoint.y > closePoint.y {
                    openPoint.y = closePoint.y + PKKLineConfig.KLineMinHeight
                } else if openPoint.y < closePoint.y {
                    closePoint.y = openPoint.y + PKKLineConfig.KLineMinHeight
                } else {
                    if index > 0 {
                        let prevKline = self.needDrawKlineArray[index - 1]
                        if kline.open > prevKline.close {
                            openPoint.y = closePoint.y + PKKLineConfig.KLineMinHeight
                        } else {
                            closePoint.y = openPoint.y + PKKLineConfig.KLineMinHeight
                        }
                    } else if index + 1 < self.needDrawKlineArray.count {
                        let nextKline = self.needDrawKlineArray[index + 1]
                        if kline.close < nextKline.open {
                            openPoint.y = closePoint.y + PKKLineConfig.KLineMinHeight
                        } else {
                            closePoint.y = openPoint.y + PKKLineConfig.KLineMinHeight
                        }
                    }
                }
            }
            kline.klinePosition.openPoint = openPoint
            kline.klinePosition.closePoint = closePoint
            
            kline.klineMAPositions.removeAll()
          //  print("PK1-----------\(Thread.current)---\(self)")
//            for key in kline.klineMAs.keys.sorted() {
//                kline.klineMAPositions[key] = CGPoint.init(x: xPosition, y: maxY - CGFloat((kline.klineMAs[key]! - minValue) / unitValue))
//
//            }
            for key in kline.klineMAs.keys {
                kline.klineMAPositions[key] = CGPoint.init(x: xPosition, y: maxY - CGFloat(((kline.klineMAs[key] ?? 0) - minValue) / unitValue))
                
            }
          
            kline.klineEMAPositions.removeAll()
//            for key in kline.klineEMAs.keys.sorted() {
//                kline.klineEMAPositions[key] = CGPoint.init(x: xPosition, y: maxY - CGFloat((kline.klineEMAs[key]! - minValue) / unitValue))
//            }
            for key in kline.klineEMAs.keys {
                kline.klineEMAPositions[key] = CGPoint.init(x: xPosition, y: maxY - CGFloat(((kline.klineEMAs[key] ?? 0) - minValue) / unitValue))
            }
            
            if var klineBoll = kline.klineBoll {
                klineBoll.MBPoint = CGPoint.init(x: xPosition, y: maxY - CGFloat((klineBoll.MB - minValue) / unitValue))
                klineBoll.UPPoint = CGPoint.init(x: xPosition, y: maxY - CGFloat((klineBoll.UP - minValue) / unitValue))
                klineBoll.DNPoint = CGPoint.init(x: xPosition, y: maxY - CGFloat((klineBoll.DN - minValue) / unitValue))
                kline.klineBoll = klineBoll
            }
        }
            DispatchQueue.main.async(execute: {
                 self.updateDelegate?.updateKlineRightYRange(min: minValue, max: maxValue)
            })
    }
    
    

}
// MARK: - 数据管理
extension PKKLineView {
    
    
    public func getSelectedKline(touchPoint: CGPoint) -> PKKLine? {
        var index = Int((touchPoint.x - PKKLineConfig.KLineGap) / (PKKLineConfig.KLineGap + PKKLineConfig.KLineWidth))
        if index < 0 {
            index = 0
        }
        if index > self.klineGroup.klineArray.count - 1 {
            index = self.klineGroup.klineArray.count - 1
        }
        if index < 0 || index > self.klineGroup.klineArray.count {
            return nil
        }
        let selectedKline = self.klineGroup.klineArray[index]
        return selectedKline
    }
    
    public func getKlineGroup() -> PKKLineGroup {
        return klineGroup
    }
    
    public func appendData(klineArray: [PKKLine]) {
        //  let isFirst = self.klineGroup.klineArray.count == 0
        let beforeCount = self.klineGroup.klineArray.count
        
        self.klineGroup.append(klineArray: klineArray)
        let finishCount = self.klineGroup.klineArray.count
        let addCount = finishCount - beforeCount
        let offsetX = self.superScrollView.contentOffset.x
        self.updateViewWidth()
        sendNewstDelegate?.sendLastModel(self.klineGroup.klineArray.last!)
        if isFirst {
            if self.viewWidth > self.superScrollView.frame.width {
               self.superScrollView.setContentOffset(CGPoint.init(x: self.viewWidth - self.superScrollView.frame.width, y: 0), animated: false)
               //  self.superScrollView.setContentOffset(CGPoint.init(x: 9000, y: 0), animated: false)
            } else {
                self.superScrollView.setContentOffset(CGPoint.zero, animated: false)
            }
            isFirst = false
        } else {
            if addCount == 0{
                self.superScrollView.drawViews()
            }else{
            let addedWidth = CGFloat(addCount) * (PKKLineConfig.KLineGap + PKKLineConfig.KLineWidth)
            self.superScrollView.setContentOffset(CGPoint.init(x: addedWidth + offsetX, y: 0), animated: false)
            }
        }
      
    }
  
    
    public func reloadData(klineArray: [PKKLine]) {
        if klineArray.count > 0 {
            self.klineGroup.klineArray.removeAll()
            isFirst = true
            self.appendData(klineArray: klineArray)
        } else {
            self.klineGroup.klineArray.removeAll()
            self.updateViewWidth()
            self.superScrollView.setContentOffset(CGPoint.zero, animated: false)
            self.draw()
        }
    }
    
    public func removeAllData() {
        self.klineGroup.klineArray.removeAll()
    }
    
}

//发送最后一个model
public protocol PKKLineSendNewstModelDelegate: NSObjectProtocol {
    func sendLastModel(_ model : PKKLine)
    
}
