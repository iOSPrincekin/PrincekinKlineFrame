//
//  PKKLineContainerView.swift
//  PrincekinKlineFrame
//
//  Created by LEE on 7/10/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit
import SnapKit
open class PKKLineContainerView: UIView {
    //往外界发送最新价格信息的model
    typealias SendNewstModelBlock = (PKKLine) -> Void
    var sedNewstBlock : SendNewstModelBlock?
    
    public   let mainView = PKKLineContainerMainView()
    public   let topButtonsView = PKKLineTopButtonsView()
    public   weak var kLineChangeTypeDelegate : PKKLineChangeKlineTypeDelegate?
    public   var buttonClickBlock : PKKLineTopButtonsViewButtonClickBlock!
     var indexButtonBeClickedBlock : ((String) -> Void)?
//    convenience init() {
//        self.init(frame: .zero)
//    }
//    public   override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//    
//    required public   init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    open   override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(klineTypeChanged), name: PKKLineParamters.PKKLineTypeChanged, object: nil)
        setupUI()
    }
    func setupUI() {
        self.addSubview(self.topButtonsView)
        self.topButtonsView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(30)
        }
        buttonClickBlock = topButtonsView.buttonClickBlock
        indexButtonBeClickedBlock = topButtonsView.indexButtonBeClickedBlock
        self.addSubview(self.mainView)
        mainView.snp.makeConstraints { make in
            make.top.equalTo(self.topButtonsView.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        mainView.scrollView.klineView.sendNewstDelegate = self
        self.bringSubview(toFront: self.topButtonsView)
    }
    @objc func klineTypeChanged() {
        self.kLineChangeTypeDelegate?.changeKlineType()
    }
    
    open   func appendData(klineArray: [PKKLine]) {
        mainView.scrollView.klineView.appendData(klineArray: klineArray)
    }
   
    open   func initData(klineArray: [PKKLine]) {
//        mainView.scrollView.klineView.klineGroup.removeAllKline()
//        mainView.scrollView.klineView.isFirst = true
//        mainView.scrollView.klineView.appendData(klineArray: klineArray)
        mainView.reloadData(klineArray: klineArray)
    }
    
    deinit {
        PKKLineParamters.KLineType = .Line
        NotificationCenter.default.removeObserver(self, name: PKKLineParamters.PKKLineTypeChanged, object: nil)
    }
    
}
extension PKKLineContainerView : PKKLineSendNewstModelDelegate{
    public   func sendLastModel(_ model: PKKLine) {
      sedNewstBlock?(model)
    }
}
//这个代理用于改变外部数据源，并刷新UI
public protocol PKKLineChangeKlineTypeDelegate: NSObjectProtocol {
    func changeKlineType()
   
}

public class PKKLineContainerMainView: UIView {
    
    public   let scrollView = PKKLineScrollView()
    public   let timeView = PKKLineTimeView()
    public   let klineMAView = PKKLineMAView()
    public   let klineValueView = PKKLineValueView()
    public   let kLinePortraitValueView = PKKLinePortraitValueView()
    public   let timePortraitValueView = PKTimeKLinePortraitValueView()
    public   var portraitValueView : PKKLineBaseValueView?
    public   let klineRightYView = PKKLineRightYView()
    public   let volumeMAView = PKKLineVolumeMAView()
    public   let volumeRightYView = PKKLineRightYView()
    public   let accessoryMAView = PKKLineAccessoryMAView()
    public   let accessoryRightYView = PKKLineRightYView()
    public   let verticlalLine = PKKLineCrossLine.init(orientation: .portrait)
    public   let horizontalLine = PKKLineCrossLine.init(orientation: .landscape)
    
    public   var currentShowKline: PKKLine?
    
