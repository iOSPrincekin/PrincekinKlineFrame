

//
//  PkKLineVolumeView.swift
//  PrincekinKlineFrame
//
//  Created by LEE on 7/11/18.
//  Copyright © 2018 LEE. All rights reserved.
//


import UIKit


public protocol PKKLineVolumeViewUpdateDelegate: NSObjectProtocol {
    func updateVolumeRightYRange(min: Double, max: Double)
}

public class PKKLineVolumeView: UIView {
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public weak var updateDelegate: PKKLineVolumeViewUpdateDelegate?
    public weak var klineView: PKKLineView!
    var kLineVolumeViewHeight : CGFloat = 0
    public override func layoutSubviews() {
        super.layoutSubviews()
       kLineVolumeViewHeight = frame.height
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public convenience init() {
        self.init(frame: CGRect.zero)
        self.layer.isOpaque = false
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext()!
        context.clear(rect)
        if self.klineArray.count == 0 {
            self.klineView.superScrollView.accessoryView.draw(klineArray: self.klineArray)
            return
        }
        
        // 绘制 Y轴参考虚线
        let referenceLineCount = PKKLineConfig.VolumeViewRightYCount - 2
        let step = rect.height / CGFloat(referenceLineCount + 1)
        context.setLineWidth(1)
        context.setStrokeColor(PKKLineTheme.BorderColor.cgColor)
        context.setLineDash(phase: 0, lengths: [1, 1])
        for index in 1...referenceLineCount {
            context.strokeLineSegments(between: [CGPoint.init(x: 0, y: CGFloat(index) * step), CGPoint.init(x: rect.width, y: CGFloat(index) * step)])
        }
        context.setLineDash(phase: 0, lengths: [])
        
        // 绘制 成交量柱状线 / MA线
        let volumePainter = PKKLineVolumePainter()
        for kline in self.klineArray {
            volumePainter.draw(context: context, kline: kline)
        }
        
        // 绘制 成交量 MA线
        let volumeMaPainter = PKKLineVolumeMAPainter()
        if PKKLineParamters.KLineMAType != .NONE {
            volumeMaPainter.draw(context: context, klineArray: self.klineArray)
        }
        
    }
    
    public var klineArray = [PKKLine]()
    func calculateBeforeDraw(klineArray: [PKKLine]){
        self.klineArray = klineArray
        self.setKlineVolumePosition()
    }
    public func draw(klineArray: [PKKLine]) {
        calculateBeforeDraw(klineArray:klineArray)
        self.setNeedsDisplay()
    }
    
    // MARK: - 设置数据在画布上的Position
    private func setKlineVolumePosition() {
        if self.klineArray.count == 0 {
            return
        }
        var maxVolume = self.klineArray[0].volume
        for kline in self.klineArray {
            if kline.volume > maxVolume {
                maxVolume = kline.volume
            }
        }
        // 顶部留点margin
        maxVolume *= 1.05
        PKKLineParamters.setVolumeDataDecimals(maxVolume, 0)
        let minY = CGFloat(0)
        let maxY = kLineVolumeViewHeight
        let unitValue = maxVolume / Double(maxY - minY)
        for index in 0..<self.klineArray.count {
            let kline = self.klineArray[index]
            let xPosition = CGFloat(self.klineView.startXPosition) + CGFloat(index) * (PKKLineConfig.KLineGap + PKKLineConfig.KLineWidth)
            kline.volumePosition.zeroPoint = CGPoint.init(x: xPosition, y: maxY)
            kline.volumePosition.volumePoint = CGPoint.init(x: xPosition, y: maxY - CGFloat(kline.volume / unitValue))
            
            kline.volumeMAPositions.removeAll()
            for key in kline.volumeMAs.keys.sorted() {
                kline.volumeMAPositions[key] = CGPoint.init(x: xPosition, y: maxY - CGFloat(kline.volumeMAs[key]! / unitValue))
            }
        }
   
            DispatchQueue.main.async(execute: {
                 self.updateDelegate?.updateVolumeRightYRange(min: 0, max: maxVolume)
            })

    }
}

