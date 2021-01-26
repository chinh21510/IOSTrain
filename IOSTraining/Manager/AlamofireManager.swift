//
//  AlamofireManager.swift
//  IOSTraining
//
//  Created by Chinh Dinh on 1/5/21.
//  Copyright © 2021 Chinh Dinh. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
class APIManager {
    init() {
        
    }
    static var alamofireManager : Session? = {
         let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 300
        configuration.timeoutIntervalForResource = 300
        let session = Session(configuration: configuration, startRequestsImmediately: true)
        return session
    }()
    
    class func requestAPI(api : String,method : HTTPMethod, parameter : Parameters, token: String, result : @escaping (JSON)->Void){
        let headers: HTTPHeaders = ["Authorization": token]
        
        alamofireManager?.request(api, method: method, parameters: parameter, headers: headers).responseJSON { response in
            if response != nil {
                switch response.result {
                case .success(_):
                    let data : JSON = try!  JSON(data: response.data!)
                    result(data)
                    break
                case .failure(_):
                    print("Error : \(response.response?.statusCode ?? 0)")
                    break
                }
            }
        }
    }
}
