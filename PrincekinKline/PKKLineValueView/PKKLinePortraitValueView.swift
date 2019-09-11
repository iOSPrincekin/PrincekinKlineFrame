//
//  PKKLinePortraitValueView.swift
//  PrincekinKlineFrame
//
//  Created by LEE on 7/13/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit

public class PKKLineBaseValueView: UIView {

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    public convenience init() {
//        self.init(frame: CGRect.zero)
//    }
    var kline : PKKLine?
    
   // public let keys = ["Date", "Open", "H", "L", "Close","Change","Change%","Executed"]
    public var keys = [String](){
        didSet{
           self.setupView()
        }
    }
    public var valueLabelsArr = [String : ValueLabel]()
    override init(frame: CGRect) {
        super.init(frame: frame)
      //  self.setupView()
        layer.cornerRadius = 0
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = PKKLineTheme.BorderColor.cgColor
        backgroundColor = PKKLineTheme.OptionButtonsViewBgColor
    }
    func setupView() {
        let heightStep = PKKLineConfig.PortraitValueViewHeight / CGFloat(keys.count)
        
        var preKeyLabel : KeyLabel?
        
        let margin = 6
        
        for title in keys {
            let keyLabel = KeyLabel()
            keyLabel.text = title
            let valueLabel = ValueLabel()
            valueLabelsArr[title] = valueLabel
            addSubview(keyLabel)
            addSubview(valueLabel)
            keyLabel.valueLabel = valueLabel
            keyLabel.snp.makeConstraints { make in
                if preKeyLabel == nil{
                    make.top.equalToSuperview()
                }else{
                    make.top.equalTo(preKeyLabel!.snp.bottom)
                }
            //    preKeyLabel == nil ? (make.top.equalToSuperview()) : (make.top.equalTo((preKeyLabel?.snp.bottom)!))
                make.left.equalToSuperview().offset(margin)
                make.height.equalTo(heightStep)
            }
            preKeyLabel = keyLabel
            valueLabel.snp.makeConstraints { make in
                make.top.equalTo(keyLabel)
                make.right.equalToSuperview().offset(-margin)
                make.height.equalTo(heightStep)
            }
            
            
            
        }
        
    }
    public func update(kline: PKKLine) {
        self.update(kline: kline)
    }
//    public func update(kline: PKKLine) {
//        self.kline = kline
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM-dd HH:mm"
//      //  self.beginTimeLabel.text = dateFormatter.string(from: Date.init(timeIntervalSince1970: beginTimeStamp))
//        valueLabelsArr["Date"]?.text = dateFormatter.string(from: Date.init(timeIntervalSince1970: kline.timeStamp))
//        valueLabelsArr["Open"]?.text = String.init(format: "%.\(PKKLineParamters.KLineDataDecimals)f", kline.open)
//        valueLabelsArr["H"]?.text = String.init(format: "%.\(PKKLineParamters.KLineDataDecimals)f", kline.high)
//       valueLabelsArr["L"]?.text = String.init(format: "%.\(PKKLineParamters.KLineDataDecimals)f", kline.low)
//         valueLabelsArr["Close"]?.text = String.init(format: "%.\(PKKLineParamters.KLineDataDecimals)f", kline.close)
//        let percent = (kline.close - kline.open) / kline.open * 100
//        let percentStr = String.init(format: "%.2f%%", percent)
//          valueLabelsArr["Change%"]?.text = percentStr
//    }
   open class KeyLabel: UILabel {
        var valueLabel : ValueLabel!
        convenience init() {
            self.init(frame: .zero)
        }
        override init(frame: CGRect) {
            super.init(frame: frame)
            textAlignment = .left
            textColor = UIColor.white
            font = UIFont.systemFont(ofSize: 12)
        }
        
    required public init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
   open class ValueLabel: UILabel {
    convenience init() {
            self.init(frame: .zero)
        }
        override init(frame: CGRect) {
            super.init(frame: frame)
            textAlignment = .right
            textColor = UIColor.white
            font = UIFont.systemFont(ofSize: 12)
        }
        
    required public init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

}
public class PKKLinePortraitValueView: PKKLineBaseValueView {
    init() {
        super.init(frame: .zero)
        keys = [String.localized_b2b_date, String.localized_b2b_open, String.localized_b2b_high, String.localized_b2b_low, String.localized_b2b_close,String.localized_b2b_rise_and_fall,String.localized_b2b_rise_and_fall_percent,String.localized_b2b_executed]
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func update(kline: PKKLine) {
        self.kline = kline
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd HH:mm"
        //  self.beginTimeLabel.text = dateFormatter.string(from: Date.init(timeIntervalSince1970: beginTimeStamp))
        valueLabelsArr[String.localized_b2b_date]?.text = dateFormatter.string(from: Date.init(timeIntervalSince1970: kline.timeStamp))
        valueLabelsArr[String.localized_b2b_open]?.text = String.init(format: "%.\(PKKLineParamters.KLineDataDecimals)f", kline.open)
        valueLabelsArr[String.localized_b2b_high]?.text = String.init(format: "%.\(PKKLineParamters.KLineDataDecimals)f", kline.high)
        valueLabelsArr[String.localized_b2b_low]?.text = String.init(format: "%.\(PKKLineParamters.KLineDataDecimals)f", kline.low)
        valueLabelsArr[String.localized_b2b_close]?.text = String.init(format: "%.\(PKKLineParamters.KLineDataDecimals)f", kline.close)
        let percent = (kline.close - kline.open) / kline.open * 100
        let changeString = String.init(format: "%.2f", (kline.close - kline.open))
        valueLabelsArr[String.localized_b2b_rise_and_fall]?.text = changeString
        let percentStr = String.init(format: "%.2f%%", percent)
        valueLabelsArr[String.localized_b2b_rise_and_fall_percent]?.text = percentStr
        if percent < 0 {
            valueLabelsArr[String.localized_b2b_rise_and_fall]?.textColor = PKKLineTheme.DownColor
            valueLabelsArr[String.localized_b2b_rise_and_fall_percent]?.textColor = PKKLineTheme.DownColor
        }else if percent == 0{
            valueLabelsArr[String.localized_b2b_rise_and_fall]?.textColor = PKKLineTheme.RiseColor
            valueLabelsArr[String.localized_b2b_rise_and_fall_percent]?.textColor = PKKLineTheme.RiseColor
        }else{
            valueLabelsArr[String.localized_b2b_rise_and_fall]?.text = "+" + changeString
            valueLabelsArr[String.localized_b2b_rise_and_fall_percent]?.text = "+" + percentStr
            valueLabelsArr[String.localized_b2b_rise_and_fall]?.textColor = PKKLineTheme.RiseColor
            valueLabelsArr[String.localized_b2b_rise_and_fall_percent]?.textColor = PKKLineTheme.RiseColor
        }
    }
    
}

public class PKTimeKLinePortraitValueView: PKKLineBaseValueView {

    init() {
        super.init(frame: .zero)
        keys = [String.localized_b2b_date,String.localized_b2b_kline_price,String.localized_b2b_executed]
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func update(kline: PKKLine) {
        self.kline = kline
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd HH:mm"
        //  self.beginTimeLabel.text = dateFormatter.string(from: Date.init(timeIntervalSince1970: beginTimeStamp))
        valueLabelsArr[String.localized_b2b_date]?.text = dateFormatter.string(from: Date.init(timeIntervalSince1970: kline.timeStamp))
        valueLabelsArr[String.localized_b2b_kline_price]?.text = String.init(format: "%.\(PKKLineParamters.KLineDataDecimals)f", kline.open)
        valueLabelsArr[String.localized_b2b_executed]?.text = String.init(format: "%.\(PKKLineParamters.KLineDataDecimals)f", kline.high)
    }
}
