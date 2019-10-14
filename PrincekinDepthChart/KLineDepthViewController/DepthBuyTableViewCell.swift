//
//  DepthBuyTableViewCell.swift
//  Canonchain
//
//  Created by LEE on 4/12/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit

public class DepthBuyTableViewCell: DepthTableViewCell {

    
	override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    class func returnDepthBuyTableViewCell() -> DepthBuyTableViewCell {
        let cell : DepthBuyTableViewCell = Bundle.main.loadNibNamed("DepthBuyTableViewCell", owner: self, options: nil)?.last as! DepthBuyTableViewCell
        return cell
    }
  
	override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
   
    
	override public func draw(_ rect: CGRect) {
        super.draw(rect)
        let backgroundRect = CGRect(x: frame.width * (1.0 - backgroundPercent), y: 0, width: frame.width * backgroundPercent, height: frame.height)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(PKTranslucenceGreenColor.cgColor)
        context.addRect(backgroundRect)
        context.fillPath()
    }
}
