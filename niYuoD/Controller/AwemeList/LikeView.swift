//
//  FavoriteView.swift
//  niYuoD
//
//  Created by Xhandsome on 2019/3/17.
//  Copyright © 2019 ZeroXsLab. All rights reserved.
//

import UIKit

let LikeBeforeTapAction: Int = 1000
let LikeAfterTapAction: Int = 2000

class LikeView: UIView {

    var likeBefore: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_home_like_before"))
    var likeAfter: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_home_like_after"))
    
    init() {
        super.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: 50, height: 45)))
        initSubView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubView() {
        likeBefore.frame = self.frame
        likeBefore.contentMode = .center
        likeBefore.isUserInteractionEnabled = true
        likeBefore.tag = LikeBeforeTapAction
        likeBefore.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleGesture(sender:))))
        self.addSubview(likeBefore)
        
        likeAfter.frame = self.frame
        likeAfter.contentMode = .center
        likeAfter.isUserInteractionEnabled = true
        likeAfter.tag = LikeAfterTapAction
        likeAfter.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleGesture(sender:))))
        likeAfter.isHidden = true
        self.addSubview(likeAfter)
    }
    
    func startLikeAnimation(isLike: Bool) {
        likeBefore.isUserInteractionEnabled = false
        likeAfter.isUserInteractionEnabled = false
        if isLike {
            let length: CGFloat = 30
            let duration: CGFloat = 0.5
            for index in 0 ..< 6 {
                let layer = CAShapeLayer.init()
                layer.position = likeBefore.center
                layer.fillColor = UIColor.red.cgColor
                
                let startPath = UIBezierPath.init()
                startPath.move(to: CGPoint.init(x: -2, y: -length))
                startPath.addLine(to: CGPoint.init(x: 2, y: -length))
                startPath.addLine(to: CGPoint.zero)
                let endPath = UIBezierPath.init()
                endPath.move(to: CGPoint.init(x: -2, y: -length))
                endPath.addLine(to: CGPoint.init(x: 2, y: -length))
                endPath.addLine(to: CGPoint.init(x: 0, y: -length))
                layer.path = startPath.cgPath
                layer.transform = CATransform3DMakeRotation(CGFloat.pi / 3.0 * CGFloat.init(index), 0.0, 0.0, 1.0)
                self.layer.addSublayer(layer)
                
                let group = CAAnimationGroup.init()
                group.isRemovedOnCompletion = false
                group.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
                group.fillMode = CAMediaTimingFillMode.forwards
                group.duration = CFTimeInterval.init(duration)
                
                let scaleAnimation = CABasicAnimation.init(keyPath: "transform.scale")
                scaleAnimation.fromValue = 0.0
                scaleAnimation.toValue = 1.0
                scaleAnimation.duration = CFTimeInterval.init(duration * 0.2)
                let pathAnimation = CABasicAnimation.init(keyPath: "path")
                pathAnimation.fromValue = layer.path
                pathAnimation.toValue = endPath.cgPath
                pathAnimation.beginTime = CFTimeInterval.init(duration * 0.2)
                pathAnimation.duration = CFTimeInterval.init(duration * 0.8)
                group.animations = [scaleAnimation, pathAnimation]
                layer.add(group, forKey: nil)
            }
            likeAfter.isHidden = false
            likeAfter.alpha = 0.0
            likeAfter.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5).concatenating(CGAffineTransform.init(rotationAngle: CGFloat.pi / 3 * 2))
            UIView.animate(withDuration: 0.4,
                           delay: 0.2,
                           usingSpringWithDamping: 0.6,
                           initialSpringVelocity: 0.8,
                           options: UIView.AnimationOptions.curveEaseIn,
                           animations: {
                            self.likeBefore.alpha = 0.0
                            self.likeAfter.alpha = 1.0
                            self.likeAfter.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0).concatenating(CGAffineTransform.init(rotationAngle: 0))
            },
                           completion: { finished in
                            self.likeBefore.alpha = 1.0
                            self.likeBefore.isUserInteractionEnabled = true
                            self.likeAfter.isUserInteractionEnabled = true
            })
        } else {
            likeAfter.alpha = 1.0
            likeAfter.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0).concatenating(CGAffineTransform.init(rotationAngle: 0))
            UIView.animate(withDuration: 0.35,
                           delay: 0.0,
                           options: UIView.AnimationOptions.curveEaseIn,
                           animations: {
                            self.likeAfter.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1).concatenating(CGAffineTransform.init(rotationAngle: CGFloat.pi / 4))
            },
                           completion: {finished in
                            self.likeAfter.isHidden = true
                            self.likeBefore.isUserInteractionEnabled = true
                            self.likeAfter.isUserInteractionEnabled = true
            })
        }
    }
    
    func resetView() {
        likeBefore.isHidden = false
        likeAfter.isHidden = true
        self.layer.removeAllAnimations()
    }
    
    @objc func handleGesture(sender: UITapGestureRecognizer) {
        switch sender.view?.tag {
        case LikeBeforeTapAction:
            startLikeAnimation(isLike: true)
            break
        case LikeAfterTapAction:
            startLikeAnimation(isLike: false)
            break
        default:
            break
        }
    }

}
