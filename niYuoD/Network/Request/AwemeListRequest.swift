//
//  AwemeListRequest.swift
//  niYuoD
//
//  Created by Xhandsome on 2019/2/26.
//  Copyright © 2019 ZeroXsLab. All rights reserved.
//

import Foundation

class AwemeListRequest: BaseRequest {
    
    var uid: String?
    var page: Int?
    var size: Int?
    
    static func findPostAwemesPaged(uid:String, page:Int, _ size:Int = 20, success: @escaping HttpSuccess, failure: @escaping HttpFailure){
        let request = AwemeListRequest.init()
        request.uid = uid
        request.page = page
        request.size = size
        NetworkManager.getRequest(urlPath: FindAwemePostByPageURL,
                                  request: request,
                                  success: { data in
                                    if let response = AwemeListResponse.deserialize(from: data as? [String:Any]){
                                       success(response)
                                    }
        },
                                  failure: { error in
                                    failure(error)
        })
    }
    
}
