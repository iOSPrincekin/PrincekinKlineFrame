//
//  KLineDepthModel1.swift
//  Canonchain
//
//  Created by LEE on 4/27/18.
//  Copyright © 2018 LEE. All rights reserved.
//
/*
import UIKit

@objcMembers class KLineDepthModel1: NSObject,NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = KLineDepthModel1()
        copy.price = price
        copy.amount = amount
        return copy
    }
    var price:String = ""
    var amount:Double = 0.0
    var serial:Int?
    var percentage:CGFloat = 0.0
    class func returnModelWithArray(_ array : [Any]) -> KLineDepthModel1 {
        let model = KLineDepthModel1()
        model.setValueWithArray(array)
        return model
    }
    func setValueWithArray(_ array : [Any]){
        amount = array[0] as! Double
        price = array[1] as! String
    }
}
enum GrouopType : Int{      //当前Group的类型
    case kline //K线图
    case bibiBuyAndSale //币币交易
}
@objcMembers class KLineDepthModel1Group : NSObject {
    
    var depthModelGroup : [KLineDepthModel1] = [KLineDepthModel1]()  //往外输出的数据
    var defalutDepthModelGroup : [KLineDepthModel1] = [KLineDepthModel1]()   //默认数据，只要不超出limit，就加入其中
    
    var minPrice : Double = 0
    var maxPrice : Double = 0
    var wDepthUnit = 4  // 默认深度
//    var wTotaldigit = 4  // 默认总位数
    var wLimit = 0   //默认限制
    
   

    var priceSortType : PriceSortType?
    var indexSortType : IndexSortType?
    var grouopType : GrouopType?
    
    
    var count : Int?{
        get{
            return depthModelGroup.count
        }
    }
    func setGroupWithArray(_ array : [[Any]],_ totaldigit : Int){
        for subArr : [Any] in array {
            let kDepthmodel : KLineDepthModel1 = KLineDepthModel1.wfs_setModelWithArray(subArr) as! KLineDepthModel1
            defalutDepthModelGroup.append(kDepthmodel)
        }
//      sortByprice()
//       refreshModelGroupWithIndexAndPercentage(depthModelGroup)
        sortDefalutDepthModelGroupByprice()
         sortByDepthMergeUnit(wDepthUnit,totaldigit)
    }
    func getMinAndMaxPrice(_ modelGroup : [KLineDepthModel1]) {
     //   minPrice = (modelGroup.first?.price)!
        if modelGroup.count > 0{
        if type(of: self) == BidsKLineDepthModel1Group.self{
            maxPrice = Double((modelGroup.first?.price)!) ?? 0
        }else{
            maxPrice = Double((modelGroup.last?.price)!) ?? 0
        }
        }
    }
    func modelAtIndex(_ index : Int) -> KLineDepthModel1 {
        return depthModelGroup[index]
    }
    
    func addDepthModelWithArrayGroup(_ array : [[Any]],_ limit : Int,_ totaldigit : Int) {
        wLimit = limit
        var isExit : Bool = false
       
        
        for subArr in array{
            let tempPrice : Double = Double(subArr[0] as! String)!
            if tempPrice > maxPrice && depthModelGroup.count == limit{
               continue
            }
            var removedModel : KLineDepthModel1?
            for kDepthmodel in depthModelGroup {
                if  Double(kDepthmodel.price) == tempPrice{
                    if Float(subArr[1] as! String)! == 0{
                    //    depthModelGroup.remove(at: depthModelGroup.index(of: kDepthmodel)!)
                        removedModel = kDepthmodel
                    }else{
                    kDepthmodel.amount = Double(subArr[1] as! String)!
                    }
                    isExit = true
                    continue
                }else{
                    isExit = false
                }
            }
            if removedModel != nil{
              depthModelGroup.remove(at: depthModelGroup.index(of: removedModel!)!)
            }
            if isExit{
                continue
            }
            let kDepthmodel : KLineDepthModel1 = KLineDepthModel1.wfs_setModelWithArray(subArr) as! KLineDepthModel1
            defalutDepthModelGroup.append(kDepthmodel)
        }
      sortDefalutDepthModelGroupByprice()
     sortByDepthMergeUnit(wDepthUnit,totaldigit)
    }
    //根据深度重新排序
    func sortByDepthMergeUnit(_ depthUnit : Int,_ totaldigit : Int) {
        
        let tDepthModelGroup : [KLineDepthModel1] = defalutDepthModelGroup.map{ model in
            let tModel = model.copy() as! KLineDepthModel1
            tModel.price = WFSDataProcessManager.formatterArithmeticStringByTotaldigit(tModel.price, depthUnit,totaldigit)
            return tModel
        }
        //剔除价格为零的model
        depthModelGroup = tDepthModelGroup.filter{ model in
            return Double(model.price)! > 0.0
        }
        combinePriceByRecursion()
        sortDepthModelGroupByprice()
        refreshModelGroupWithIndexAndPercentage(depthModelGroup)
        wDepthUnit = depthUnit
    }
    
    
    //采用递归  通过选择排序，合并相同价格的model  之所以使用递归  是因为在数组remove后，  for里面的depthModelGroup.count的数值没有改变
    func  combinePriceByRecursion() {
        for i in 0..<depthModelGroup.count{
            for j in i+1..<depthModelGroup.count{
                let modelI = depthModelGroup[i]
                let modelJ = depthModelGroup[j]
                if modelI.price == modelJ.price{
                    modelI.amount += modelJ.amount
                    depthModelGroup.remove(at: (depthModelGroup.index(of: modelJ))!)
                    combinePriceByRecursion()
                   return
                }
            }
           
        }
    }
    func sortDepthModelGroupByprice()  {
        if priceSortType == .positive{
            depthModelGroup.sort {Double($0.price) ?? 0 < Double($1.price) ?? 0}
        }else{
            depthModelGroup.sort {Double($0.price) ?? 0 > Double($1.price) ?? 0}
        }
        //补全空余
//        if depthModelGroup.count < wLimit{
//            for i in 0..<(wLimit - depthModelGroup.count){
//                let depathModel = KLineDepthModel1()
//                depathModel.price = "--"
//                depathModel.percentage = 0
//                 if priceSortType == .positive{
//                 depthModelGroup.insert(depathModel, at: 0)
//                 }else{
//                    depthModelGroup.append(depathModel)
//               
//                }
//            }
//        }
       
    }
    
    func sortDefalutDepthModelGroupByprice()  {
        if priceSortType == .positive{
            defalutDepthModelGroup.sort {Double($0.price) ?? 0 < Double($1.price) ?? 0}
        }else{
            defalutDepthModelGroup.sort {Double($0.price) ?? 0 > Double($1.price) ?? 0}
        }
        if defalutDepthModelGroup.count > wLimit{
            defalutDepthModelGroup.removeSubrange(wLimit..<defalutDepthModelGroup.count)
        }
        
    }
    
//    func addDepthModelWithArray(_ array : [Any],_ limit : Int){
//        let tempPrice : Double = Double(array[0] as! String)!
//        if tempPrice > maxPrice && depthModelGroup.count == limit{
//            return
//        }
//        for kDepthmodel in depthModelGroup {
//            if  Double(kDepthmodel.price) == tempPrice{
//                kDepthmodel.amount = Float(array[1] as! String)!
//                addPercentageForEachModel(depthModelGroup)
//                return
//            }
//        }
//         let kDepthmodel : KLineDepthModel1 = KLineDepthModel1.wfs_setModelWithArray(array) as! KLineDepthModel1
//        depthModelGroup.append(kDepthmodel)
//        if type(of: self) == BidsKLineDepthModel1Group.self{
//            depthModelGroup.sort {$0.price > $1.price}
//        }else{
//            depthModelGroup.sort {$0.price < $1.price}
//        }
//        if depthModelGroup.count > limit{
//        depthModelGroup.removeLast()
//        }
//        refreshModelGroupWithIndexAndPercentage(depthModelGroup)
//        }
    func refreshModelGroupWithIndexAndPercentage(_ array :  [KLineDepthModel1])  {
        polishIndexInDpthModelGroup(array)
        addPercentageForEachModel(array)
        getMinAndMaxPrice(array)
    }
    //为model添加下标
    func polishIndexInDpthModelGroup(_ array :  [KLineDepthModel1])  {
    
        array.forEach { model in
           let index = array.index(of: model)
            
             if indexSortType == .positive{
                model.serial = index! + 1
             }else{
                model.serial = array.count - index!
            }
        }
    }
    //从model数组中提取价格集合
    func getModelAmountArray(_ array :  [KLineDepthModel1]) -> [Double] {
        var amountTotal : Double = 0
        return array.map{ model  in
            amountTotal +=  model.amount
          return amountTotal
        }
    }
    //为model添加百分比
    func addPercentageForEachModel(_ array :  [KLineDepthModel1]) {
        if array.count > 0{
        let amountArray = getModelAmountArray(array)
        let amountTotal : Double = amountArray.last!
        for i in 0..<array.count{
            let percentage = amountArray[i] / amountTotal
            let model = array[i]
            model.percentage = CGFloat(percentage)
        }
        
    }
    }
    
}
class AsksKLineDepthModel1Group : KLineDepthModel1Group {
   override var grouopType: GrouopType?{
        didSet{
            if grouopType == .kline{
               priceSortType = .positive
               indexSortType = .positive
            }else{
                  priceSortType = .inverted
                  indexSortType = .inverted
            }
        }
    }
    
    class func returnAsksKLineDepthModel1GroupWithArray(_ array : [[Any]],_ totaldigit : Int) -> AsksKLineDepthModel1Group {
        let group = self.init()
        group.setGroupWithArray(array,totaldigit)
        return group
    }
    class func returnAsksKLineDepthModel1GroupWithArrayWithType(_ array : [[Any]],_ groupType : GrouopType,_ limit : Int,_ totaldigit : Int) -> AsksKLineDepthModel1Group {
//        let aGroup : AsksKLineDepthModel1Group = returnAsksKLineDepthModel1GroupWithArray(array)
//        aGroup.grouopType = groupType
//        return aGroup
        let group = self.init()
        group.wLimit = limit
        group.grouopType = groupType
        group.setGroupWithArray(array,totaldigit)
        return group
    }
}
class BidsKLineDepthModel1Group : KLineDepthModel1Group {
    override var grouopType: GrouopType?{
        didSet{
            if grouopType == .kline{
                priceSortType = .inverted
                indexSortType = .positive
            }else{
                priceSortType = .inverted
                indexSortType = .positive
            }
        }
    }
    class func returnBidsKLineDepthModel1GroupWithArray(_ array : [[Any]],_ totaldigit : Int) -> BidsKLineDepthModel1Group {
        let group = self.init()
        group.setGroupWithArray(array,totaldigit)
        return group
    }
    class func returnBidsKLineDepthModel1GroupWithArrayWithType(_ array : [[Any]],_ groupType : GrouopType, _ limit : Int,_ totaldigit : Int) -> BidsKLineDepthModel1Group {
//        let bGroup : BidsKLineDepthModel1Group =  returnBidsKLineDepthModel1GroupWithArray(array)
//        bGroup.grouopType = groupType
//        return bGroup
        let group = self.init()
        group.wLimit = limit
        group.grouopType = groupType
        group.setGroupWithArray(array,totaldigit)
        return group
    }
}
*/