    // 子视图 纵向 高度布局
    // ------- 15 -----
    // --- 3x -----
    // ---------1------
    // ------- 17 -----
    // --- 1x -----
    // ---------1------
    // ------- 17 -----
    // --- 1x -----
    // -------- 15 ----
    override public   func awakeFromNib() {
        super.awakeFromNib()
    }
    init() {
        super.init(frame: .zero)
        setupUI()
    
        let longGr = UILongPressGestureRecognizer.init(target: self, action: #selector(longGrResponse(longGr:)))
        longGr.minimumPressDuration = 0.2
          self.addGestureRecognizer(longGr)


    }
    @objc
    func longGrResponse(longGr: UILongPressGestureRecognizer) {
        if longGr.state == .ended {
            scrollView.isScrollEnabled = true
        }else{
            scrollView.isScrollEnabled = false
        }
        let point = longGr.location(in: self.scrollView.klineView)
        let windowPoint = longGr.location(in: self.window)
        self.scrollView.showSelectedKlineInfowithPositions(position: point, windowPoint: windowPoint)

    }

    required public   init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public   override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        // 绘制 X轴参考虚线
        let referenceLineCount = PKKLineConfig.DateShowCount - 1
        let step = frame.width / CGFloat(referenceLineCount)
        //   PKKLineConfig.DateStep = step
        context.setLineWidth(1)
        context.setStrokeColor(PKKLineTheme.BorderColor.cgColor)
        context.setLineDash(phase: 0, lengths: [1, 1])
        for index in 0...referenceLineCount {
            context.strokeLineSegments(between: [CGPoint.init(x: CGFloat(index) * step, y: 15), CGPoint.init(x:  CGFloat(index) * step, y: rect.height - 15)])
        }
//        // 绘制 Y轴参考虚线
 //       let YreferenceLineCount = PKKLineConfig.KLineViewRightYCount - 2
   //     let Ystep = rect.height / CGFloat(referenceLineCount + 1)
    //    context.setLineWidth(1)
   //     context.setStrokeColor(PKKLineTheme.BorderColor.cgColor)
    //    context.setLineDash(phase: 0, lengths: [1, 1])
//        for index in 0...YreferenceLineCount {
//            context.strokeLineSegments(between: [CGPoint.init(x: 0, y: CGFloat(index) * Ystep), CGPoint.init(x: rect.width, y: CGFloat(index) * Ystep)])
//        }
    }
    func setupUI() {
        self.registerOrResignNotificationObserver(isRegister: true)
        self.backgroundColor = PKKLineTheme.KLineChartBgColor
        
        //        self.addSubview(self.topButtonsView)
        //        self.topButtonsView.snp.makeConstraints { make in
        //            make.left.equalToSuperview()
        //            make.top.equalToSuperview()
        //            make.width.equalToSuperview()
        //            make.height.equalTo(30)
        //        }
        self.addSubview(self.klineMAView)
     //   self.klineMAView.backgroundColor = UIColor.red
        self.klineMAView.snp.makeConstraints { (maker) in
            //    maker.top.equalTo(self.topButtonsView.snp.bottom).offset(5)
            maker.top.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.trailing.equalTo(PKKLineConfig.RightYViewWidth)
            maker.height.equalTo(15)
        }
        
        self.addSubview(self.timeView)
        self.timeView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.height.equalTo(15)
        }
        
        self.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { [weak self] (maker) in
            maker.leading.equalToSuperview()
            // maker.trailing.equalTo(-PKKLineConfig.RightYViewWidth)
            maker.trailing.equalTo(0)
            maker.top.equalTo((self?.klineMAView.snp.bottom)!)
            maker.bottom.equalTo((self?.timeView.snp.top)!)
        }
        self.scrollView.layer.borderColor = PKKLineTheme.BorderColor.cgColor
        self.scrollView.layer.borderWidth = 1
        self.scrollView.pkDelegate = self
        
        self.addSubview(self.klineRightYView)
        self.klineRightYView.snp.makeConstraints { [weak self] (maker) in
            self?.setKLineRightYViewConstraint(maker: maker)
        }
        sendSubview(toBack: self.klineRightYView)
        
        self.addSubview(self.volumeMAView)
        self.volumeMAView.snp.makeConstraints { [weak self] (maker) in
            maker.leading.equalTo((self?.scrollView.snp.leading)!)
            maker.trailing.equalTo((self?.scrollView.snp.trailing)!)
            maker.height.equalTo(17)
            maker.top.equalTo((self?.klineRightYView.snp.bottom)!)
        }
        
