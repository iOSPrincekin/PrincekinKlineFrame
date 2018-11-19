//
//  PKKLineCalculator.swift
//  PrincekinKlineFrame
//
//  Created by LEE on 7/10/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit

extension PKKLine {
    // 重置并计算
    func reset(prevKline: PKKLine) {
        self.prevKline = prevKline
        self.index = prevKline.index + 1
        self.sumLastClose = self.close + self.prevKline.sumLastClose
     
        self.sumLastVolume = self.volume + self.prevKline.sumLastVolume
        self.klineMAs.removeAll()
        for ma in PKKLineParamters.KLineMAs {
            self.klineMAs[ma] = self.klineMA(n: ma) ?? Double(-1)
            self.volumeMAs[ma] = self.volumeMA(n: ma) ?? Double(-1)
        }
        for ema in PKKLineParamters.KLineEMAs {
            self.klineEMAs[ema] = self.klineEMA(n: ema)
        }
        self.calculateKlineBoll()
        self.calculateKlineMACD()
        self.calculateKlineKDJ()
        self.calculateKlineRSI()
    }
}

// MARK: - 普通均值计算
extension PKKLine {
    /// KLine MA
    func klineMA(n: Int) -> Double? {
        if self.index > n - 1 {
            return (self.sumLastClose - self.klineGroup.klineArray[self.index - n].sumLastClose) / Double(n)
        } else if self.index == n - 1 {
            return self.sumLastClose / Double(n)
        }
        return nil
    }
    /// Volume MA
    func volumeMA(n: Int) -> Double? {
        if self.index > n - 1 {
            return (self.sumLastVolume - self.klineGroup.klineArray[self.index - n].sumLastVolume) / Double(n)
        } else if self.index == n - 1 {
            return self.sumLastVolume / Double(n)
        }
        return nil
    }
}

// MARK: - EMA值计算
extension PKKLine {
    
    // EMA(today) = α * Price(today) + (1 - α) * EMA(yesterday)
    // α = 2 / (N + 1)
    // EMA(today) = α * (Price(today) - EMA(yesterday)) + EMA(yesterday);
    func klineEMA(n: Int) -> Double {
        if self.index > 0 {
            return Double(2) / Double(n + 1) * (self.close - self.prevKline.klineEMAs[n]!) + self.prevKline.klineEMAs[n]!
        } else {
            return self.close
        }
    }
}

// MARK: - BOLL值计算
extension PKKLine {
    
    func calculateKlineBoll() {
        let n = PKKLineParamters.KLineBollPramas["N"]!
        let p = PKKLineParamters.KLineBollPramas["P"]!
        self.calculateSumC_MA_Square(n: n)
        if self.index >= n {
            let MB = self.klineMA(n: n - 1)!
            let MD = sqrt((self.sumC_MA_Square - self.klineGroup.klineArray[self.index - n].sumC_MA_Square) / Double(n))
            let UP = MB + Double(p) * MD
            let DN = MB - Double(p) * MD
            self.klineBoll = PKKLineBoll.init(MB: MB, UP: UP, DN: DN)
        }
    }
    
    func calculateSumC_MA_Square(n: Int) {
        if let MA = self.klineMA(n: n) {
            let C_MA = self.close - MA
            let C_MA_Square = C_MA * C_MA
            self.sumC_MA_Square = C_MA_Square + self.prevKline.sumC_MA_Square
        }
    }
}

// MARK: - MACD值计算
extension PKKLine {
    func calculateKlineMACD() {
        self.klineMACD.EMA1 = self.klineMACD_EMA1(n: PKKLineParamters.KLineMACDPramas[0])
        self.klineMACD.EMA2 = self.klineMACD_EMA2(n: PKKLineParamters.KLineMACDPramas[1])
        self.klineMACD.DIFF = self.klineMACD.EMA1 - self.klineMACD.EMA2
        self.klineMACD.DEA = self.klineDEA(n: PKKLineParamters.KLineMACDPramas[2])
        self.klineMACD.BAR = (self.klineMACD.DIFF - self.klineMACD.DEA) * 2
    }
    
    // EMA(today) = α * Price(today) + (1 - α) * EMA(yesterday)
    // α = 2 / (N + 1)
    // EMA(today) = α * (Price(today) - EMA(yesterday)) + EMA(yesterday);
    func klineDEA(n: Int) -> Double {
        if self.index > 0 {
            return Double(2) / Double(n + 1) * (self.klineMACD.DIFF - self.prevKline.klineMACD.DEA) + self.prevKline.klineMACD.DEA
        } else {
            return self.klineMACD.DIFF
        }
    }
    
    func klineMACD_EMA1(n: Int) -> Double {
        if self.index > 0 {
            return Double(2) / Double(n + 1) * (self.close - self.prevKline.klineMACD.EMA1) + self.prevKline.klineMACD.EMA1
        } else {
            return self.close
        }
    }
    
