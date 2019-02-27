//
//  Video.swift
//  niYuoD
//
//  Created by Xhandsome on 2019/2/26.
//  Copyright © 2019 ZeroXsLab. All rights reserved.
//

import Foundation

class Video: BaseModel {
    var id: String?
    var dynamic_cover: Cover?
    var play_addr_lowbr: Play_Url?
    var width: Int?
    var ratio: String?
    var play_addr: Play_Url?
    var cover: Cover?
    var height: Int?
    var bit_rate =  [Bit_Rate]()
    var origin_cover: Cover?
    var duration: Int?
    var download_addr: Download_Addr?
    var has_watermark: Bool?
}

class Bit_Rate: BaseModel {
    var bit_rate: Int?
    var gear_name: String?
    var quality_type: Int?
}

class Download_Addr: BaseModel {
    var uri: String?
    var url_list = [String]()
}
