//
//  HomePageCVC.swift
//  niYuoD
//
//  Created by Xhandsome on 2019/2/14.
//  Copyright © 2019 ZeroXsLab. All rights reserved.
//

import UIKit

private let kAwemeCollectionCell = "AwemeCollectionCell"
let kHeaderId = "UserInfoHeader"
let kFooterId = "UserInfoFooter"

class HomePageCVC: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    let uid: String = "97795069353"
    var user: User?
    var pageIndex: Int = 0
    var pageSize: Int = 21
    var workAwemes = [Aweme]()
    
    var itemWidth: CGFloat = 0
    var itemHeight: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        itemWidth = (screenWidth - CGFloat(Int(screenWidth) % 3)) / 3.0 - cellGap
        itemHeight = itemWidth * 1.3
        let layout = HoverViewFlowLayout.init(naviHeight: safeAreaTopHeight)
        collectionView = UICollectionView.init(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        collectionView.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        collectionView.register(AwemeCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: kAwemeCollectionCell)
        collectionView.register(UserInfoHeader.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kHeaderId)
        collectionView.register(TabBarFooter.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: kFooterId)
        self.view.addSubview(collectionView)
        loadUserData()
        loadData(page: self.pageIndex)
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
            return workAwemes.count
        default:
            return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kAwemeCollectionCell, for: indexPath) as! AwemeCollectionViewCell
        let aweme: Aweme = workAwemes[indexPath.row]
        cell.initData(aweme: aweme)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: itemWidth, height: itemHeight)
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
                footer.setLabel(titles: ["作品 " + String(user?.aweme_count ?? 0),"LIKE"], tabIndex: 0)
                view = footer
            }
        default:
            NSLog("In viewForSupplementaryElementOfKind, with indexPath.section = \(indexPath.section)")
        }
        return view!
    }
    // UICollectionView Action
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = AwemeListTVC.init(data: workAwemes, currentIndex: indexPath.row, page: pageIndex, size: pageSize, uid: uid)
        let edgePanRecognizer: UIScreenEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgePanHandler(recognizer:)))
        edgePanRecognizer.edges = .left
        controller.view.addGestureRecognizer(edgePanRecognizer)
        self.present(controller, animated: true, completion: nil)
    }
    
    // UICollectionView FlowLayout Delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return section == 0 ? CGSize.init(width: UIScreen.main.bounds.width, height: 340 + statusBarHeight) : .zero
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
                                print("HomePage load user data: " + error.localizedDescription)
        })
    }
    
    func loadData(page: Int, _ size: Int = 21) {
        AwemeListRequest.findPostAwemesPaged(uid: uid,
                                             page: page,
                                             success: {[weak self] data in
                                                if let response = data as? AwemeListResponse {
                                                    let array = response.data
                                                    self?.pageIndex += 1
                                                    self?.collectionView.performBatchUpdates({
                                                        self?.workAwemes += array
                                                        var indexPaths = [IndexPath]()
                                                        for row in ((self?.workAwemes.count ?? 0) - array.count) ..< (self?.workAwemes.count ?? 0) {
                                                            indexPaths.append(IndexPath.init(row: row, section: 1))
                                                        }
                                                        self?.collectionView.insertItems(at: indexPaths)
                                                    }, completion: nil)
                                                }
            },
                                             failure: { error in
                                                print("HomePage load data: " + error.localizedDescription)
        })
    }

    @objc func edgePanHandler(recognizer: UIScreenEdgePanGestureRecognizer){
        switch recognizer.state {
        case .changed:
            fallthrough
        case .ended:
            let translation = recognizer.translation(in: recognizer.view?.superview)
            if translation.x > 50 {
                dismiss(animated: true, completion: nil)
            }
            break
        default:
            break
        }
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
