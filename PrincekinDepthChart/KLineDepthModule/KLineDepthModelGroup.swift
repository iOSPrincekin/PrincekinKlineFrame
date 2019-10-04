//
//  KLineDepthModelGroup.swift
//  Canonchain
//
//  Created by LEE on 7/23/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit

public enum KLineDepthModelGroupPriceSortType : Int{    //按价格进行正序或反序排列
    case positive //正序
    case inverted //反序
}
public enum KLineDepthModelGroupIndexSortType : Int{      //对Index进行正序或反序排列
    case positive //正序
    case inverted //反序
}
//此枚举用于Group的初始化
public enum KLineDepthModelGroupOption {
    case priceSortType(KLineDepthModelGroupPriceSortType)
    case indexSortType(KLineDepthModelGroupIndexSortType)
    case dealtArrayCount(Int)
    case modelPriceDepth(Int)
    case modelPriceTotaldigit(Int)
}
/*
 Group的功能：
 1.接收原始model数据的Array
 2.处理原始model数组进行处理
 3.输出处理后的model数组
 */






//  KLineDepthModelGroup的再度优化：

/*
 
 背景:
 
 1.当前用于存储源数据的是originalDepthModelArray，其本质是KLineDepthModel的数组，之所以用model，是因为在做价格处理的更加方便直观，使用originalDepthModelArray在少量数据不会带来什么性能影响。但是后台socket有个机制是，在socket连接15min左右，会有一次重连，重连后将有大量深度图数据推送过来，每次有几千个，如果还采用KLineDepthModel数组的形式，在xcode显示的App信息上，会有300M左右的内存增加，也为后来的数据增加了工作量，不可取，所以再度优化；
 
 准备：
 1.当前算法经过测试，完全可用；
 2.数据存储集合选型：
 当前可用数据集合有：Array、Dictionary、Set
 Array由于是有序的，性能没有无序的Dictionary好，在价格排序方面  Dictionary也能完成工作；
 Set由于Socket返回的是[[String,String]]类型，在合并价格，排序方面不如Dictionary，综上采用Dictionary
 
 
 实施:
 1.创建originalDepthDataDictionary，用于存储源数据，使用字典，用价格作为key，amount作为value，不需要其他措施即可解决价格重复的问题；
 2.创建从[[String : String]]添加数据到originalDepthDataDictionary的方法,至此添加数据方法已经完成，剩余优化方法见下面数据处理模块
 
 
 */

//KLineDepthModelGroup的初始化方式
open class KLineDepthModelGroup: NSObject {

    //最大的挂单购买价格
    var maxBuyPrice = ""
    var groupOPtion : [KLineDepthModelGroupOption]!{
        didSet{
            for subOption in groupOPtion! {
                switch subOption{
                case let .priceSortType(value):
                    self.priceSortType = value
                case let .indexSortType(value):
                    self.indexSortType = value
                case let .dealtArrayCount(value):
                    self.dealtArrayCount = value
                case let .modelPriceDepth(value):
                    self.modelPriceDepth = value
                case let .modelPriceTotaldigit(value):
                    self.modelPriceTotaldigit = value
                }

            }
        }
  
    }
    //价格的排序方式
    var priceSortType : KLineDepthModelGroupPriceSortType!
    //标号的排序方式
    var indexSortType : KLineDepthModelGroupIndexSortType!
    //返回的dealtDepthModelArray数组元素个数
    var dealtArrayCount : Int!{

        didSet{
          
        }
    } 
    //model的价格深度
    var modelPriceDepth : Int!
    //model的价格要求总位数
    var modelPriceTotaldigit : Int!
    
