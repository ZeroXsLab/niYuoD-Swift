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
    
    var userInfooHeader: UserInfoHeader?
    var loadMore: LoadMoreControl?

    override func viewDidLoad() {
        super.viewDidLoad()
        itemWidth = (screenWidth - CGFloat(Int(screenWidth) % 3)) / 3.0 - cellGap
        itemHeight = itemWidth * 1.3
        let layout = HoverViewFlowLayout.init(naviHeight: safeAreaTopHeight)
        collectionView = UICollectionView.init(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        collectionView.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        collectionView.register(AwemeCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: kAwemeCollectionCell)
        collectionView.register(UserInfoHeader.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kHeaderId)
        collectionView.register(TabBarFooter.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: kFooterId)
        self.view.addSubview(collectionView)
        loadMore = LoadMoreControl.init(frame: CGRect.init(x: 0, y: 380 + statusBarHeight, width: screenWidth, height: 50), surplusCount: 15)
        loadMore?.startLoading()
        loadMore?.onLoad = {[weak self] in
            self?.loadData(page: self?.pageIndex ?? 0)
        }
        collectionView.addSubview(loadMore!)
        loadUserData()
        loadData(page: self.pageIndex)
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

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
                userInfooHeader = header
                if let data = user {
                    header.initData(user: data)
                }
                view = header
            } else {
                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                                                             withReuseIdentifier: kFooterId,
                                                                             for: indexPath) as! TabBarFooter
                footer.setLabel(titles: ["作品 " + String(user?.aweme_count ?? 0),"LIKE " + String(user?.favoriting_count ?? 0)], tabIndex: 0)
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
                                                    UIView.setAnimationsEnabled(false)
                                                    self?.collectionView.performBatchUpdates({
                                                        self?.workAwemes += array
                                                        var indexPaths = [IndexPath]()
                                                        for row in ((self?.workAwemes.count ?? 0) - array.count) ..< (self?.workAwemes.count ?? 0) {
                                                            indexPaths.append(IndexPath.init(row: row, section: 1))
                                                        }
                                                        self?.collectionView.insertItems(at: indexPaths)
                                                    }, completion: {finished in
                                                        UIView.setAnimationsEnabled(true)
                                                        self?.loadMore?.endLoading()
                                                        if response.has_more == 0 {
                                                            self?.loadMore?.loadingAll()
                                                        }
                                                    })
                                                }
            },
                                             failure: { error in
                                                self.loadMore?.loadingFailed()
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
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY < 0 {
            userInfooHeader?.overScrollAction(offsetY: offsetY)
        } else {
            userInfooHeader?.scrollToTopAction(offsetY: offsetY)
        }
    }

}
