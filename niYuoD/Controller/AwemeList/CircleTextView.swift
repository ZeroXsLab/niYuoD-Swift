//
//  CircleTextView.swift
//  niYuoD
//
//  Created by Xhandsome on 2019/3/17.
//  Copyright © 2019 ZeroXsLab. All rights reserved.
//

import Foundation
import UIKit

let SeparateText: String = "   "

class CircleTextView: UIView {
    
    var _font: UIFont = midFont
    var font: UIFont {
        set {
            _font = newValue
            let size = text.singleLineSizeWithAttributeText(font: newValue)
            textWidth = size.width
            textHeight = size.height
            textLayerFrame = CGRect.init(origin: .zero, size: CGSize.init(width: textWidth * 3 + textSeparateWidth * 2, height: textHeight))
            translateionX = textWidth + textSeparateWidth
            drawTextLayer()
            startAnimation()
        }
        get {
            return _font
        }
    }
    
    var _text: String = ""
    var text: String {
        set{
            _text = newValue
            let size = newValue.singleLineSizeWithAttributeText(font: font)
            textWidth = size.width
            textHeight = size.height
            textLayerFrame = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: textWidth * 3 + textSeparateWidth * 2, height: textHeight))
            translateionX = textWidth + textSeparateWidth
            drawTextLayer()
            startAnimation()
        }
        get {
            return _text
        }
    }
    
    var _textColor: UIColor = UIColor.white
    var textColor: UIColor {
        set {
            _textColor = newValue
            textLayer.foregroundColor = newValue.cgColor
        }
        get {
            return _textColor
        }
    }
    
    var textLayer = CATextLayer.init()
    var maskLayer = CAShapeLayer.init()
    var textSeparateWidth: CGFloat = 0
    var textWidth: CGFloat = 0
    var textHeight: CGFloat = 0
    var textLayerFrame: CGRect = .zero
    var translateionX: CGFloat = 0
    
    init() {
        super.init(frame: .zero)
        initSubLayer()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubLayer() {
        textSeparateWidth = SeparateText.singleLineSizeWithAttributeText(font: font).width
        textLayer.alignmentMode = CATextLayerAlignmentMode.natural
        textLayer.truncationMode = CATextLayerTruncationMode.none
        textLayer.isWrapped = false
        textLayer.contentsScale = UIScreen.main.scale
        self.layer.addSublayer(textLayer)
        self.layer.mask = maskLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        textLayer.frame = CGRect.init(origin: CGPoint.init(x: 0, y: (self.bounds.height - textLayerFrame.height) / 2), size: textLayerFrame.size)
        maskLayer.frame = self.bounds
        maskLayer.path = UIBezierPath.init(rect: self.bounds).cgPath
        CATransaction.commit()
    }
    
    func drawTextLayer() {
        textLayer.foregroundColor = textColor.cgColor
        textLayer.font = font
        textLayer.fontSize = font.pointSize
        textLayer.string = text + SeparateText + text + SeparateText + text
    }
    
    func startAnimation() {
        let animation = CABasicAnimation.init()
        animation.keyPath = "transform.translation.x"
        animation.fromValue = self.bounds.origin.x
        animation.toValue = self.bounds.origin.x - translateionX
        animation.duration = CFTimeInterval.init(textWidth * 0.035)
        animation.repeatCount = MAXFLOAT
        animation.isRemovedOnCompletion = false
        
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.linear)
        textLayer.add(animation, forKey: nil)
    }
    
}

extension String {
    func singleLineSizeWithAttributeText(font: UIFont) -> CGSize {
        let attributes = [NSAttributedString.Key.font:font]
        let attString = NSAttributedString.init(string: self, attributes: attributes)
        let framesetter = CTFramesetterCreateWithAttributedString(attString)
        return CTFramesetterSuggestFrameSizeWithConstraints(framesetter,
                                                            CFRange.init(location: 0, length: 0),
                                                            nil,
                                                            CGSize.init(width: Double.greatestFiniteMagnitude, height: Double.greatestFiniteMagnitude),
                                                            nil)
    }
}
