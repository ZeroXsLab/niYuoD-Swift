//
//  HoverViewFlowLayout.swift
//  niYuoD
//
//  Created by Xhandsome on 2019/2/15.
//  Copyright © 2019 ZeroXsLab. All rights reserved.
//

import UIKit

class HoverViewFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
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
        return superArray
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

}
