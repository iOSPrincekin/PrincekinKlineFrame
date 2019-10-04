//
//  String-Extension.swift
//  Canonchain
//
//  Created by LEE on 6/14/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import Foundation
extension String {
    ///（如果backwards参数设置为true，则返回最后出现的位置）
    func positionOf(sub:String, backwards:Bool = false)->Int {
        // 如果没有找到就返回-1
        var pos = -1
        if let range = range(of:sub, options: backwards ? .backwards : .literal ) {
            if !range.isEmpty {
                pos = self.distance(from:startIndex, to:range.lowerBound)
            }
        }
        return pos
    }
}