    public init(groupOPtion : [KLineDepthModelGroupOption]!) {
    super.init()
    setGroupOPtion(groupOPtion)
     //   testFunc()
    setUPDealtDepthModelArray()
    }
    //在初始化方法中进行属性赋值不会走didSet方法，所以单独拿出来对groupOPtion赋值
    func setGroupOPtion(_ groupOPtion : [KLineDepthModelGroupOption]!) {
        self.groupOPtion =  groupOPtion
    }
    func testFunc()  {
        
    }
    func setUPDealtDepthModelArray() {
        //初始化完成相应数量的数组
        let initModel : KLineDepthModel! = KLineDepthModel()
        dealtDepthModelArray = Array<KLineDepthModel>(repeating: initModel, count: dealtArrayCount)
    }
    //原始的model数组，只进行初始化后添加model数据
    var originalDepthDataDictionary : [String : Double] = [String : Double]()
    //处理后的model数组，作为数据源输出
    var dealtDepthModelArray : Array<KLineDepthModel>!
    
    
}
//group添加原始数据
extension KLineDepthModelGroup{
    //初始化原始model数组
    func initData(array : [[String]]) {
    originalDepthDataDictionary.removeAll()
     addDataArrayToOriginalDepthDataDictionary(array)
        //初始化完成以后处理数据
        dealOriginalDepthModelArray()
    
    }
    func addDataArrayToOriginalDepthDataDictionary(_ array : [[String]]) {
        array.forEach{ depthDataArray in
            originalDepthDataDictionary[depthDataArray.first!] = Double(depthDataArray.last ?? "")
        }
    }
    //为原始model数组添加数据
    /*1.当前源数组包含有相同价格的model，直接添加即可
     2.已经含有相同价格的model，更新值
     */
    //在这个方法里面加入线程同步，防止快速推送 BibiDepthManager  未拦截的数据，使其再次在这里排队
    func appendData(array : [[String]]) {

            self.addDataArrayToOriginalDepthDataDictionary(array)
            //数据添加完成以后处理数据
            self.dealOriginalDepthModelArray()

    }
}





//负责对原始的model数组进行数据处理，提取到最终需要返回的数据
/*
 1.首先对对源数组进行剔除amount为“0”的model操作
 2.根据价格深度处理model的价格，并返回数组arr1
 3.对处理后价格的数组进行价格处理，合并价格重复的model，并返回一个新数组arr2
 4.对arr2进行价格排序
 5.按照要求取相应数量的子数组，arr3
 6.计算arr3的每个model所占的百分比，得到arr4
 7.将爱arr4的数组元素插入到dealtDepthModelArray
 8.为model添加下标
 9.添加更换深度的方法
 */


//  KLineDepthModelGroup的再度优化：

/*
1.由于采用的是字典
2.首先对对源数组进行剔除amount为“0”的model操作
3.对originalDepthDataDictionary进行key值排序，即价格排序得到sortedArr
4.对sortedArr留取前200个字典数据，并赋值给originalDepthDataDictionary 并在方法里返回拥有200字典的Array  200dataArray
5.根据价格深度处理200dataArray价格，并创建个newPriceArray，进行进行价格处理，合并价格重复的model
6. 对newPriceArray进行价格排序
7.按照要求取相应数量的子数组，arr1
8.将arr1赋值给depthModel，组成arr2
9.计算arr2的每个model所占的百分比，得到arr3
10.将爱arr3的数组元素插入到dealtDepthModelArray
11.为model添加下标
12.添加更换深度的方法
 
 */


extension KLineDepthModelGroup{
    //剔除amount为“0”的data
    func removeAmountZeroData(){
//         originalDepthModelArray = originalDepthModelArray.filter{
//            model in
//            return model.amount > 0
//        }
       originalDepthDataDictionary = originalDepthDataDictionary.filter{
    
            return $0.value > 0
        }
            
    }
    //对字典进行key即价格的排序
    func sortedOriginalDepthDataDictionary() -> [(key: String, value: Double)]{
        removeAmountZeroData()
        let sortedArr : [(key: String, value: Double)] = originalDepthDataDictionary.sorted{
            if priceSortType == .positive{
                return Double($0.0)! < Double($1.0)!
            }else{
                 return Double($0.0)! > Double($1.0)!
          }
        }
        originalDepthDataDictionary.removeAll()
        
        return sortedArr
    }
    //在sortedArr里面提取前200个data替换掉originalDepthDataDictionary
    func extract200DataReplaceOriginalDepthDataDictionary()->  [(key: String, value: Double)] {
        let sortedArr = sortedOriginalDepthDataDictionary()
        var extract200DataArray : [(key: String, value: Double)]!
        if sortedArr.count <= 200 {
            extract200DataArray = sortedArr
        }else{
            extract200DataArray = [(key: String, value: Double)](sortedArr[0..<200])
        }
     //   extract200DataArray = sortedArr
        extract200DataArray.forEach{
            originalDepthDataDictionary[$0.key] = $0.value
        }
        return extract200DataArray
        
    }
    
