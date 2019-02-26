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

class HomePageCVC: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    let uid: String = "97795069353"
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = HoverViewFlowLayout.init()
        collectionView = UICollectionView.init(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(UserInfoHeader.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kHeaderId)
        collectionView.register(TabBarFooter.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: kFooterId)
        self.view.addSubview(collectionView)
        loadUserData()
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
            return 90
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
        
        var view: UICollectionReusableView? = nil
        switch indexPath.section {
        case 0:
            // in the UserInfo Section
            if kind == UICollectionView.elementKindSectionHeader {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                             withReuseIdentifier: kHeaderId,
                                                                             for: indexPath) as! UserInfoHeader
                if let data = user {
                    header.initData(user: data)
                }
                view = header
            } else {
                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                                                             withReuseIdentifier: kFooterId,
                                                                             for: indexPath) as! TabBarFooter
                footer.setLabel(titles: ["Aweme " + String(user?.aweme_count ?? 0),String.init(format: "\(arc4random())")], tabIndex: 2)
                view = footer
            }
        default:
            NSLog("In viewForSupplementaryElementOfKind, with indexPath.section = \(indexPath.section)")
        }
        return view!
    }
    
    // UICollectionView FlowLayout Delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return section == 0 ? CGSize.init(width: UIScreen.main.bounds.width, height: 20) : .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return section == 0 ? CGSize.init(width: UIScreen.main.bounds.width, height: 40) : .zero
    }
    
    func loadUserData() {
        UserRequest.findUser(uid: uid,
                             success: { [weak self] data in
            self?.user = data as? User
                                print("load data successfully!" + (self?.user?.nickname ?? "no value yet..."))
                                self?.collectionView.reloadSections(IndexSet.init(integer: 0))
        },
                             failure: { error in
            print(error.localizedDescription)
        })
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
