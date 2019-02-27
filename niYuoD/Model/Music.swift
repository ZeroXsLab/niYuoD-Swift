//
//  Music.swift
//  niYuoD
//
//  Created by Xhandsome on 2019/2/26.
//  Copyright © 2019 ZeroXsLab. All rights reserved.
//

import Foundation

class Music: BaseModel {
    
    var cover_hd: Cover?
    var cover_large: Cover?
    var status: Int?
    var extra: String?
    var user_count: Int?
    var title: String?
    var duration: Int?
    var play_url: Play_Url?
    var mid: String?
    var is_restricted: Bool?
    var offline_desc: String?
    var schema_url: String?
    var cover_medium: Cover?
    var is_original: Bool?
    var id: String?
    var uid: Uid?
    var cover_thumb: Cover?
    var source_platform: Int?
    var author: String?
    var id_str: String?

}

class Cover: BaseModel {
    var uri: String?
    var url_list = [String]()
}

class Play_Url: BaseModel {
    var uri: String?
    var url_list = [String]()
}

class Uid: BaseModel {
    
}