    //根据model价格深度对价格进行处理
    func dealExtract200DataArrayByPriceDepth()-> [[String : Double]]{
        let extract200DataArray = extract200DataReplaceOriginalDepthDataDictionary()
        var delaPrice200DataArray = [[String : Double]]()
        extract200DataArray.forEach{
            delaPrice200DataArray.append([PKDataProcessManager.formatterArithmeticStringByTotaldigit($0.key, modelPriceDepth,modelPriceTotaldigit) : $0.value])
        }
        
        //剔除价格为零的Dict
         delaPrice200DataArray = delaPrice200DataArray.filter{
           Double($0.keys.first ?? "")! > 0.0
        }
        return delaPrice200DataArray
        
    }
    //合并priceDepthDealArray里面价格相同的data
    func combinepriceDepthDealArrayDataPrice() -> [String : Double] {
        let priceDepthDealArray = dealExtract200DataArrayByPriceDepth()
        var noRepeatModelDic = [String : Double]()
        for dict1 in priceDepthDealArray {
             var isContainSomePriceDict = false
            for dict2 in noRepeatModelDic{
                if dict1.keys.first == dict2.key{
                  noRepeatModelDic[dict2.key] = dict1.values.first! + dict2.value
                    isContainSomePriceDict = true
                    break
                }
            }
              //如果不包含则进行添加
            if !isContainSomePriceDict{
               noRepeatModelDic[dict1.keys.first!] = dict1.values.first!
            }
        }
       return noRepeatModelDic
    }
    //将合并重复价格的Data根据价格重新排序
    func sortNoRepeatDataArrayByprice() -> [(key: String, value: Double)] {
        let priceSortedDataDictionary = combinepriceDepthDealArrayDataPrice()
        let sort200NoRepeatDataPriceArray : [(key: String, value: Double)] = priceSortedDataDictionary.sorted{
            if priceSortType == .positive{
                return Double($0.0)! < Double($1.0)!
            }else{
                return Double($0.0)! > Double($1.0)!
            }
            
        }
        return sort200NoRepeatDataPriceArray
    }
    //根据设定的dealtArrayCount返回响应数量model的数组
    func extractModelArrayAccordDealtArrayCount() -> [KLineDepthModel] {
        let priceSortedDataArray = sortNoRepeatDataArrayByprice()
        var extractDataArray : [(key: String, value: Double)]!
        var extractModelArray : [KLineDepthModel]!
        if priceSortedDataArray.count > dealtArrayCount {
              extractDataArray =  [(key: String, value: Double)](priceSortedDataArray[0..<dealtArrayCount])
        }else{
            extractDataArray = priceSortedDataArray
        }
        extractModelArray = extractDataArray.map{
            return KLineDepthModel.init(dict: $0)
        }
        return extractModelArray
    }
 
    //从model数组中提取价格集合
    func getModelAmountArray(_ array :  [KLineDepthModel]) -> [Double] {
        var amountTotal : Double = 0
        return array.map{ model  in
            amountTotal +=  model.amount
            return amountTotal
        }
    }
    //为extractModelArray里面的model添加百分比
    func addPercentageForEachModelInExtractModelArray() -> [KLineDepthModel] {
        let addedPercentModelArray = extractModelArrayAccordDealtArrayCount()
        if addedPercentModelArray.count > 0{
            let amountArray = getModelAmountArray(addedPercentModelArray)
            let amountTotal : Double = amountArray.last!
            for i in 0..<addedPercentModelArray.count{
                let percentage = amountArray[i] / amountTotal
                let model = addedPercentModelArray[i]
                model.percentage = CGFloat(percentage)
            }
        }
        return addedPercentModelArray
    }
    //将添加百分比完成的相应数量model数组插入到dealtDepthModelArray中并去除超出部分
    func insertExtractModelArrayInDealtDepthModelArray(){
        let addedPercentModelArray = addPercentageForEachModelInExtractModelArray()
        dealtDepthModelArray.removeAll()
        for _ in 0..<dealtArrayCount {
            let placeholderModel = KLineDepthEmptyModel()
            dealtDepthModelArray.insert(placeholderModel, at: 0)
        }
        dealtDepthModelArray.insert(contentsOf: addedPercentModelArray, at: 0)
        if dealtDepthModelArray.count > dealtArrayCount {
            dealtDepthModelArray.removeSubrange(dealtArrayCount..<dealtDepthModelArray.count)
        }
    }
    //为dealtDepthModelArray里面的model添加下标
    func polishIndexInDealtDepthModelArray() {
        insertExtractModelArrayInDealtDepthModelArray()
        dealtDepthModelArray.forEach { model in
            let index = dealtDepthModelArray.index(of: model)
                model.serial = index! + 1
        }
        maxBuyPrice = dealtDepthModelArray.first!.price
      
    }
    //切换深度图深度
    func changePriceDepthByNum(_ num : Int) {
        modelPriceDepth  = num
        polishIndexInDealtDepthModelArray()
    }
    //处理原始数据
    func dealOriginalDepthModelArray(){
        
       polishIndexInDealtDepthModelArray()
    }
    
}




