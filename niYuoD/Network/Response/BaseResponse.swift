//
//  BaseResponse.swift
//  niYuoD
//
//  Created by Xhandsome on 2019/2/26.
//  Copyright © 2019 ZeroXsLab. All rights reserved.
//

import Foundation

class BaseResponse: BaseModel {
    var code: Int?
    var message: String?
    var has_more: Int = 0
    var total_count: Int = 0
}
