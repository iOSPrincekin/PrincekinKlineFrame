//
//  PKKLineFullScreenTopView.swift
//  Canonchain
//
//  Created by LEE on 7/19/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit
public typealias PKKLineFullScreenViewCloseBlock = () -> Void
public class PKKLineFullScreenTopView: UIView {
    let symLabel = UILabel()
    let virtualPriceLabel = UILabel()
    let upOrDownLabel = UILabel()
    
    let legalPriceLabel = UILabel()
    let HKeyValueView = PKKLineFullScreenTopKeyVauleView()
    let LKeyValueView = PKKLineFullScreenTopKeyVauleView()
    let TwentyFourHKeyValueView = PKKLineFullScreenTopKeyVauleView()
    let cancelButton = UIButton()
    var closeBlock : PKKLineFullScreenViewCloseBlock!
    public convenience init() {
        self.init(frame: .zero)
    }
   public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = PKKLineTheme.KLineChartBgColor
        createSubViews()
    }
    func createSubViews() {
        let margin = 10
        addSubview(symLabel)
        symLabel.textColor = PKKLineTheme.TipTextColor
        symLabel.font = UIFont.systemFont(ofSize: PKKLineTheme.FullScreenTopBigTextFontSize)
        symLabel.snp.makeConstraints { make in
            make.left.equalTo(margin)
            make.top.bottom.equalToSuperview()
        }
        addSubview(virtualPriceLabel)
        virtualPriceLabel.textColor = PKKLineTheme.RiseColor
        virtualPriceLabel.font = UIFont.systemFont(ofSize: PKKLineTheme.FullScreenTopBigTextFontSize)
        virtualPriceLabel.snp.makeConstraints { make in
            make.left.equalTo(symLabel.snp.right).offset(margin)
            make.top.bottom.equalToSuperview()
        }
        addSubview(upOrDownLabel)
        upOrDownLabel.textColor = PKKLineTheme.RiseColor
        upOrDownLabel.font = UIFont.systemFont(ofSize: PKKLineTheme.FullScreenTopMiddleTextFontSize)
        upOrDownLabel.snp.makeConstraints { make in
            make.left.equalTo(virtualPriceLabel.snp.right).offset(margin)
            make.centerY.equalTo(virtualPriceLabel).offset(2)
        }
        addSubview(legalPriceLabel)
        legalPriceLabel.font = UIFont.systemFont(ofSize: PKKLineTheme.FullScreenTopBigTextFontSize)
        legalPriceLabel.textColor = PKKLineTheme.FullScreenTopDefaultTextColor
        legalPriceLabel.snp.makeConstraints { make in
            make.left.equalTo(upOrDownLabel.snp.right).offset(margin)
            make.top.bottom.equalToSuperview()
        }
        
        addSubview(cancelButton)
        cancelButton.setImage(UIImage.init(named: "PKKLineCancel@2x.jpg"), for: .normal)
        cancelButton.setImage(UIImage.init(named: "PKKLineCancel@2x.jpg"), for: .selected)
        cancelButton.addTarget(self, action: #selector(cancleClick), for: .touchUpInside)
        cancelButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(40)
        }
        let keyValueViewWidth = 70
        
        addSubview(TwentyFourHKeyValueView)
        TwentyFourHKeyValueView.snp.makeConstraints { make in
            make.right.equalTo(cancelButton.snp.left).offset(-margin)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(keyValueViewWidth)
        }
        addSubview(LKeyValueView)
        LKeyValueView.snp.makeConstraints { make in
            make.right.equalTo(TwentyFourHKeyValueView.snp.left).offset(-margin)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(keyValueViewWidth)
        }
        addSubview(HKeyValueView)
        HKeyValueView.snp.makeConstraints { make in
            make.right.equalTo(LKeyValueView.snp.left).offset(-margin)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(keyValueViewWidth)
        }
    }
    public func updateVlaues(symbol : String,virtualPriceString : String,upOrDownString : String,legalPriceString : String, HString : String, LString : String,TwentyFourHString : String) {
        symLabel.text = symbol
        virtualPriceLabel.text = virtualPriceString
        if upOrDownString.contains("-") {
            virtualPriceLabel.textColor = PKKLineTheme.DownColor
            upOrDownLabel.textColor = PKKLineTheme.DownColor
        }else{
            virtualPriceLabel.textColor = PKKLineTheme.RiseColor
             upOrDownLabel.textColor = PKKLineTheme.RiseColor
        }
        upOrDownLabel.text = upOrDownString
        legalPriceLabel.text = legalPriceString
        HKeyValueView.updateKeyAndValue(String.localized_b2b_high, HString)
        LKeyValueView.updateKeyAndValue(String.localized_b2b_low, LString)
        TwentyFourHKeyValueView.updateKeyAndValue("24H", TwentyFourHString)
    }
    @objc func cancleClick() {
        closeBlock!()
    }
    
   public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
class PKKLineFullScreenTopKeyVauleView: UIView {
    let keyLabel = UILabel()
    let valueLabel = UILabel()
    convenience init() {
        self.init(frame: .zero)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUPUI()
    }
    func setUPUI() {
        addSubview(keyLabel)
        keyLabel.textColor = PKKLineTheme.FullScreenTopDefaultTextColor
        keyLabel.font = UIFont.systemFont(ofSize: PKKLineTheme.FullScreenTopSmallTextFontSize)
        keyLabel.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
          
            
        }
        addSubview(valueLabel)
        valueLabel.textColor = PKKLineTheme.FullScreenTopDefaultTextColor
        valueLabel.font = UIFont.systemFont(ofSize: PKKLineTheme.FullScreenTopSmallTextFontSize)
        valueLabel.snp.makeConstraints { make in
            make.left.equalTo(keyLabel.snp.right).offset(2)
            make.top.right.bottom.equalToSuperview()
        }
    }
    func updateKeyAndValue(_ key : String, _ value : String)  {
        keyLabel.text = key
        valueLabel.text = value
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
