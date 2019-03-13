//
//  HoverViewFlowLayout.swift
//  niYuoD
//
//  Created by Xhandsome on 2019/2/15.
//  Copyright © 2019 ZeroXsLab. All rights reserved.
//

import UIKit

class HoverViewFlowLayout: UICollectionViewFlowLayout {
    
    var naviHeight: CGFloat = 0
    
    init(naviHeight: CGFloat) {
        super.init()
        self.naviHeight = naviHeight
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var superArray: [UICollectionViewLayoutAttributes] = super.layoutAttributesForElements(in: rect)!
        
        //Remove all header and footer and add it after that
        let copyArray = superArray
        for index in copyArray.indices {
            let attributes = copyArray[index]
            if attributes.representedElementKind == UICollectionView.elementKindSectionHeader
                || attributes.representedElementKind == UICollectionView.elementKindSectionFooter {
                if let tempIndex = superArray.firstIndex(of: attributes) {
                    superArray.remove(at: tempIndex)
                }
            }
        }
        if let header = super.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                   at: IndexPath.init(item: 0, section: 0)){
            superArray.append(header)
        }
        if let footer = super.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                                                   at: IndexPath.init(item: 0, section: 0)){
            superArray.append(footer)
        }
        for attributes in superArray {
            if attributes.indexPath.section == 0 {
                if attributes.representedElementKind == UICollectionView.elementKindSectionHeader {
                    var rect = attributes.frame
                    if (self.collectionView?.contentOffset.y)! + self.naviHeight - rect.size.height > rect.origin.y {
                        rect.origin.y = (self.collectionView?.contentOffset.y)! + self.naviHeight - rect.size.height
                        attributes.frame = rect
                    }
                    attributes.zIndex = 5
                }
                if attributes.representedElementKind == UICollectionView.elementKindSectionFooter {
                    var rect = attributes.frame
                    if (self.collectionView?.contentOffset.y)! + self.naviHeight > rect.origin.y {
                        rect.origin.y = (self.collectionView?.contentOffset.y)! + self.naviHeight
                        attributes.frame = rect
                    }
                    attributes.zIndex = 10
                }
            }
        }
        return superArray
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

}
