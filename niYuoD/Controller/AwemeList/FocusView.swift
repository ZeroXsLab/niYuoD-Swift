//
//  FocusView.swift
//  niYuoD
//
//  Created by Xhandsome on 2019/3/17.
//  Copyright © 2019 ZeroXsLab. All rights reserved.
//

import UIKit

class FocusView: UIImageView, CAAnimationDelegate {

    init() {
        super.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: 24, height: 24)))
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
        self.layer.cornerRadius = frame.size.width / 2
        self.layer.backgroundColor = UIColor.red.cgColor
        self.image = UIImage.init(named: "icon_personal_add_little")
        self.contentMode = .center
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(beginAnimation)))
    }
    
    @objc func beginAnimation() {
        let animationGroup = CAAnimationGroup.init()
        animationGroup.delegate = self
        animationGroup.duration = 1.25
        animationGroup.isRemovedOnCompletion = false
        animationGroup.fillMode = CAMediaTimingFillMode.forwards
        animationGroup.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        let scaleAnimation = CAKeyframeAnimation.init(keyPath: "transform.scale")
        scaleAnimation.values = [1.0, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 0.0]
        let rotationAnimation = CAKeyframeAnimation.init(keyPath: "transform.rotation")
        rotationAnimation.values = [-1.5 * .pi, 0.0, 0.0, 0.0]
        let opacityAnimation = CAKeyframeAnimation.init(keyPath: "opacity")
        opacityAnimation.values = [0.8, 1.0, 1.0]
        animationGroup.animations = [scaleAnimation, rotationAnimation, opacityAnimation]
        self.layer.add(animationGroup, forKey: nil)
    }
    
    func resetView() {
        self.layer.backgroundColor = UIColor.red.cgColor
        self.image = UIImage.init(named: "icon_personal_add_little")
        self.layer.removeAllAnimations()
        self.isHidden = false
    }
    
    func animationDidStart(_ anim: CAAnimation) {
        self.isUserInteractionEnabled = false
        self.contentMode = .scaleToFill
        self.layer.backgroundColor = UIColor.red.cgColor
        self.image = UIImage.init(named: "iconSignDone")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.isUserInteractionEnabled = true
        self.contentMode = .center
        self.isHidden = true
    }

}
