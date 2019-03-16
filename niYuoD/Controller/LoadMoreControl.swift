//
//  LoadMoreControl.swift
//  niYuoD
//
//  Created by Xhandsome on 2019/3/15.
//  Copyright © 2019 ZeroXsLab. All rights reserved.
//

import Foundation
import UIKit

typealias OnLoad = () -> Void

class LoadMoreControl: UIControl {
    
    var indicator: UIImageView = UIImageView.init(image: UIImage.init(named: "icon30WhiteSmall"))
    var label: UILabel = UILabel.init()
    
    var surplusCount: Int = 0
    var originalFrame: CGRect = .zero
    var superView: UIScrollView?
    var edgeInsets: UIEdgeInsets?
    
    private var _onLoad: OnLoad?
    var onLoad: OnLoad? {
        set {
            _onLoad = newValue
        }
        get {
            return _onLoad
        }
    }
    
    private var _loadingType: LoadingType = .LoadStateIdle
    var loadingType: LoadingType {
        set {
            _loadingType = newValue
            label.snp.removeConstraints()
            switch newValue {
            case .LoadStateIdle:
                self.isHidden = true
                break
            case .LoadStateLoading:
                self.isHidden = false
                indicator.isHidden = false
                label.text = "Loading..."
                label.snp.makeConstraints({ make in
                    make.centerX.equalTo(self).offset(20)
                    make.centerY.equalTo(self)
                })
                indicator.snp.makeConstraints({ make in
                    make.centerY.equalTo(self)
                    make.right.equalTo(self.label.snp.left).inset(-5)
                    make.width.height.equalTo(15)
                })
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
                    self.startAnimation()
                })
                break
            case .LoadStateAll:
                self.isHidden = false
                indicator.isHidden = true
                label.text = "All Loaded"
                label.snp.makeConstraints({ make in
                    make.center.equalTo(self)
                })
                stopAnimation()
                updateFrame()
                break
            case .LoadStateFailed:
                self.isHidden = false
                indicator.isHidden = true
                label.text = "Load More"
                label.snp.makeConstraints({ make in
                    make.center.equalTo(self)
                })
                stopAnimation()
                break
            }
        }
        
        get {
            return _loadingType
        }
    }
    
    init(frame: CGRect, surplusCount: Int){
        super.init(frame: frame)
        self.surplusCount = surplusCount
        self.originalFrame = frame
        initSubView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.originalFrame = frame
        initSubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubView() {
        self.layer.zPosition = -1
        indicator.isHidden = true
        self.addSubview(indicator)
        
        label.text = "Loading..."
        label.textColor = UIColor.gray
        label.font = midFont
        label.textAlignment = .center
        self.addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        superView = self.superview as? UIScrollView
        if edgeInsets == nil {
            edgeInsets = self.superView?.contentInset
            edgeInsets?.bottom += 50
            self.superView?.contentInset = edgeInsets ?? .zero
            superView?.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            DispatchQueue.main.async {
                if (self.superView?.isKind(of: UICollectionView.classForCoder()))! {
                    if let collectionView = self.superView as? UICollectionView {
                        let lastSection = collectionView.numberOfSections - 1
                        if lastSection >= 0 {
                            let lastRow = collectionView.numberOfItems(inSection: lastSection) - 1
                            if lastRow >= 0 {
                                if collectionView.visibleCells.count > 0 {
                                    let indexPaths = collectionView.indexPathsForVisibleItems
                                    let orderedIndexPaths = indexPaths.sorted(by: {$0.row < $1.row})
                                    if let indexPath = orderedIndexPaths.last {
                                        if indexPath.section == lastSection && indexPath.row >= lastRow - self.surplusCount {
                                            if self.loadingType == .LoadStateIdle || self.loadingType == .LoadStateFailed {
                                                self.startLoading()
                                                self.onLoad?()
                                            }
                                        }
                                        if indexPath.section == lastSection && indexPath.row == lastRow {
                                            if let cell = collectionView.cellForItem(at: indexPath) {
                                                self.frame = CGRect.init(x: 0, y: cell.frame.maxY, width: screenWidth, height: 50)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    func reset() {
        loadingType = .LoadStateIdle
        self.frame = originalFrame
    }
    
    func startLoading() {
        if loadingType != .LoadStateLoading {
            loadingType = .LoadStateLoading
        }
    }
    
    func endLoading() {
        if loadingType != .LoadStateIdle {
            loadingType = .LoadStateIdle
        }
    }
    
    func loadingFailed() {
        if loadingType != .LoadStateFailed {
            loadingType = .LoadStateFailed
        }
    }
    
    func loadingAll() {
        if loadingType != .LoadStateAll {
            loadingType = .LoadStateAll
        }
    }
    
    func updateFrame() {
        if (superView?.isKind(of: UICollectionView.classForCoder()))! {
            if let collectionView = superView as? UICollectionView {
                let y: CGFloat = collectionView.contentSize.height > originalFrame.origin.y ? collectionView.contentSize.height : originalFrame.origin.y
                self.frame = CGRect.init(x: 0, y: y, width: screenWidth, height: 50)
            }
        }
    }
    
    func startAnimation() {
        let rotationAnimation = CABasicAnimation.init(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber.init(value: .pi * 2.0)
        rotationAnimation.duration = 1.5
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = MAXFLOAT
        indicator.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    func stopAnimation() {
        indicator.layer.removeAllAnimations()
    }
    
    deinit {
        superView?.removeObserver(self, forKeyPath: "contentOffset")
    }
    
}
