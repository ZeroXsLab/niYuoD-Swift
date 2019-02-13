//
//  HomePageCVC.swift
//  niYuoD
//
//  Created by Xhandsome on 2019/2/14.
//  Copyright © 2019 ZeroXsLab. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ReuseCell"
let kHeaderId = "UserInfoHeader"
let kFooterId = "UserInfoFooter"

class HomePageCVC: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.register(TabBarFooter.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: kFooterId)
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        switch section {
        case 0:
            return 0
        case 1:
            return 48
        default:
            return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        let label = UILabel.init()
        label.frame = CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height)
        label.backgroundColor = UIColor.gray
        label.text = "\(indexPath)"
        cell.addSubview(label)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // FIXME: hide header and footer in section 1 without taking area
        var view: UICollectionReusableView? = nil
        switch indexPath.section {
        case 0:
            // in the UserInfo Section
            if kind == UICollectionView.elementKindSectionHeader {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                             withReuseIdentifier: kHeaderId,
                                                                             for: indexPath)
                let label = UILabel.init()
                label.backgroundColor = UIColor.gray
                label.text = "\(indexPath)"
                header.frame.size = CGSize(width: 20, height: 20)
                header.addSubview(label)
                header.isHidden = false
                view = header
            } else {
                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                                                             withReuseIdentifier: kFooterId,
                                                                             for: indexPath) as! TabBarFooter
                footer.setLabel(titles: ["Tab One",String.init(format: "\(arc4random())")], tabIndex: 2)
                footer.isHidden = false
                view = footer
            }
        default:
            NSLog("In viewForSupplementaryElementOfKind, with indexPath.section = \(indexPath.section)")
            if kind == UICollectionView.elementKindSectionHeader {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                             withReuseIdentifier: kHeaderId,
                                                                             for: indexPath)
                header.backgroundColor = UIColor.black
                header.frame.size = CGSize(width: 0, height: 0)
                header.isHidden = true
                view = header
            } else {
                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                                                             withReuseIdentifier: kFooterId,
                                                                             for: indexPath)
                footer.backgroundColor = UIColor.red
                footer.frame.size = CGSize(width: 0, height: 0)
                footer.isHidden = true
                view = footer
            }
        }
        return view!
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
