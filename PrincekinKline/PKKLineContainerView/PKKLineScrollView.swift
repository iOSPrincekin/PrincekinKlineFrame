//
//  PKKLineScrollView.swift
//  PrincekinKlineFrame
//
//  Created by LEE on 7/11/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit
import SnapKit

public protocol PKKLineScrollViewDelegate: NSObjectProtocol {
    func selectedKline(kline: PKKLine,_ leftOrRight : Bool)
    func hideKlineInfo(lastKline: PKKLine)
}

public class PKKLineScrollView: UIScrollView {
    //线程同步保证数据的安全
    let semaphore = DispatchSemaphore(value: 1)
    //BibiDepthManager处理数据的队列
    
    var queue : DispatchQueue!
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var superScrollViewWidth : CGFloat = 0
    var superScrollViewContentOffsetX : CGFloat = 0
    public override func layoutSubviews() {
        super.layoutSubviews()
        superScrollViewWidth = frame.width
    }

    public weak var pkDelegate: PKKLineScrollViewDelegate?
    public var loadMore: (()->())?
    
    public let klineView = PKKLineView()
    public let volumeView = PKKLineVolumeView()
    public let accessoryView = PKKLineAccessoryView()
    
    public convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        //防止正常和全屏之间的queue相互干扰
        queue = DispatchQueue(label: PKKLineConfig.PKKlineDealDataQueue + String.init(format: "%p", self))
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.bounces = false
        self.delegate = self
        self.maximumZoomScale = 20
        self.minimumZoomScale = 1
        
        self.addSubview(self.klineView)
        self.klineView.superScrollView = self
        self.klineView.snp.makeConstraints { [weak self] (maker) in
            self?.setKLineViewConstraint(maker: maker)
        }
        
        let separator1 = UIView()
        separator1.backgroundColor = PKKLineTheme.BorderColor
        self.addSubview(separator1)
        separator1.snp.makeConstraints { [weak self] (maker) in
            maker.top.equalTo((self?.klineView.snp.bottom)!)
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.height.equalTo(1)
            maker.width.equalTo((self?.klineView.snp.width)!)
        }
        
        self.addSubview(self.volumeView)
        self.volumeView.klineView = self.klineView
        self.volumeView.snp.makeConstraints { [weak self] (maker) in
            self?.setVolumeViewConstraint(maker: maker)
        }
        
        let separator2 = UIView()
        separator2.backgroundColor = PKKLineTheme.BorderColor
        self.addSubview(separator2)
        separator2.snp.makeConstraints { [weak self] (maker) in
            maker.top.equalTo((self?.volumeView.snp.bottom)!)
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.height.equalTo(1)
            maker.width.equalTo((self?.klineView.snp.width)!)
        }
        
        self.addSubview(self.accessoryView)
        self.accessoryView.klineView = self.klineView
        self.accessoryView.snp.makeConstraints { [weak self] (maker) in
            maker.top.equalTo((self?.volumeView.snp.bottom)!).offset(17)
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.height.equalToSuperview().multipliedBy(PKKLineConfig.AccessoryViewHeightRate()).offset(-(self?.showMAViewHeight)! * PKKLineConfig.AccessoryViewHeightRate())
            maker.width.equalTo((self?.klineView.snp.width)!)
        }
       
