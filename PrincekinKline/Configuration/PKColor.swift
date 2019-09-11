//
//  PKColor.swift
//  PrincekinKlineFrame
//
//  Created by LEE on 7/10/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit

public extension UIColor {
    
    public convenience init(rgbaHex: UInt) {
        self.init(red: CGFloat(((rgbaHex & 0xff000000) >> 16) >> 8) / 255.0, green: CGFloat((rgbaHex & 0xff0000) >> 16) / 255.0, blue: CGFloat((rgbaHex & 0xff00) >> 8) / 255.0, alpha: CGFloat(rgbaHex & 0xff) / 255.0)
    }
    
    public convenience init(rgbHex: UInt, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat((rgbHex & 0xff0000) >> 16) / 255.0, green: CGFloat((rgbHex & 0xff00) >> 8) / 255.0, blue: CGFloat(rgbHex & 0xff) / 255.0, alpha: alpha)
    }
    
    public convenience init(red: Int, green: Int, blue: Int, alpha: Int = 255) {
        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: CGFloat(alpha) / 255)
    }
    
    public convenience init(rgbaHexStr: String) {
        var rgba = rgbaHexStr.replacingOccurrences(of: "0x", with: "")
        rgba = rgba.replacingOccurrences(of: "0X", with: "")
        rgba = rgba.replacingOccurrences(of: "#", with: "")
        if rgba.count != 6 && rgba.count != 8 {
            self.init(rgbHex: 0xFFFFFF)
            return
        }
        func number(withHexStr hexStr: String) -> UInt32 {
            var hexNumber: UInt32 = 0
            Scanner.init(string: hexStr).scanHexInt32(&hexNumber)
            return hexNumber
        }
        let rgbaStr = NSMutableString.init(string: rgba)
        let red = number(withHexStr: rgbaStr.substring(to: 2)) & 0xFF
        let green = number(withHexStr: rgbaStr.substring(with: NSRange.init(location: 2, length: 2))) & 0xFF
        let blue = number(withHexStr: rgbaStr.substring(with: NSRange.init(location: 4, length: 2))) & 0xFF
        var alpha = 255
        if rgba.count > 6 {
            alpha = Int(number(withHexStr: rgbaStr.substring(from: 6)) & 0xFF)
        }
        self.init(red: Int(red), green: Int(green), blue: Int(blue), alpha: alpha)
    }
}

