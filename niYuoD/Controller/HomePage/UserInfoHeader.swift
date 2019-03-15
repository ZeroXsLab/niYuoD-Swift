//
//  UserInfoHeader.swift
//  niYuoD
//
//  Created by Xhandsome on 2019/2/14.
//  Copyright © 2019 ZeroXsLab. All rights reserved.
//

import UIKit
import SnapKit

class UserInfoHeader: UICollectionReusableView {
    
    var container: UIView = UIView.init()
    var constellations = ["射手座","摩羯座","双鱼座","白羊座","水瓶座","金牛座","双子座","巨蟹座","狮子座","处女座","天秤座","天蝎座"]
    var avatar: UIImageView = UIImageView.init(image: UIImage.init(named: "img_find_default"))
    var avatarBackground: UIImageView = UIImageView.init()
    
    var nickName: UILabel = UILabel.init()
    var douyinNum: UILabel = UILabel.init()
    var brief: UILabel = UILabel.init()
    var genderIcon: UIImageView = UIImageView.init(image: UIImage.init(named: "iconUserProfileBoy"))
    var constellation: UITextView = UITextView.init()
    var likeNum: UILabel = UILabel.init()
    var followNum: UILabel = UILabel.init()
    var followedNum: UILabel = UILabel.init()
    
    var naviContainer: UIView = UIView.init()
    var naviLabel: UILabel = UILabel.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initAvatarBackground()
        container.frame = self.bounds
        naviContainer.frame = self.bounds
        self.addSubview(container)
        self.addSubview(naviContainer)
        naviContainer.alpha = 0
        initAvatar()
        initInfoView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initAvatarBackground() {
        avatarBackground.frame = self.bounds
        avatarBackground.clipsToBounds = true
        avatarBackground.image = UIImage.init(named: "image_find_default")
        avatarBackground.backgroundColor = UIColor.gray
        avatarBackground.contentMode = .scaleAspectFill
        self.addSubview(avatarBackground)
        let blurEffect = UIBlurEffect.init(style: UIBlurEffect.Style.dark)
        let visualEffectView = UIVisualEffectView.init(effect: blurEffect)
        visualEffectView.frame = self.bounds
        visualEffectView.alpha = 0.75
        avatarBackground.addSubview(visualEffectView)
    }
    
    func initAvatar() {
        let avatarRadius: CGFloat = 45
        avatar.isUserInteractionEnabled = true
        container.addSubview(avatar)
        let paddingLayer = CALayer.init()
        paddingLayer.frame = CGRect.init(x: 0, y: 0, width: avatarRadius * 2, height: avatarRadius * 2)
        paddingLayer.borderColor = UIColor.white.cgColor
        paddingLayer.borderWidth = 2
        paddingLayer.cornerRadius = avatarRadius
        avatar.layer.addSublayer(paddingLayer)
        avatar.snp.makeConstraints({ make in
            make.top.equalTo(self).offset( 25 + 44 + statusBarHeight)
            make.left.equalTo(self).offset(15)
            make.width.height.equalTo(avatarRadius * 2)
        })
    }
    
