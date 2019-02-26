//
//  NetworkManager.swift
//  niYuoD
//
//  Created by Xhandsome on 2019/2/19.
//  Copyright © 2019 ZeroXsLab. All rights reserved.
//

import Foundation
import Alamofire

typealias HttpSuccess = (_ data: Any) -> Void
typealias HttpFailure = (_ error: Error) -> Void

class NetworkManager: NSObject {
    
    private static let reachabilityManager = { () -> NetworkReachabilityManager in
        let manager = NetworkReachabilityManager.init()
        return manager!
    }
    
    private static let sessionManager = { () -> SessionManager in
       let manager = SessionManager.default
        return manager
    }()
    
    static func processData(data: [String:Any], success: @escaping HttpSuccess, failure: @escaping HttpFailure){
        let code: Int = data["code"] as! Int
        if(code == 0) {
            success(data)
        } else {
            let message: String = data["message"] as! String
            let error = NSError.init(domain: NetworkDomain, code: -1000, userInfo: [NSLocalizedDescriptionKey : message])
            failure(error)
        }
    }
    
    static func getRequest(urlPath: String, request: BaseRequest, success: @escaping HttpSuccess, failure: @escaping HttpFailure) {
        let parameters = request.toJSON()
        sessionManager.request(BaseUrl + urlPath,
                               method: HTTPMethod.get,
                               parameters: parameters,
                               encoding: URLEncoding.default,
                               headers: nil)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { (response) in
                print("Request Address: " + String.init(describing: response.request!))
                switch response.result {
                case .success:
                    let data: [String:Any] = response.result.value as! [String:Any]
                    processData(data: data, success: success, failure: failure)
                case .failure(let error):
                    let err: NSError = error as NSError
                    if(NetworkReachabilityManager.init()?.networkReachabilityStatus == .notReachable) {
                        failure(err)
                        return
                    }
                    let path = response.request?.url?.path
                    if((path?.contains(FindUserByUID_URL))!){
                        success(String.readJSON2DicWithFileName(fileName: FindUserByUID_URL))
                    } else {
                        failure(err)
                    }
                    break
                }
        }
    }
    
}

extension String {
    static func readJSON2DicWithFileName(fileName: String) -> [String:Any] {
        let path = Bundle.main.path(forResource: fileName, ofType: "json") ?? ""
        var dict = [String:Any]()
        do {
            let data = try Data.init(contentsOf: URL.init(fileURLWithPath: path))
            dict = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
        } catch {
            print(error.localizedDescription)
        }
        return dict
    }
}