        let pinchGr = UIPinchGestureRecognizer.init(target: self, action: #selector(pinchGrResponse(pinchGr:)))
        pinchGr.delegate = self
        self.addGestureRecognizer(pinchGr)
        let longGr = UILongPressGestureRecognizer.init(target: self, action: #selector(longGrResponse(longGr:)))
        longGr.minimumPressDuration = 1
       // self.addGestureRecognizer(longGr)
        
        
    }
    @objc
    func longGrResponse(longGr: UILongPressGestureRecognizer) {
       
    }
   
  
    public var showAccessory: Bool = PKKLineParamters.AccessoryType != .NONE {
        didSet {
            self.klineView.snp.remakeConstraints { [weak self] (maker) in
                self?.setKLineViewConstraint(maker: maker)
            }
            self.volumeView.snp.remakeConstraints { [weak self] (maker) in
                self?.setVolumeViewConstraint(maker: maker)
            }
        }
    }
    
    var oldScale = CGFloat(1)
    @objc func pinchGrResponse(pinchGr: UIPinchGestureRecognizer) {
        if pinchGr.numberOfTouches == 2 {
            let diff = pinchGr.scale - oldScale
            if abs(diff) > PKKLineConfig.ZoomScaleLimit {
                oldScale = pinchGr.scale
             //   let startIndex = Int((superScrollViewContentOffsetX - PKKLineConfig.KLineGap) / (PKKLineConfig.KLineGap + PKKLineConfig.KLineWidth))
                if PKKLineParamters.changeZoomScale(changeScale: diff > 0 ? PKKLineConfig.ZoomScaleFactor : -PKKLineConfig.ZoomScaleFactor) {
                    self.klineView.updateViewWidth()
                 //   self.setContentOffset(CGPoint.init(x: superScrollViewContentOffsetX, y: 0), animated: false)
                    //  self.klineView.draw()
                    drawViews()
                }
            }
        }
    }
    
}

public extension PKKLineScrollView {
    
    private func setKLineViewConstraint(maker: ConstraintMaker) {
        maker.top.equalToSuperview()
        maker.leading.equalToSuperview()
        maker.trailing.equalToSuperview()
        maker.height.equalToSuperview().multipliedBy(PKKLineConfig.KLineViewHeightRate()).offset(-self.showMAViewHeight * PKKLineConfig.KLineViewHeightRate())
        maker.width.equalTo(self.klineView.viewWidth)
    }
    
    private func setVolumeViewConstraint(maker: ConstraintMaker) {
        maker.top.equalTo(self.klineView.snp.bottom).offset(17)
        maker.leading.equalToSuperview()
        maker.trailing.equalToSuperview()
        maker.width.equalTo(self.klineView.snp.width)
        maker.height.equalToSuperview().multipliedBy(PKKLineConfig.VolumeViewHeightRate()).offset(-self.showMAViewHeight * PKKLineConfig.VolumeViewHeightRate())
    }
    
    var showMAViewHeight: CGFloat {
        get {
            if PKKLineParamters.AccessoryType != .NONE {
                return CGFloat(36)
            } else {
                return CGFloat(18)
            }
        }
    }
}

extension PKKLineScrollView: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        superScrollViewContentOffsetX = scrollView.contentOffset.x
        drawViews()
        if self.klineView.getKlineGroup().klineArray.count > 0 {
            self.pkDelegate?.hideKlineInfo(lastKline: self.klineView.getKlineGroup().klineArray.last!)
        } else {
            self.pkDelegate?.hideKlineInfo(lastKline: PKKLine())
        }
        
        if superScrollViewContentOffsetX <= 0 {
            self.loadMore?()
        }
    }
    func drawViews()  {
        self.queue.async(execute: {
            self.semaphore.wait()
            let needDrawKlineArray = self.klineView.calculateBeforeDraw()
            self.volumeView.calculateBeforeDraw(klineArray: needDrawKlineArray)
            self.accessoryView.calculateBeforeDraw(klineArray: needDrawKlineArray)
           
                DispatchQueue.main.async(execute: {
                    self.klineView.setNeedsDisplay()
                    self.volumeView.setNeedsDisplay()
                    self.accessoryView.setNeedsDisplay()
                })
            
     
            self.semaphore.signal()
        })
    }
}

extension PKKLineScrollView {
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first!.location(in: self.klineView)
        let windowPoint = touches.first!.location(in: self.window)
        showSelectedKlineInfowithPositions(position: point, windowPoint: windowPoint)
    }
    func showSelectedKlineInfowithPositions(position : CGPoint,windowPoint : CGPoint) {
        var right : Bool = false
        
        if windowPoint.x > frame.width / 2.0 {
            right = true
        }
        if let selectedKline = self.klineView.getSelectedKline(touchPoint: position) {
          self.pkDelegate?.selectedKline(kline: selectedKline, right)
        }
    }
    
}
extension PKKLineScrollView : UIGestureRecognizerDelegate{
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool{
        return true
    }
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool{
        return true
    }
}
