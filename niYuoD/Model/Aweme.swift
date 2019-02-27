//
//  Aweme.swift
//  niYuoD
//
//  Created by Xhandsome on 2019/2/26.
//  Copyright © 2019 ZeroXsLab. All rights reserved.
//

import Foundation

class Aweme: BaseModel {
    
    var author: User?
    var music: Music?
    var cmt_swt: Bool?
    var is_top: Int?
    var risk_infos: Risk_Infos?
    var region: String?
    var user_digged: Int?
    var video_text = [Video_Text]()
    var cha_list: Cha_List?
    var is_ads: Bool?
    var bodydance_score: Int?
    var law_critical_country: Bool?
    var author_user_id: Int?
    var create_time: Int?
    var statistics: Statistics?
    var sort_label: String?
    var descendants: Descendants?
    var video_labels = [Video_Labels]()
    var geofencing = [Geofencing]()
    var is_relieve: Bool?
    var status: Status?
    var vr_type: Int?
    var aweme_type: Int?
    var aweme_id: String?
    var video: Video?
    var is_pgcshow: Bool?
    var desc: String?
    var is_hash_tag: Int?
    var share_info: Share_Info?
    var share_url: String?
    var scenario: Int?
    var label_top: Label_Top?
    var rate: Int?
    var can_play: Bool?
    var is_vr: Bool?
    var text_extra = [Text_Extra]()
}

class Risk_Infos: BaseModel {
    var warn: Bool?
    var content: String?
    var risk_sink: Bool?
    var type: Int?
}

class Video_Text: BaseModel {
}

class Cha_List: BaseModel {
}

class Statistics: BaseModel {
    var digg_count: Int?
    var aweme_id: String?
    var share_count: Int?
    var play_count: Int?
    var comment_count: Int?
}

class Descendants: BaseModel {
}

class Video_Labels: BaseModel {
}

class Status: BaseModel {
    var allow_share: Bool?
    var private_status: Int?
    var is_delete: Bool?
    var with_goods: Bool?
    var is_private: Bool?
    var with_fusion_goods: Bool?
    var allow_comment: Bool?
}

class Share_Info: BaseModel {
    var share_weibo_desc: String?
    var share_title: String?
    var share_url: String?
    var share_desc: String?
}

class Label_Top: BaseModel {
    var uri: String?
    var url_list = [String]()
}

class Text_Extra: BaseModel {
    
}
