//
//  MusicAlbumView.swift
//  niYuoD
//
//  Created by Xhandsome on 2019/3/17.
//  Copyright © 2019 ZeroXsLab. All rights reserved.
//

import UIKit

class MusicAlbumView: UIView {

    var album: UIImageView = UIImageView.init()
    var albumContainer: UIView = UIView.init()
    var noteLayers = [CALayer]()
    
    init() {
        super.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: 50, height: 50)))
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
        albumContainer.frame = self.bounds
        self.addSubview(albumContainer)
        
        let backgroundLayer = CALayer.init()
        backgroundLayer.frame = self.bounds
        backgroundLayer.contents = UIImage.init(named: "music_cover")?.cgImage
        albumContainer.layer.addSublayer(backgroundLayer)
        
        album.frame = CGRect.init(x: 15, y: 15, width: 20, height: 20)
        album.contentMode = .scaleAspectFill
        albumContainer.addSubview(album)
    }
    
    func startAnimation(rate: CGFloat) {
        let r = rate <= 0 ? 15 : rate
        resetView()
        initMusicNotoAnimation(imageName: "icon_home_musicnote1", delayTime: 0.0, rate: r)
        initMusicNotoAnimation(imageName: "icon_home_musicnote2", delayTime: 1.0, rate: r)
        initMusicNotoAnimation(imageName: "icon_home_musicnote1", delayTime: 2.0, rate: r)
        
        let rotationAnimation = CABasicAnimation.init(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = CGFloat.pi * 2.0
        rotationAnimation.duration = 3.0
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = MAXFLOAT
        albumContainer.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    func initMusicNotoAnimation(imageName: String, delayTime: TimeInterval, rate: CGFloat){
        let animationGroup = CAAnimationGroup.init()
        animationGroup.duration = CFTimeInterval.init(rate / 4.0)
        animationGroup.beginTime = CACurrentMediaTime() + delayTime
        animationGroup.repeatCount = .infinity
        animationGroup.isRemovedOnCompletion = false
        animationGroup.fillMode = CAMediaTimingFillMode.forwards
        animationGroup.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.linear)
        
        let pathAnimation = CAKeyframeAnimation.init(keyPath: "position")
        let sideXLength: CGFloat = 40.0
        let sideYLength: CGFloat = 100.0
        let beginPoint = CGPoint.init(x: self.bounds.midX, y: self.bounds.maxY)
        let endPoint = CGPoint.init(x: beginPoint.x - sideXLength, y: beginPoint.y - sideYLength)
        let controlLength: CGFloat = 60
        let controlPoint = CGPoint.init(x: beginPoint.x - sideXLength/2 - controlLength, y: beginPoint.y - sideYLength/2 + controlLength)
        let customPath = UIBezierPath.init()
        customPath.move(to: beginPoint)
        customPath.addQuadCurve(to: endPoint, controlPoint: controlPoint)
        pathAnimation.path = customPath.cgPath
        
        let rotationAnimation = CAKeyframeAnimation.init(keyPath: "transform.rotation")
        rotationAnimation.values = [0.0, .pi * 0.1, .pi * -0.1]
        let opacityAnimation = CAKeyframeAnimation.init(keyPath: "opacity")
        opacityAnimation.values = [0.0, 0.2, 0.7, 0.2, 0.0]
        let scaleAnimation = CABasicAnimation.init()
        scaleAnimation.keyPath = "transform.scale"
        scaleAnimation.fromValue = 1.0
        scaleAnimation.toValue = 2.0
        
        animationGroup.animations = [pathAnimation, rotationAnimation, opacityAnimation, scaleAnimation]
        let layer = CAShapeLayer.init()
        layer.opacity = 0.0
        layer.contents = UIImage.init(named: imageName)?.cgImage
        layer.frame = CGRect.init(origin: beginPoint, size: CGSize.init(width: 10, height: 10))
        self.layer.addSublayer(layer)
        noteLayers.append(layer)
        layer.add(animationGroup, forKey: nil)
    }
    
    func resetView() {
        for subLayer in noteLayers {
            subLayer.removeFromSuperlayer()
        }
        self.layer.removeAllAnimations()
    }

}
