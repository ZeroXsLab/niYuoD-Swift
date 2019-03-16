//
//  AwemeListCell.swift
//  niYuoD
//
//  Created by Xhandsome on 2019/2/27.
//  Copyright © 2019 ZeroXsLab. All rights reserved.
//

import UIKit
import AVFoundation
import SnapKit

typealias OnPlayerReady = () -> Void

class AwemeListCell: UITableViewCell, AVPlayerUpdateDelegate {
    
    var container: UIView = UIView.init()
    var pauseIcon: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_play_pause"))
    var playerStatusBar: UIView = UIView.init()
    var nickName: UILabel = UILabel.init()
    var descLabel: UILabel = UILabel.init()
    var musicIcon: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_home_musicnote3"))
    var musicName: CircleTextView = CircleTextView.init()
    var avatar: UIImageView = UIImageView.init(image: UIImage.init(named: "img_find_default"))
    var focus = FocusView.init()
    var musicAlbum: MusicAlbumView = MusicAlbumView.init()
    var comment: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_home_comment"))
    var commentNum: UILabel = UILabel.init()
    var share: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_home_share"))
    var shareNum: UILabel = UILabel.init()

    var aweme: Aweme?
    var playerView: AVPlayerView = AVPlayerView.init()
    var isPlayerReady: Bool = false
    var onPlayerReady: OnPlayerReady?
    var singleTapGesture: UITapGestureRecognizer?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.gray
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubViews() {
        playerView.delegate = self
        self.contentView.addSubview(playerView)
        self.contentView.addSubview(container)
        singleTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(singleTapAction(sender:)))
        container.addGestureRecognizer(singleTapGesture!)
        
        pauseIcon.contentMode = .center
        pauseIcon.layer.zPosition = 3
        pauseIcon.isHidden = true
        container.addSubview(pauseIcon)
        
        playerStatusBar.backgroundColor = UIColor.white
        playerStatusBar.isHidden = true
        container.addSubview(playerStatusBar)
        
        nickName.textColor = UIColor.white
        nickName.font = UIFont.boldSystemFont(ofSize: 14)
        container.addSubview(nickName)
        
        descLabel.numberOfLines = 0
        descLabel.textColor = UIColor.white
        descLabel.font = midFont
        container.addSubview(descLabel)
        
        musicIcon.contentMode = .center
        container.addSubview(musicIcon)
        
        musicName.textColor = UIColor.white
        musicName.font = midFont
        container.addSubview(musicName)
        
        let avatarRadius: CGFloat = 25
        avatar.layer.cornerRadius = avatarRadius
        avatar.layer.borderColor = UIColor.white.cgColor
        avatar.layer.borderWidth = 1
        container.addSubview(avatar)
        
        container.addSubview(focus)
        
        container.addSubview(musicAlbum)
        
        comment.contentMode = .center
        container.addSubview(comment)
        
        commentNum.textColor = UIColor.white
        commentNum.font = midFont
        commentNum.text = "0"
        container.addSubview(commentNum)
        
        share.contentMode = .center
        container.addSubview(share)
        
        shareNum.textColor = UIColor.white
        shareNum.font = midFont
        shareNum.text = "1"
        container.addSubview(shareNum)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        container.frame = self.bounds
        pauseIcon.frame = CGRect.init(x: self.bounds.midX - 50, y: self.bounds.midY - 50, width: 100, height: 100)
        
        playerStatusBar.frame = CGRect.init(x: self.bounds.midX - 0.5, y: self.bounds.maxY - 49.5, width: 1.0, height: 1)
        musicIcon.snp.makeConstraints({ make in
            make.left.equalTo(self)
            make.bottom.equalTo(self).inset(60)
            make.width.equalTo(30)
            make.height.equalTo(25)
        })
        musicName.snp.makeConstraints({ make in
            make.left.equalTo(self.musicIcon.snp.right)
            make.centerY.equalTo(self.musicIcon)
            make.width.equalTo(screenWidth / 2)
            make.height.equalTo(20)
        })
        descLabel.snp.makeConstraints({ make in
            make.bottom.equalTo(self.musicIcon.snp.top).offset(5)
            make.left.equalTo(self).inset(10)
            make.width.lessThanOrEqualTo(screenWidth / 5 * 3)
        })
        nickName.snp.makeConstraints({ make in
            make.left.equalTo(self).offset(10)
            make.bottom.equalTo(self.descLabel.snp.top).inset(-5)
            make.width.lessThanOrEqualTo(screenWidth / 4 * 3 + 30)
        })
        
