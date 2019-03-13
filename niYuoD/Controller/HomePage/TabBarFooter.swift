//
//  TabBarFooter.swift
//  niYuoD
//
//  Created by Xhandsome on 2019/2/14.
//  Copyright © 2019 ZeroXsLab. All rights reserved.
//

import UIKit

class TabBarFooter: UICollectionReusableView {
    
    var tabBarView: UIView = UIView.init()
    var labels: [UILabel] = [UILabel]()
    var labelWidth: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.darkGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLabel(titles: [String], tabIndex: Int) {
        for subView in self.subviews {
            subView.removeFromSuperview()
        }
        labels.removeAll()
        // Clear All
        labelWidth = screenWidth / CGFloat(titles.count)
        for index in titles.indices {
            let title = titles[index]
            let label = UILabel.init()
            label.text = title
            label.textColor = UIColor.gray
            label.textAlignment = .center
            label.frame = CGRect(x: CGFloat(index) * labelWidth,
                                 y: 0,
                                 width: labelWidth,
                                 height: self.bounds.size.height)
            labels.append(label)
            self.addSubview(label)
            if index != titles.count - 1 {
                let spliteLine = UIView.init(frame: CGRect.init(x: CGFloat(index + 1) * labelWidth - 0.25,
                                                                y: 12.5,
                                                                width: 0.5,
                                                                height: self.bounds.size.height - 25.0))
                spliteLine.backgroundColor = UIColor.white
                spliteLine.layer.zPosition = 10
                self.addSubview(spliteLine)
            }
        }
        labels[tabIndex].textColor = UIColor.white
        tabBarView = UIView.init(frame: CGRect(x: CGFloat(tabIndex) * labelWidth,
                                               y: self.bounds.size.height - 2,
                                               width: labelWidth - 30,
                                               height: 2))
        self.addSubview(tabBarView)
    }
    
}
