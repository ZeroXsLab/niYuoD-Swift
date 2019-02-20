//
//  UserRequest.swift
//  niYuoD
//
//  Created by Xhandsome on 2019/2/19.
//  Copyright © 2019 ZeroXsLab. All rights reserved.
//

import Foundation

class UserRequest: BaseRequest {
    
    var uid: String?
    
    static func findUser(uid: String, success: @escaping HttpSuccess, failure: @escaping HttpFailure){
        let request = UserRequest.init()
        request.uid = uid
        NetworkManager.getRequest(urlPath: "user", request: request, success: { (data) in
            let response = UserResponse.deserialize(from: data as? [String:Any])
            success(response?.data ?? User.init())
        }) { (error) in
            failure(error)
        }
    }
    
}
