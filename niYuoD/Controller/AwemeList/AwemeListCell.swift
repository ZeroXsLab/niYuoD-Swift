//
//  AwemeListCell.swift
//  niYuoD
//
//  Created by Xhandsome on 2019/2/27.
//  Copyright © 2019 ZeroXsLab. All rights reserved.
//

import UIKit

class AwemeListCell: UITableViewCell {
    
    var label: UILabel = UILabel.init()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setLabel(labelText: String) {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        label.text = labelText
        label.backgroundColor = UIColor.gray
        self.addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect.init(x: 0, y: 0, width: screenWidth - 5.0, height: self.bounds.height - 5.0)
    }

}
