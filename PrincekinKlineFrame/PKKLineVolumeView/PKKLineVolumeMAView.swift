//
//  PKKLineVolumeMAView.swift
//  PrincekinKlineFrame
//
//  Created by LEE on 7/11/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit

public class PKKLineVolumeMAView: UIView {

    public func update(kline: PKKLine) {
        for subv in self.subviews {
            subv.removeFromSuperview()
        }
        
        let volumeText = String.init(format: "Volume:%.\(PKKLineParamters.VolumeDataDecimals)f", kline.volume)
        self.addLabel(index: 0, text: volumeText)
        
        var index = 1
        for key in kline.volumeMAs.keys.sorted() {
            let text = String.init(format: "MA\(key):%.\(PKKLineParamters.VolumeDataDecimals)f", kline.volumeMAs[key]!)
            self.addLabel(index: index, text: text)
            index += 1
        }
    }
    
    public func addLabel(index: Int, text: String, offset: Int = 0) {
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
