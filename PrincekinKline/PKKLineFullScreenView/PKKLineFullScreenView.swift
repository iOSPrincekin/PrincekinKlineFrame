
//
//  PKKLineFullScreenView.swift
//  Canonchain
//
//  Created by LEE on 7/19/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit
//全屏显示
public class PKKLineFullScreenView: UIView {
    let topView = PKKLineFullScreenTopView()
    let middleView = PKKLineFullScreenMiddleView()
    let bottomView = PKKLineFullScreenBottomView()
   public var closeBlock : PKKLineFullScreenViewCloseBlock!{
        didSet{
            topView.closeBlock = closeBlock
        }
    }
  public weak var bottomButtonClickDelegate : FullScreenButtonClickDelegate?
   public convenience init() {
        self.init(frame: .zero)
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
     public override  func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = PKKLineTheme.KLineChartBgColor
        NotificationCenter.default.addObserver(self, selector: #selector(bottomButtonClick(not : )), name: PKKLineParamters.FullScreenButtonClickNot, object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(indexButtonClick(not :)), name: PKKLineParamters.FullScreenRightViewButtonClickNot, object: nil)
        setUPUI()
    }
   @objc func bottomButtonClick(not : Notification) {
    let title : String = not.object as! String
    bottomButtonClickDelegate?.buttonClick(title)
    }
    @objc func indexButtonClick(not : Notification) {
        let type : IndexOptionButtonType = not.object as! IndexOptionButtonType
        bottomButtonClickDelegate?.indexButtonClick(type.rawValue)
    }
    public required init?(coder aDecoder: NSCoder) {
    //    fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    //更新topView信息
   public func updateVlaues(symbol : String,virtualPriceString : String,upOrDownString : String,legalPriceString : String, HString : String, LString : String,TwentyFourHString : String) {
    topView.updateVlaues(symbol: symbol, virtualPriceString: virtualPriceString,upOrDownString : upOrDownString, legalPriceString: legalPriceString, HString: HString, LString: LString, TwentyFourHString: TwentyFourHString)
    }
    func setUPUI(){
        addSubview(topView)
    
        topView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(PKKLineConfig.fullScreenTopViewHeight)
            
        }
        addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(PKKLineConfig.fullScreenBottomViewHeight)
        }
        addSubview(middleView)
        middleView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
        }
     //   middleView.alpha = 0.2
        bringSubview(toFront: bottomView)
        
    }
    public func reloadData(klineArray: [PKKLine]) {
        middleView.mainView.scrollView.klineView.reloadData(klineArray: klineArray)
    }
    public func appendData(klineArray: [PKKLine]) {
        middleView.mainView.scrollView.klineView.appendData(klineArray: klineArray)
    }
    deinit {
         NotificationCenter.default.removeObserver(self)
    }
    
}
public protocol FullScreenButtonClickDelegate: NSObjectProtocol {
    func buttonClick(_ title : String)
    func indexButtonClick(_ str : String)
}
