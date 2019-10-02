
//
//  DepthBackgroundCellView.swift
//  Canonchain
//
//  Created by LEE on 4/28/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit
import SnapKit
class DepthBackgroundCellView: UIView {
 var floatViewWidthConstraint : Constraint?
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createFloatView()
      //  fatalError("init(coder:) has not been implemented")
    }
    func createFloatView()  {
        let floatView = UIView()
        floatView.backgroundColor = backgroundColor?.withAlphaComponent(0.2546)
        backgroundColor = UIColor.clear
        self.addSubview(floatView)
        floatView.snp.makeConstraints { (make) in
            make.bottom.top.right.equalToSuperview()
            floatViewWidthConstraint = make.width.equalTo(0).constraint
        }
    }
    func refreshUIWithPercentage(_ percentage : CGFloat){
        
        floatViewWidthConstraint?.update(offset: frame.width * percentage)
    }
}
