//
//  UserResponse.swift
//  niYuoD
//
//  Created by Xhandsome on 2019/2/19.
//  Copyright © 2019 ZeroXsLab. All rights reserved.
//

import Foundation
import HandyJSON

class UserResponse: HandyJSON{
    
    required init() {
    }
    
    var code: Int?
    var message: String?
    var data: User?
    
}