        musicAlbum.snp.makeConstraints({ make in
            make.bottom.equalTo(musicName)
            make.right.equalTo(self).inset(10)
            make.width.height.equalTo(50)
        })
        share.snp.makeConstraints({ make in
            make.bottom.equalTo(self.musicAlbum.snp.top).inset(-50)
            make.right.equalTo(self).inset(10)
            make.width.equalTo(50)
            make.height.equalTo(45)
        })
        shareNum.snp.makeConstraints({ make in
            make.top.equalTo(self.share.snp.bottom)
            make.centerX.equalTo(self.share)
        })
        comment.snp.makeConstraints({ make in
            make.bottom.equalTo(self.share.snp.top).offset(-25)
            make.right.equalTo(self).inset(10)
            make.width.equalTo(50)
            make.height.equalTo(45)
        })
        commentNum.snp.makeConstraints({ make in
            make.top.equalTo(self.comment.snp.bottom)
            make.centerX.equalTo(self.comment)
        })
        let avatarRadius: CGFloat = 25
        avatar.snp.makeConstraints({ make in
            make.bottom.equalTo(self.comment.snp.top).offset(-105)
            make.right.equalTo(self).inset(10)
            make.width.height.equalTo(avatarRadius * 2)
        })
        focus.snp.makeConstraints({ make in
            make.centerX.equalTo(self.avatar)
            make.centerY.equalTo(self.avatar.snp.bottom)
            make.width.height.equalTo(24)
        })
    }
    
    func initData(aweme: Aweme) {
        self.aweme = aweme
        playerView.setPlayerSourceUrl(urlString: aweme.video?.play_addr?.url_list.first ?? "")
        nickName.text = "@" + (aweme.author?.nickname ?? "")
        descLabel.text = aweme.desc
        musicName.text = (aweme.music?.title ?? "") + "-" + (aweme.music?.author ?? "")
        commentNum.text = String.formatCount(count: aweme.statistics?.comment_count ?? 0)
        shareNum.text = String.formatCount(count: aweme.statistics?.share_count ?? 0)
        DispatchQueue.global(qos: .userInitiated).async {
            let urlContents = try? Data(contentsOf: URL.init(string: aweme.music?.cover_thumb?.url_list.first ?? "")!)
            DispatchQueue.main.async {
                let avaImage = (UIImage.init(data: urlContents!) ?? UIImage.init(named: "img_find_default"))!
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
                self.musicAlbum.album.image = outputImage
            }
        }
        DispatchQueue.global(qos: .userInitiated).async {
            let urlContents = try? Data(contentsOf: URL.init(string: aweme.author?.avatar_thumb?.url_list.first ?? "")!)
            DispatchQueue.main.async {
                let avaImage = (UIImage.init(data: urlContents!) ?? UIImage.init(named: "img_find_default"))!
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
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playerView.cancelLoading()
        descLabel.text = ""
        isPlayerReady = false
        pauseIcon.isHidden = true
        avatar.image = UIImage.init(named: "img_find_default")
        musicAlbum.resetView()
        focus.resetView()
    }
    
    func play() {
        playerView.play()
    }
    
    func pause() {
        playerView.pause()
    }
    
    func replay() {
        playerView.replay()
    }
    
    func onPlayItemStatusUpdate(status: AVPlayerItem.Status) {
        switch status {
        case .unknown:
            startLoadingPlayItemAnimation()
            break
        case .readyToPlay:
            startLoadingPlayItemAnimation(false)
            isPlayerReady = true
            musicAlbum.startAnimation(rate: CGFloat.init(aweme?.rate ?? 0))
            playerStatusBar.frame = CGRect.init(x: 0,
                                                y: self.bounds.maxY - 49.5,
                                                width: 0,
                                                height: 1)
            onPlayerReady?()
            break
        case .failed:
            startLoadingPlayItemAnimation(false)
            break
        }
    }
    
    func onProgressUpdate(current: CGFloat, total: CGFloat) {
        if isPlayerReady {
            playerStatusBar.layer.removeAllAnimations()
            playerStatusBar.isHidden = false
            playerStatusBar.frame = CGRect.init(x: 0,
                                                y: self.bounds.maxY - 49.5,
                                                width: (current - 1) / (total) * screenWidth,
                                                height: 1)
            UIView.animate(withDuration: 0.75,
                           delay: 0.0,
                           options: UIView.AnimationOptions.curveLinear,
                           animations: {
                            var frame = self.playerStatusBar.frame
                            frame.size.width = (total - current > 1.0) ? current / (total) * screenWidth : screenWidth
                            self.playerStatusBar.frame = frame
            },
                           completion: nil)
        } else {
            playerStatusBar.frame = CGRect.init(x: self.bounds.midX - 0.5, y: self.bounds.maxY - 49.5, width: 1.0, height: 1)
            playerStatusBar.isHidden = true
        }
        
    }
    
    @objc func singleTapAction(sender: UITapGestureRecognizer){
        showPauseViewAnimation(rate: playerView.rate())
        playerView.updatePlayerState()
    }
    
    func showPauseViewAnimation(rate: CGFloat) {
        if rate == 0 {
            UIView.animate(withDuration: 0.25,
                           animations: {
                            self.pauseIcon.alpha = 0.0
            },
                           completion: { finished in
                            self.pauseIcon.isHidden = true
            })
        } else {
            pauseIcon.isHidden = false
            pauseIcon.transform = CGAffineTransform.init(scaleX: 1.8, y: 1.8)
            pauseIcon.alpha = 1.0
            UIView.animate(withDuration: 0.25,
                           delay: 0.0,
                           options: .curveEaseIn,
                           animations: {
                            self.pauseIcon.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
            },
                           completion: nil)
        }
    }
    
    func startLoadingPlayItemAnimation(_ isStart: Bool = true) {
        if isStart {
            playerStatusBar.backgroundColor = UIColor.white
            playerStatusBar.isHidden = false
            playerStatusBar.layer.removeAllAnimations()
            
            let animationGroup = CAAnimationGroup.init()
            animationGroup.duration = 0.5
            animationGroup.beginTime = CACurrentMediaTime()
            animationGroup.repeatCount = .infinity
            animationGroup.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
            
            let scaleAnimation = CABasicAnimation.init()
            scaleAnimation.keyPath = "transform.scale.x"
            scaleAnimation.fromValue = 1.0
            scaleAnimation.toValue = 1.0 * screenWidth
            
            let alphaAnimation = CABasicAnimation.init()
            alphaAnimation.keyPath = "opacity"
            alphaAnimation.fromValue = 1.0
            alphaAnimation.toValue = 0.2
            
            animationGroup.animations = [scaleAnimation, alphaAnimation]
            playerStatusBar.layer.add(animationGroup, forKey: nil)
        } else {
            playerStatusBar.layer.removeAllAnimations()
            playerStatusBar.isHidden = true
        }
    }

}
