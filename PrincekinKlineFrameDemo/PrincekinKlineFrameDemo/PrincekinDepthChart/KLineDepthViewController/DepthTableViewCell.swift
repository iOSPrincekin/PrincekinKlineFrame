//
//  DepthTableViewCell.swift
//  Canonchain
//
//  Created by LEE on 5/2/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit

class DepthTableViewCell: UITableViewCell {

   @IBOutlet weak var serialLabel: UILabel!
   @IBOutlet weak var amountLabel: UILabel!
   @IBOutlet weak var priceLabel: UILabel!
    var backgroundPercent : CGFloat = 0
    var amountdigit = 4
    func setUPCellWithKLineDepthModel(model : KLineDepthModel) {
    //    let serialNum = ((model.serial == nil) ? 0 : model.serial!)
        serialLabel.text = String(model.serial )
        if model.amount == 0 {
            amountLabel.text = "--"
            priceLabel.text = "--"
        }else{
        amountLabel.text = WFSDataProcessManager.keepMultidigitDoublesOperationToString(model.amount, amountdigit)
        priceLabel.text = model.price
        }
        backgroundPercent = model.percentage
        setNeedsDisplay()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
