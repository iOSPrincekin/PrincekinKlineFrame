//
//  PKKLineMAView.swift
//  PrincekinKlineFrame
//
//  Created by LEE on 7/11/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit

public class PKKLineMAView: UIView {
    public func update(kline: PKKLine) {
        for subv in self.subviews {
            subv.removeFromSuperview()
        }
        switch PKKLineParamters.KLineMAType {
        case .MA:
            var index = 0
            for key in kline.klineMAs.keys.sorted() {
                let text = String.init(format: "MA\(key):%.\(PKKLineParamters.KLineDataDecimals)f", kline.klineMAs[key]!)
                self.addLabel(index: index, text: text, offset: 1)
                index += 1
            }
        case .EMA:
            var index = 0
            for key in kline.klineEMAs.keys.sorted() {
                let text = String.init(format: "EMA\(key):%.\(PKKLineParamters.KLineDataDecimals)f", kline.klineEMAs[key]!)
                self.addLabel(index: index, text: text, offset: 1)
                index += 1
            }
        case .BOLL:
            let bollText = "BOLL(\(PKKLineParamters.KLineBollPramas["N"]!), \(PKKLineParamters.KLineBollPramas["P"]!))"
            self.addLabel(index: 0, text: bollText)
            if let klineBoll = kline.klineBoll {
                let midText = String.init(format: "MID:%.\(PKKLineParamters.KLineDataDecimals)f", klineBoll.MB)
                self.addLabel(index: 1, text: midText)
                let upperText = String.init(format: "UPPER:%.\(PKKLineParamters.KLineDataDecimals)f", klineBoll.UP)
                self.addLabel(index: 2, text: upperText)
                let lowerText = String.init(format: "LOWER:%.\(PKKLineParamters.KLineDataDecimals)f", klineBoll.DN)
                self.addLabel(index: 3, text: lowerText)
            }
        default: break
        }
    }
    
    private func addLabel(index: Int, text: String, offset: Int = 0) {
        let label = UILabel()
        label.textColor = PKKLineTheme.MAColors[index + offset]
        label.font = UIFont.systemFont(ofSize: PKKLineTheme.AccessoryTextFontSize)
        self.addSubview(label)
        label.snp.makeConstraints({ [weak self] (maker) in
            if index == 0 {
                maker.leading.equalToSuperview().offset(1)
            } else {
                maker.leading.equalTo((self?.subviews[index - 1].snp.trailing)!).offset(5)
            }
            maker.top.equalToSuperview()
            maker.bottom.equalToSuperview()
        })
        label.text = text
    }
}