    func klineMACD_EMA2(n: Int) -> Double {
        if self.index > 0 {
            return Double(2) / Double(n + 1) * (self.close - self.prevKline.klineMACD.EMA2) + self.prevKline.klineMACD.EMA2
        } else {
            return self.close
        }
    }
}

// MARK: - KDJ值计算
extension PKKLine {
    func calculateKlineKDJ() {
        let k = Double(PKKLineParamters.KLineKDJPramas[0])
        let d = Double(PKKLineParamters.KLineKDJPramas[1])
        let j = PKKLineParamters.KLineKDJPramas[2]
        let lowHigh = self.beforeMin(n: j)
        let rsv = (self.close - lowHigh.low) / (lowHigh.high - lowHigh.low) * 100
        self.klineKDJ.k = (rsv + (k - 1) * self.prevKline.klineKDJ.k) / k
        self.klineKDJ.d = (self.klineKDJ.k + (d - 1) * self.prevKline.klineKDJ.d) / d
        self.klineKDJ.j = 3 * self.klineKDJ.k - 2 * self.klineKDJ.d
    }
    
    func beforeMin(n: Int) -> (low: Double, high: Double) {
        var minIndex = self.index - (n - 1)
        if minIndex < 0 {
            minIndex = 0
        }
        var low = self.low
        var high = self.high
        for index in minIndex..<self.index {
            if self.klineGroup.klineArray[index].low < low {
                low = self.klineGroup.klineArray[index].low
            }
            if self.klineGroup.klineArray[index].high > high {
                high = self.klineGroup.klineArray[index].high
            }
        }
        return (low, high)
    }
}

// MARK: - RSI值计算
extension PKKLine {
    func calculateKlineRSI() {
        for n in PKKLineParamters.KLineRSIPramas {
            if let RSI = self.calculateRSI(n: n) {
                self.klineRSI.klineRSIs[n] = RSI
            }
        }
        if self.klineRSI.klineRSIs.count > 0 {
            let values = self.klineRSI.klineRSIs.values.sorted()
            self.klineRSI.bothRSI = (values.first!, values.last!)
        }
    }
    
    func calculateRSI(n: Int) -> Double? {
        if let RS = self.calculateRS(n: n) {
            return RS < 0 ? 100 : 100 * RS / (1 + RS)
        }
        return nil
    }
    
    func calculateRS(n: Int) -> Double? {
        if self.index >= n - 1 {
            let beginIndex = self.index + 1 - n
            var sumUp = Double(0)
            var sumDn = Double(0)
            for index in beginIndex...self.index {
                let kline = self.klineGroup.klineArray[index]
                let diff = kline.close - kline.prevKline.close
                if diff < 0 {
                    sumDn += diff
                } else {
                    sumUp += diff
                }
            }
            return sumDn == 0 ? Double(-1) : sumUp / abs(sumDn)
        }
        return nil
    }
    
    func maxRange(range1: (Double, Double), range2: (Double, Double)) -> (low: Double, high: Double) {
        let minValue = min(range1.0, range2.0)
        let maxValue = max(range1.1, range2.1)
        return (minValue, maxValue)
    }
}

// MARK: - MA/EMA指标的最大/小值，在遍历查找数据最大/小值的时候使用
extension PKKLine {
    
    var maxMA: Double {
        get {
            var maxMA = self.klineMAs.first?.value ?? 0
//            for maKey in self.klineMAs.keys.sorted() {
//                maxMA = max(maxMA, self.klineMAs[maKey]!)
//            }
            for maKey in self.klineMAs.keys {
                maxMA = max(maxMA, self.klineMAs[maKey] ?? 0)
            }
            return maxMA
        }
    }
    
    var minMA: Double {
        get {
            var minMA = self.klineMAs.first?.value ?? 0
//            for maKey in self.klineMAs.keys.sorted() {
//                minMA = min(minMA, self.klineMAs[maKey]!)
//            }
                        for maKey in self.klineMAs.keys {
                            minMA = min(minMA, self.klineMAs[maKey] ?? 0)
                        }
            return minMA
        }
    }
    
    var maxEMA: Double {
        get {
            var maxEMA = self.klineEMAs.first?.value ?? 0
//            for emaKey in self.klineEMAs.keys.sorted() {
//                maxEMA = max(maxEMA, self.klineEMAs[emaKey]!)
//            }
            for emaKey in self.klineEMAs.keys {
                maxEMA = max(maxEMA, self.klineEMAs[emaKey] ?? 0)
            }
            return maxEMA
        }
    }
    
    var minEMA: Double {
        get {
            var minEMA = self.klineEMAs.first?.value ?? 0
//            for emaKey in self.klineEMAs.keys.sorted() {
//                minEMA = min(minEMA, self.klineEMAs[emaKey]!)
//            }
            for emaKey in self.klineEMAs.keys {
                minEMA = min(minEMA, self.klineEMAs[emaKey] ?? 0)
            }
            return minEMA
        }
    }
}

