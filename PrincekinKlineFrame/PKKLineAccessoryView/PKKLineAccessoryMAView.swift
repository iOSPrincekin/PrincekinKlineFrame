//
//  PKKLineAccessoryMAView.swift
//  PrincekinKlineFrame
//
//  Created by LEE on 7/10/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit

public class PKKLineAccessoryMAView: UIView {

    public func update(kline: PKKLine) {
        for subv in self.subviews {
            subv.removeFromSuperview()
        }
        switch PKKLineParamters.AccessoryType {
        case .MACD:
            let text0 = "MACD(\(PKKLineParamters.KLineMACDPramas[0]),\(PKKLineParamters.KLineMACDPramas[1]),\(PKKLineParamters.KLineMACDPramas[2]))"
            self.addLabel(index: 0, text: text0)
            let text1 = String.init(format: "DIFF:%.\(PKKLineParamters.AccessoryDataDecimals)f", kline.klineMACD.DIFF)
            self.addLabel(index: 1, text: text1)
            let text2 = String.init(format: "DEA:%.\(PKKLineParamters.AccessoryDataDecimals)f", kline.klineMACD.DEA)
            self.addLabel(index: 2, text: text2)
            let text3 = String.init(format: "MACD:%.\(PKKLineParamters.AccessoryDataDecimals)f", abs(kline.klineMACD.BAR))
            self.addLabel(index: 3, text: text3, textColor: kline.klineMACD.BAR > 0 ? PKKLineTheme.RiseColor : PKKLineTheme.DownColor)
        case .KDJ:
            let text0 = "KDJ(\(PKKLineParamters.KLineKDJPramas[0]),\(PKKLineParamters.KLineKDJPramas[1]),\(PKKLineParamters.KLineKDJPramas[2]))"
            self.addLabel(index: 0, text: text0)
            let text1 = String.init(format: "K:%.\(PKKLineParamters.AccessoryDataDecimals)f", kline.klineKDJ.k)
            self.addLabel(index: 1, text: text1)
            let text2 = String.init(format: "D:%.\(PKKLineParamters.AccessoryDataDecimals)f", kline.klineKDJ.d)
            self.addLabel(index: 2, text: text2)
            let text3 = String.init(format: "J:%.\(PKKLineParamters.AccessoryDataDecimals)f", kline.klineKDJ.j)
            self.addLabel(index: 3, text: text3)
        case .RSI:
            let text0 = NSMutableString.init(string: "RSI(")
            for n in PKKLineParamters.KLineRSIPramas {
                text0.append("\(n),")
            }
            self.addLabel(index: 0, text: text0.substring(to: text0.length - 1) + ")")
            var index = 1
            for n in PKKLineParamters.KLineRSIPramas {
                let text = String.init(format: "RSI\(n):%.\(PKKLineParamters.AccessoryDataDecimals)f", kline.klineRSI.klineRSIs[n] ?? "0")
                self.addLabel(index: index, text: text)
                index += 1
            }
        default: break
        }
    }
    
    public func addLabel(index: Int, text: String, offset: Int = 0, textColor: UIColor? = nil) {
        let label = UILabel()
        label.textColor = textColor ?? PKKLineTheme.MAColors[index + offset]
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
