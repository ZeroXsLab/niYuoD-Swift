//
//  AwemeListTVC.swift
//  niYuoD
//
//  Created by Xhandsome on 2019/2/27.
//  Copyright © 2019 ZeroXsLab. All rights reserved.
//

import UIKit

let kAwemeCell: String = "AwemeListCell"

class AwemeListTVC: UITableViewController {
    
    @objc dynamic var currentIndex: Int = 0
    var pageIndex: Int = 0
    var pageSize: Int = 21
    var uid: String?
    var awemes = [Aweme]()
    var data = [Aweme]()
    
    var isCurPlayerPause: Bool = false
    
    init(data: [Aweme], currentIndex: Int, page: Int, size: Int, uid: String){
        super.init(nibName: nil, bundle: nil)
        self.currentIndex = currentIndex
        self.pageIndex = page
        self.pageSize = size
        self.uid = uid
        self.awemes = data
        self.data.append(data[currentIndex])
        NotificationCenter.default.addObserver(self, selector: #selector(applicationBecomeActive), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AwemeListCell.classForCoder(), forCellReuseIdentifier: kAwemeCell)
        loadData(page: pageIndex)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1,
                                      execute: {
                                        self.data = self.awemes
                                        self.tableView.reloadData()
                                        let currentIndexPath = IndexPath.init(row: self.currentIndex, section: 0)
                                        self.tableView.scrollToRow(at: currentIndexPath, at: UITableView.ScrollPosition.middle, animated: false)
                                        self.addObserver(self, forKeyPath: "currentIndex", options: [.initial, .new], context: nil)
        })
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let cells = self.tableView.visibleCells as! [AwemeListCell]
        for cell in cells {
            cell.playerView.cancelLoading()
        }
        NotificationCenter.default.removeObserver(self)
        self.removeObserver(self, forKeyPath: "currentIndex")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kAwemeCell, for: indexPath) as! AwemeListCell
        cell.initData(aweme: data[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenHeight
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        DispatchQueue.main.async {
            let translatedPoint = scrollView.panGestureRecognizer.translation(in: scrollView)
            scrollView.panGestureRecognizer.isEnabled = false
            if translatedPoint.y < -50 && self.currentIndex < self.data.count - 1 {
                self.currentIndex += 1
            }
            if translatedPoint.y > 50 && self.currentIndex > 0{
                self.currentIndex -= 1
            }
            UIView.animate(withDuration: 0.15,
                           delay: 0.0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 5.0,
                           options: UIView.AnimationOptions.curveEaseOut,
                           animations: {
                            self.tableView.scrollToRow(at: IndexPath.init(row: self.currentIndex, section: 0),
                                                       at: UITableView.ScrollPosition.top,
                                                       animated: false)
            },
                           completion: { finished in
                            scrollView.panGestureRecognizer.isEnabled = true
            })
        }
    }
    
    override func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        currentIndex = 0
    }
    
    func loadData(page: Int, _ size: Int = 21){
        AwemeListRequest.findPostAwemesPaged(uid: uid ?? "",
                                             page: page,
                                             size,
                                             success: {[weak self] data in
                                                if let response = data as? AwemeListResponse {
                                                    let dataArray = response.data
                                                    self?.pageIndex += 1
                                                    self?.tableView.beginUpdates()
                                                    self?.data += dataArray
                                                    var indexPaths = [IndexPath]()
                                                    for row in ((self?.data.count ?? 0) - dataArray.count) ..< (self?.data.count ?? 0) {
                                                        indexPaths.append(IndexPath.init(row: row, section: 0))
                                                    }
                                                    self?.tableView.insertRows(at: indexPaths, with: UITableView.RowAnimation.none)
                                                    self?.tableView.endUpdates()
                                                }
            },
                                             failure: { error in
                                                print("AwemeListTVC loadData: " + error.localizedDescription)
        })
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentIndex" {
            isCurPlayerPause = false
            weak var cell = tableView.cellForRow(at: IndexPath.init(row: currentIndex, section: 0)) as? AwemeListCell
            if cell?.isPlayerReady ?? false {
                cell?.replay()
            } else {
                AVPlayerManager.shared().pauseAll()
                cell?.onPlayerReady = {[weak self] in
                    if let indexPath = self?.tableView.indexPath(for: cell!) {
                        if !(self?.isCurPlayerPause ?? true) && indexPath.row == self?.currentIndex {
                            cell?.play()
                        }
                    }
                }
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    @objc func applicationBecomeActive() {
        if tableView != nil {
            let cell = tableView.cellForRow(at: IndexPath.init(row: currentIndex, section: 0)) as! AwemeListCell
            if !isCurPlayerPause {
                cell.playerView.play()
            }
        }
    }
    
    @objc func applicationEnterBackground() {
        if tableView != nil {
            let cell = self.tableView.cellForRow(at: IndexPath.init(row: currentIndex, section: 0)) as! AwemeListCell
            isCurPlayerPause = cell.playerView.rate() == 0 ? true : false
            cell.playerView.pause()
        }
    }
}
