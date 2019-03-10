//
//  AwemeCollectionViewCell.swift
//  niYuoD
//
//  Created by Xhandsome on 2019/2/26.
//  Copyright © 2019 ZeroXsLab. All rights reserved.
//

import UIKit

class AwemeCollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView = UIImageView.init()
    var favoriteNum: UIButton = UIButton.init()
    var url: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.backgroundColor = UIColor.lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true // cut the imageView to suit the cell prevent it from overflow it.
        self.addSubview(imageView)
        
        favoriteNum.contentHorizontalAlignment = .left
        favoriteNum.setTitle("0", for: UIControl.State.normal)
        favoriteNum.setTitleColor(UIColor.white, for: UIControl.State.normal)
        self.addSubview(favoriteNum)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds
        favoriteNum.frame = CGRect.init(x: 10, y: self.bounds.size.height - 20, width: self.bounds.size.width - 20, height: 12)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func initData(aweme: Aweme){
        fetchImage(urlString: aweme.video?.cover?.url_list.first ?? "")
//        favoriteNum.setTitle(String(aweme.statistics?.digg_count ?? 0), for: UIControl.State.normal)
        favoriteNum.setTitle(String.formatCount(count: aweme.statistics?.digg_count ?? 0), for: UIControl.State.normal)
    }
    
    func fetchImage(urlString: String){
        url = urlString
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
            let urlContents = try? Data(contentsOf: URL(string: urlString)!)
            DispatchQueue.main.async {
                if let imageData = urlContents {
                    self.imageView.image = UIImage(data: imageData)
                }
            }
        }
    }
    
}

extension String {
    static func format(decimal: Float, _ maximumDigits: Int = 1, _ minimumDigits: Int = 1) -> String? {
        let number = NSNumber(value: decimal)
        let numberFormatter = NumberFormatter.init()
        numberFormatter.maximumFractionDigits = maximumDigits
        numberFormatter.minimumFractionDigits = minimumDigits
        return numberFormatter.string(from: number)
    }
    
    static func formatCount(count: Int) -> String{
        if count < 10000 {
            return String(count)
        } else {
            return (String.format(decimal: (Float(count) / 10000.0)) ?? "0") + "w"
        }
    }
}