        self.addSubview(self.volumeRightYView)
        self.volumeRightYView.snp.makeConstraints { [weak self] (maker) in
            self?.setVolumeRightYViewConstraint(maker: maker)
        }
        sendSubview(toBack: volumeRightYView)
        
        self.addSubview(self.accessoryMAView)
        self.accessoryMAView.snp.makeConstraints { [weak self] (maker) in
            maker.leading.equalTo((self?.scrollView.snp.leading)!)
            maker.trailing.equalTo((self?.scrollView.snp.trailing)!)
            maker.height.equalTo(17)
            maker.top.equalTo((self?.volumeRightYView.snp.bottom)!)
        }
        
        self.addSubview(self.accessoryRightYView)
        self.accessoryRightYView.snp.makeConstraints { [weak self] (maker) in
            maker.top.equalTo((self?.accessoryMAView.snp.bottom)!)
            maker.trailing.equalToSuperview()
            maker.width.equalTo(PKKLineConfig.RightYViewWidth)
            maker.height.equalToSuperview().multipliedBy(PKKLineConfig.AccessoryViewHeightRate()).offset(-PKKLineConfig.AccessoryViewHeightRate() * (self?.showMAViewHeight)!)
        }
        accessoryRightYView.alpha = 0
        sendSubview(toBack: accessoryRightYView)
        self.addSubview(self.horizontalLine)
        self.horizontalLine.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.centerY.equalTo(0)
        }
        self.horizontalLine.alpha = 0
        
        self.addSubview(self.verticlalLine)
        self.verticlalLine.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.scrollView.snp.top)
            maker.bottom.equalTo(self.scrollView.snp.bottom).offset(PKKLineTheme.TipTextFontSize + 3)
            maker.centerX.equalTo(0)
        }
        self.verticlalLine.alpha = 0
        
        //K线图的信息显示框
        self.addSubview(self.kLinePortraitValueView)
        self.kLinePortraitValueView.snp.makeConstraints { [weak self] (maker) in
            maker.top.equalTo((self?.scrollView.snp.top)!).offset(20)
            maker.leading.equalTo(PKKLineConfig.PortraitValueViewMargin)
            //     maker.trailing.equalTo((self?.scrollView.snp.trailing)!)
            maker.height.equalTo(PKKLineConfig.PortraitValueViewHeight)
            maker.width.equalTo(PKKLineConfig.PortraitValueViewWidth)
        }
        portraitValueView = self.kLinePortraitValueView
        self.kLinePortraitValueView.alpha = 0
        //分时图的信息显示框
        self.addSubview(self.timePortraitValueView)
        self.timePortraitValueView.snp.makeConstraints { [weak self] (maker) in
            maker.top.equalTo((self?.scrollView.snp.top)!).offset(20)
            maker.leading.equalTo(PKKLineConfig.PortraitValueViewMargin)
            //     maker.trailing.equalTo((self?.scrollView.snp.trailing)!)
            maker.height.equalTo(PKKLineConfig.TimePortraitValueViewHeight)
            maker.width.equalTo(PKKLineConfig.TimePortraitValueViewWidth)
        }
        self.timePortraitValueView.alpha = 0
        
        self.scrollView.klineView.updateDelegate = self
        self.scrollView.volumeView.updateDelegate = self
        self.scrollView.accessoryView.updateDelegate = self
    }
    
    
    @objc func klineMATypeChanged() {
        self.scrollView.klineView.draw()
        if let kline = self.currentShowKline {
            self.showMA(kline: kline)
        }
        //        layoutIfNeeded()
        //        setNeedsLayout()
    }
    
    public   var showAccessory: Bool = PKKLineParamters.AccessoryType != .NONE {
        didSet {
            self.klineRightYView.snp.remakeConstraints { [weak self] (maker) in
                self?.setKLineRightYViewConstraint(maker: maker)
            }
            self.volumeRightYView.snp.remakeConstraints { [weak self] (maker) in
                self?.setVolumeRightYViewConstraint(maker: maker)
            }
            self.accessoryMAView.alpha = showAccessory ? 1 : 0
            self.accessoryRightYView.alpha = showAccessory ? 1 : 0
            self.scrollView.showAccessory = showAccessory
        }
    }
    
    @objc func accessoryTypeChanged() {
        if PKKLineParamters.AccessoryType == .NONE {
            if self.showAccessory {
                self.showAccessory = false
            }
        } else {
            if !self.showAccessory {
                self.showAccessory = true
            }
            self.scrollView.accessoryView.draw(klineArray: self.scrollView.klineView.needDrawKlineArray)
          
        }
        if let kline = self.currentShowKline {
            self.showMA(kline: kline)
        }
    }
    
    @objc func klineStyleChanged() {
        if PKKLineParamters.KLineStyle == .curve {
            kLinePortraitValueView.alpha = 0
            portraitValueView = timePortraitValueView
        }else{
            timePortraitValueView.alpha = 0
            portraitValueView = kLinePortraitValueView
        }
        self.scrollView.klineView.draw()
    }
    
    func registerOrResignNotificationObserver(isRegister: Bool) {
        if isRegister {
            NotificationCenter.default.addObserver(self, selector: #selector(klineMATypeChanged), name: PKKLineParamters.PKKLineMATypeChanged, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(accessoryTypeChanged), name: PKKLineParamters.PKKLineAccessoryTypeChanged, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(klineStyleChanged), name: PKKLineParamters.PKKLineStyleChanged, object: nil)
        } else {
            
            NotificationCenter.default.removeObserver(self, name: PKKLineParamters.PKKLineMATypeChanged, object: nil)
            NotificationCenter.default.removeObserver(self, name: PKKLineParamters.PKKLineAccessoryTypeChanged, object: nil)
            NotificationCenter.default.removeObserver(self, name: PKKLineParamters.PKKLineStyleChanged, object: nil)
        }
    }
    
    deinit {
        self.registerOrResignNotificationObserver(isRegister: false)
    }
}

