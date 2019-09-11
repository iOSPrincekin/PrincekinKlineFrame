//
//  PKKLineTool.swift
//  PrincekinKlineFrame
//
//  Created by LEE on 7/11/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import Foundation

public struct PKKLineTool {
    
    public static func dataDecimals(_ v1: Double, _ v2: Double) -> Int {
        let mv = (v1 + v2) / 2
        if mv < 1 {
            return PKKLineConfig.DataDecimals
        } else if mv < 10 && PKKLineConfig.DataDecimals > 1 {
            return PKKLineConfig.DataDecimals - 1
        } else if mv < 100 && PKKLineConfig.DataDecimals > 2 {
            return PKKLineConfig.DataDecimals - 2
        } else if mv < 1000 && PKKLineConfig.DataDecimals > 3 {
            return PKKLineConfig.DataDecimals - 3
        } else if mv < 10000 && PKKLineConfig.DataDecimals > 4 {
            return PKKLineConfig.DataDecimals - 4
        } else if mv < 100000 && PKKLineConfig.DataDecimals > 5 {
            return PKKLineConfig.DataDecimals - 5
        } else if mv < 1000000 && PKKLineConfig.DataDecimals > 6 {
            return PKKLineConfig.DataDecimals - 6
        }
        return 0
    }
    
}

