//
//  PKKLineTimeView.swift
//  PrincekinKlineFrame
//
//  Created by LEE on 7/11/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit

public class PKKLineTimeView: UIView {

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    public let beginTimeLabel = UILabel()
    public var secondTimeLabel = UILabel()
    public var thirdTimeLabel = UILabel()
    public var fourthTimeLabel = UILabel()
    public let endTimeLabel = UILabel()
    private func setupView() {
        self.addSubview(self.beginTimeLabel)
        self.beginTimeLabel.textColor = PKKLineTheme.AccessoryTextColor
        self.beginTimeLabel.font = UIFont.systemFont(ofSize: PKKLineTheme.AccessoryTextFontSize)
        self.beginTimeLabel.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.bottom.equalToSuperview()
        }

        for i in 1..<4 {
            let label = UILabel()
            label.textColor = PKKLineTheme.AccessoryTextColor
            label.font = UIFont.systemFont(ofSize: PKKLineTheme.AccessoryTextFontSize)
            self.addSubview(label)
            label.snp.makeConstraints { maker in
                maker.top.equalToSuperview()
                maker.centerX.equalToSuperview().multipliedBy(Double(i) / 2.0)
                maker.bottom.equalToSuperview()
            }
            if i == 1{
                secondTimeLabel = label
            }else if i == 2{
                thirdTimeLabel = label
            }else if i == 3{
                fourthTimeLabel = label
            }
        }
        
        
        self.addSubview(self.endTimeLabel)
        self.endTimeLabel.textColor = PKKLineTheme.AccessoryTextColor
        self.endTimeLabel.font = UIFont.systemFont(ofSize: PKKLineTheme.AccessoryTextFontSize)
        self.endTimeLabel.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
    }
    
    public func update(beginTimeStamp: TimeInterval,secondTimeStamp: TimeInterval,thirdTimeStamp: TimeInterval,fourthTimeStamp: TimeInterval, endTimeStamp: TimeInterval) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd HH:mm"
        self.beginTimeLabel.text = dateFormatter.string(from: Date.init(timeIntervalSince1970: beginTimeStamp))
        self.secondTimeLabel.text = dateFormatter.string(from: Date.init(timeIntervalSince1970: secondTimeStamp))
        self.thirdTimeLabel.text = dateFormatter.string(from: Date.init(timeIntervalSince1970: thirdTimeStamp))
        self.fourthTimeLabel.text = dateFormatter.string(from: Date.init(timeIntervalSince1970: fourthTimeStamp))
        self.endTimeLabel.text = dateFormatter.string(from: Date.init(timeIntervalSince1970: endTimeStamp))
    }

}