extension PKKLineContainerMainView {
    
    private func setKLineRightYViewConstraint(maker: ConstraintMaker) {
        maker.top.equalTo(self.klineMAView.snp.bottom)
        maker.trailing.equalToSuperview()
        maker.width.equalTo(PKKLineConfig.RightYViewWidth)
        maker.height.equalToSuperview().multipliedBy(PKKLineConfig.KLineViewHeightRate()).offset(-PKKLineConfig.KLineViewHeightRate() * self.showMAViewHeight)
        //    maker.height.equalTo(scrollView).multipliedBy(PKKLineConfig.KLineViewHeightRate()).offset(-PKKLineConfig.KLineViewHeightRate() * self.showMAViewHeight)
    }
    
    private func setVolumeRightYViewConstraint(maker: ConstraintMaker) {
        maker.top.equalTo(self.volumeMAView.snp.bottom)
        maker.trailing.equalToSuperview()
        maker.width.equalTo(PKKLineConfig.RightYViewWidth)
        maker.height.equalToSuperview().multipliedBy(PKKLineConfig.VolumeViewHeightRate()).offset(-PKKLineConfig.VolumeViewHeightRate() * self.showMAViewHeight)
        //     maker.height.equalTo(scrollView).multipliedBy(PKKLineConfig.VolumeViewHeightRate()).offset(-PKKLineConfig.VolumeViewHeightRate() * self.showMAViewHeight)
    }
    
    public   var showMAViewHeight: CGFloat {
        get {
            if showAccessory {
                return CGFloat(66)
            } else {
                return CGFloat(48)
            }
        }
    }
}

extension PKKLineContainerMainView: PKKLineViewUpdateDelegate {
    
    public   func updateKlineRightYRange(min: Double, max: Double) {
        self.klineRightYView.set(max: max, min: min, segment: PKKLineConfig.KLineViewRightYCount, decimals: PKKLineParamters.KLineDataDecimals)
    }
    
