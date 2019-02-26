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
            label.textAlignment = .center
            label.backgroundColor = UIColor.gray
            label.frame = CGRect(x: CGFloat(index) * labelWidth,
                                 y: 0,
                                 width: labelWidth,
                                 height: self.bounds.size.height)
            labels.append(label)
            self.addSubview(label)
        }
        tabBarView = UIView.init(frame: CGRect(x: CGFloat(tabIndex) * labelWidth,
                                               y: self.bounds.size.height - 2,
                                               width: labelWidth - 30,
                                               height: 2))
        self.addSubview(tabBarView)
    }
    
}