    func initInfoView() {
        nickName.text = "name"
        nickName.font = bigFont
        nickName.textColor = UIColor.white
        container.addSubview(nickName)
        nickName.snp.makeConstraints({ make in
            make.top.equalTo(avatar.snp.bottom).offset(20)
            make.left.equalTo(self.avatar)
            make.right.equalTo(self).inset(40)
        })
        
        naviLabel.text = "Name"
        naviLabel.textAlignment = .center
        naviLabel.font = bigFont
        naviLabel.textColor = UIColor.white
        naviContainer.addSubview(naviLabel)
        naviLabel.snp.makeConstraints({ make in
            make.bottom.equalTo(self).inset(10)
            make.left.right.equalTo(self).inset(15)
        })
        
        douyinNum.text = "Douyin Number:"
        douyinNum.font = smallFont
        douyinNum.textColor = UIColor.white
        container.addSubview(douyinNum)
        douyinNum.snp.makeConstraints({ make in
            make.top.equalTo(self.nickName.snp.bottom).offset(3)
            make.left.right.equalTo(self.nickName)
        })
        
        let splitLine = UIView.init()
        splitLine.backgroundColor = UIColor.white
        container.addSubview(splitLine)
        splitLine.snp.makeConstraints({ make in
            make.top.equalTo(self.douyinNum.snp.bottom).offset(10)
            make.left.right.equalTo(self.nickName)
            make.height.equalTo(0.5)
        })
        
        brief.text = "What brief introduction is better, I still wonder..."
        brief.textColor = UIColor.white
        brief.font = smallFont
        container.addSubview(brief)
        brief.snp.makeConstraints({ make in
            make.top.equalTo(splitLine.snp.bottom).offset(10)
            make.left.right.equalTo(self.nickName)
        })
        
        genderIcon.layer.backgroundColor = UIColor.gray.cgColor
        genderIcon.layer.cornerRadius = 9
        genderIcon.contentMode = .center
        container.addSubview(genderIcon)
        genderIcon.snp.makeConstraints({ make in
            make.left.equalTo(self.nickName)
            make.top.equalTo(self.brief.snp.bottom).offset(8)
            make.height.equalTo(18)
            make.width.equalTo(22)
        })
        
        constellation.textColor = UIColor.white
        constellation.text = "座"
        constellation.font = smallFont
        constellation.isScrollEnabled = false
        constellation.isEditable = false
        constellation.textContainerInset = UIEdgeInsets.init(top: 3, left: 6, bottom: 3, right: 6)
        constellation.textContainer.lineFragmentPadding = 0
        constellation.layer.backgroundColor = UIColor.gray.cgColor
        constellation.layer.cornerRadius = 9
        constellation.sizeToFit()
        container.addSubview(constellation)
        constellation.snp.makeConstraints({ make in
            make.left.equalTo(self.genderIcon.snp.right).offset(5)
            make.top.height.equalTo(self.genderIcon)
        })
        
        likeNum.text = "0 获赞"
        likeNum.textColor = UIColor.white
        likeNum.font = midFont
        container.addSubview(likeNum)
        likeNum.snp.makeConstraints({ make in
            make.top.equalTo(self.genderIcon.snp.bottom).offset(15)
            make.left.equalTo(self.avatar)
        })
        
        followNum.text = "0 关注"
        followNum.textColor = UIColor.white
        followNum.font = midFont
        container.addSubview(followNum)
        followNum.snp.makeConstraints({ make in
            make.top.equalTo(self.likeNum)
            make.left.equalTo(self.likeNum.snp.right).offset(30)
        })
        
        followedNum.text = "0 粉丝"
        followedNum.textColor = UIColor.white
        followedNum.font = midFont
        container.addSubview(followedNum)
        followedNum.snp.makeConstraints({ make in
            make.top.equalTo(self.likeNum)
            make.left.equalTo(self.followNum.snp.right).offset(30)
        })
    }
    
    func initData(user: User) {
        DispatchQueue.global(qos: .userInitiated).async {
            let urlContents = try? Data(contentsOf: URL.init(string: user.avatar_medium?.url_list.first ?? "")!)
            DispatchQueue.main.async {
                let avaImage = (UIImage.init(data: urlContents!) ?? UIImage.init(named: "img_find_default"))!
                self.avatarBackground.image = avaImage
                let side = min(avaImage.size.width, avaImage.size.height)
                let size = CGSize.init(width: side, height: side)
                let rect = CGRect.init(origin: CGPoint.zero, size: size)
                UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
                let context = UIGraphicsGetCurrentContext()
                context?.addPath(UIBezierPath.init(roundedRect: rect, cornerRadius: side).cgPath)
                context?.clip()
                avaImage.draw(in: rect)
                context?.drawPath(using: CGPathDrawingMode.fillStroke)
                let outputImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                self.avatar.image = outputImage
            }
        }
        nickName.text = user.nickname
        naviLabel.text = user.nickname
        douyinNum.text = "抖音号: " + (user.short_id ?? "")
        if user.signature != "" {
            brief.text = user.signature
        }
        genderIcon.image = UIImage.init(named: user.gender == 0 ? "iconUserProfileBoy" : "iconUserProfileGirl")
        constellation.text = constellations[user.constellation ?? 0]
        likeNum.text = String.init(user.total_favorited ?? 0) + " 获赞"
        followNum.text = String.init(user.following_count ?? 0) + " 关注"
        followedNum.text = String.init(user.follower_count ?? 0) + " 粉丝"
    }
    
    func overScrollAction(offsetY: CGFloat) {
        let scaleRatio: CGFloat = abs(offsetY) / 370.0
        let overScaleHeight: CGFloat = (370.0 * scaleRatio) / 2.0
        avatarBackground.transform = CGAffineTransform.init(scaleX: scaleRatio + 1.0,
                                                            y: scaleRatio + 1.0)
            .concatenating(CGAffineTransform.init(translationX: 0,
                                                  y: -overScaleHeight))
    }
    
    func scrollToTopAction(offsetY: CGFloat) {
        let alphaRatio = offsetY / (370.0 - 44.0 - statusBarHeight)
        container.alpha = 1.0 - alphaRatio
        naviContainer.alpha = alphaRatio - 0.5
    }
    
}