    public   func updateTimeRange(beginTimeStamp: TimeInterval,secondTimeStamp: TimeInterval,thirdTimeStamp: TimeInterval,fourthTimeStamp: TimeInterval, endTimeStamp: TimeInterval) {
        //   self.timeView.update(beginTimeStamp: beginTimeStamp, endTimeStamp: endTimeStamp)
        self.timeView.update(beginTimeStamp: beginTimeStamp, secondTimeStamp: secondTimeStamp, thirdTimeStamp: thirdTimeStamp, fourthTimeStamp: fourthTimeStamp, endTimeStamp: endTimeStamp)
    }
    
}

extension PKKLineContainerMainView: PKKLineVolumeViewUpdateDelegate {
    
    public   func updateVolumeRightYRange(min: Double, max: Double) {
        self.volumeRightYView.set(max: max, min: min, segment: PKKLineConfig.VolumeViewRightYCount, decimals: PKKLineParamters.VolumeDataDecimals)
    }
    
}

extension PKKLineContainerMainView: PKKLineAccessoryViewUpdateDelegate {
    
    public   func updateAccessoryRightYRange(min: Double, max: Double) {
        self.accessoryRightYView.set(max: max, min: min, segment: PKKLineConfig.VolumeViewRightYCount, decimals: PKKLineParamters.AccessoryDataDecimals)
    }
    
}

extension PKKLineContainerMainView: PKKLineScrollViewDelegate {
    
    
    
    public   func selectedKline(kline: PKKLine,_ leftOrRight : Bool) {
        self.showSelectedKlineInfo(kline: kline,leftOrRight )
    }
    
    public   func hideKlineInfo(lastKline: PKKLine) {
        self.klineValueView.alpha = 0
        self.portraitValueView?.alpha = 0
        self.horizontalLine.alpha = 0
        self.verticlalLine.alpha = 0
        
        self.showMA(kline: lastKline)
    }
    
}

extension PKKLineContainerMainView {


    public   func showSelectedKlineInfo(kline: PKKLine,_ leftOrRight : Bool) {
        // self.klineValueView.alpha = 1
        self.portraitValueView?.alpha = 1
        //     self.klineValueView.update(kline: kline)
        self.portraitValueView?.update(kline: kline)
        self.portraitValueView?.snp.updateConstraints { make in
            if leftOrRight{
                make.leading.equalTo(PKKLineConfig.PortraitValueViewMargin)
            }else{
                make.leading.equalTo(frame.width - PKKLineConfig.PortraitValueViewWidth - PKKLineConfig.PortraitValueViewMargin)
            }
            
        }
        let point = self.scrollView.klineView.convert(kline.klinePosition.closePoint, to: self)
        self.horizontalLine.alpha = 1
        self.horizontalLine.update(value: String.init(format: "%.\(PKKLineParamters.KLineDataDecimals)f", kline.close))
        self.horizontalLine.snp.updateConstraints { (maker) in
            maker.centerY.equalTo(point.y)
        }
        
        self.verticlalLine.alpha = 0.6
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd HH:mm"
        self.verticlalLine.update(value: dateFormatter.string(from: Date.init(timeIntervalSince1970: kline.timeStamp)))
        self.verticlalLine.snp.updateConstraints { (maker) in
            maker.centerX.equalTo(point.x)
        }
        
        self.showMA(kline: kline)
    }
    
    
    public   func showMA(kline: PKKLine) {
        self.currentShowKline = kline
        self.klineMAView.update(kline: kline)
        self.volumeMAView.update(kline: kline)
        self.accessoryMAView.update(kline: kline)
    }
}

// 对外公开的方法
extension PKKLineContainerMainView {
    
    public   func minTimeStamp() -> Double {
        return self.scrollView.klineView.getKlineGroup().minTimeStamp()
    }
    
    public   func appendData(klineArray: [PKKLine]) {
        self.scrollView.klineView.appendData(klineArray: klineArray)
    }
    
    public   func reloadData(klineArray: [PKKLine]) {
        self.scrollView.klineView.reloadData(klineArray: klineArray)
    }
    
    public   func removeAllData() {
        self.scrollView.klineView.removeAllData()
    }
    
    public   func getKlineArray() -> [PKKLine] {
        return self.scrollView.klineView.getKlineGroup().klineArray
    }
    
    public   func redraw() {
        self.scrollView.klineView.draw()
    }
    
}

