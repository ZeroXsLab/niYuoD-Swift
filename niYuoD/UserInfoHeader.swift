//
//  UserInfoHeader.swift
//  niYuoD
//
//  Created by Xhandsome on 2019/2/14.
//  Copyright © 2019 ZeroXsLab. All rights reserved.
//

import UIKit

class UserInfoHeader: UICollectionReusableView {
    
    var nameLabel: UILabel = UILabel.init()
    var labelWidth: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initData(user: User) {
        labelWidth = UIScreen.main.bounds.width
        nameLabel.text = (user.nickname ?? "") + " Douyin: " + (user.short_id ?? "")
        nameLabel.textAlignment = .center
        nameLabel.frame = CGRect(x: 0,
                                 y: 0,
                                 width: labelWidth,
                                 height: self.bounds.size.height)
        self.addSubview(nameLabel)
    }
    
}
