//
//  PKKLineCrossLine.swift
//  PrincekinKlineFrame
//
//  Created by LEE on 7/10/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit
public enum LineOrientation: Int {
    case portrait, landscape
}
public class PKKLineCrossLine: UIView {

    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = PKKLineTheme.TipTextColor
        label.font = UIFont.systemFont(ofSize: PKKLineTheme.TipTextFontSize)
        label.backgroundColor = PKKLineTheme.TipBgColor
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    lazy var line: UIView = {
        let line = UILabel()
        line.backgroundColor = PKKLineTheme.CrossLineColor
        return line
    }()
    
    private var orientation: LineOrientation!
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    public convenience init(orientation: LineOrientation) {
        self.init(frame: CGRect.zero)
        self.orientation = orientation
        self.setupView()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public func setupView() {
        self.addSubview(self.label)
        self.addSubview(self.line)
        if self.orientation == .portrait {
            self.label.snp.makeConstraints({ (maker) in
                maker.leading.equalToSuperview()
                maker.trailing.equalToSuperview()
                maker.bottom.equalToSuperview()
                maker.height.equalTo(PKKLineTheme.TipTextFontSize + 3)
            })
            self.line.snp.makeConstraints({ (maker) in
             //   maker.width.equalTo(1)
                maker.width.equalTo(PKKLineConfig.KLineWidth)
                maker.centerX.equalToSuperview()
                maker.top.equalToSuperview()
                maker.bottom.equalTo(self.label.snp.top)
            })
        } else {
            self.label.snp.makeConstraints({ (maker) in
                maker.trailing.equalToSuperview()
                maker.top.equalToSuperview()
                maker.bottom.equalToSuperview()
                maker.width.equalTo(PKKLineConfig.RightYViewWidth)
            })
            self.line.snp.makeConstraints({ (maker) in
                maker.height.equalTo(1)
                maker.centerY.equalToSuperview()
                maker.leading.equalToSuperview()
                maker.trailing.equalTo(self.label.snp.leading)
            })
        }
    }
    
    public func update(value: String) {
        self.label.text = " \(value) "
         if self.orientation == .portrait {
        self.line.snp.updateConstraints({ (maker) in
            maker.width.equalTo(PKKLineConfig.KLineWidth)
        })
        }
        self.line.snp.updateConstraints { make in
            
        }
    }
}
