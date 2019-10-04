

//
//  PKAlamofire.swift
//  Canonchain
//
//  Created by LEE on 5/14/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import UIKit
import Alamofire
class PKAlamofire: NSObject {
    static let sharedInstance = PKAlamofire()
    private  override init() {}
    //设置超时时间
    static let sharedSessionManager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        return Alamofire.SessionManager(configuration: configuration)
    }()
    
  
    class func getDataWithURLStringAndParameterDic(_ urlString : String, _ parameterDic :NSMutableDictionary?,_ PKResponseData : @escaping (DataResponse<Any>) -> Void) {
                let requestHeader : HTTPHeaders = ["Language":"-CN"]
        var tempDic : NSMutableDictionary? = parameterDic
         PKDataProcessManager.dealDicWithTimestampAndSHA256(&tempDic)
        let transformParameterDic : [String : Any]? = tempDic as? [String : Any]
        Alamofire.request(urlString, method: .get, parameters: transformParameterDic, encoding: URLEncoding.default, headers: requestHeader).responseJSON(completionHandler:PKResponseData )
        
    }
    class func postDataWithURLStringAndParameterDic(_ urlString : String, _ parameterDic : NSMutableDictionary?,_ PKResponseData : @escaping (DataResponse<Any>) -> Void) {
        let requestHeader : HTTPHeaders = ["Language":"-CN"]
        var tempDic : NSMutableDictionary? = parameterDic
        PKDataProcessManager.dealDicWithTimestampAndSHA256(&tempDic)
        let transformParameterDic : [String : Any]? = tempDic as? [String : Any]
        Alamofire.request(urlString, method: .post, parameters: transformParameterDic, encoding: URLEncoding.default, headers: requestHeader).responseJSON(completionHandler:PKResponseData )
    }
    class func getDataWithURLStringAndParameterDicWithHeader(_ urlString : String, _ parameterDic :NSMutableDictionary?,_ PKResponseData : @escaping (DataResponse<Any>) -> Void){}
    class func postDataWithURLStringAndParameterDicWithHeader(_ urlString : String, _ parameterDic : NSMutableDictionary?,_ PKResponseData : @escaping (DataResponse<Any>) -> Void) {}
        //getResponseData
    class func getResponseDataInTestTarget(_ urlString : String, _ parameterDic :[String : Any]?, _ PKResponseData : @escaping (DataResponse<Data>) -> Void) {
        Alamofire.request(urlString, method: .get, parameters: parameterDic, encoding: URLEncoding.default, headers: nil).responseData(completionHandler: PKResponseData)
    }
  
}
