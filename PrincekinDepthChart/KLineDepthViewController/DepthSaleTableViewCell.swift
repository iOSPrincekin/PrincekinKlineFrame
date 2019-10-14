//
//  DepthSaleTableViewCell.swift
//  Canonchain
//
//  Created by LEE on 4/12/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit

public class DepthSaleTableViewCell: DepthTableViewCell {
    
    
	override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    class func returnDepthSaleTableViewCell() -> DepthSaleTableViewCell {
        let cell : DepthSaleTableViewCell = Bundle.main.loadNibNamed("DepthSaleTableViewCell", owner: self, options: nil)?.last as! DepthSaleTableViewCell
        return cell
    }
  
	override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    
        // Configure the view for the selected state
    }
   
	override public func draw(_ rect: CGRect) {
        super.draw(rect)
        let backgroundRect = CGRect(x: 0, y: 0, width: frame.width * backgroundPercent, height: frame.height)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(PKTranslucenceOrangeColor.cgColor)
        context.addRect(backgroundRect)
        context.fillPath()
    }
}
