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
    
    var currentIndex: Int = 0
    var pageIndex: Int = 0
    var pageSize: Int = 21
    var uid: String?
    var awemes = [Aweme]()
    var data = [Aweme]()
    
    init(data: [Aweme], currentIndex: Int, page: Int, size: Int, uid: String){
        super.init(nibName: nil, bundle: nil)
        self.currentIndex = currentIndex
        self.pageIndex = page
        self.pageSize = size
        self.uid = uid
        self.awemes = data
        self.data.append(data[currentIndex])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(AwemeListCell.classForCoder(), forCellReuseIdentifier: kAwemeCell)
        loadData(page: pageIndex)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1,
                                      execute: {
                                        self.data = self.awemes
                                        self.tableView.reloadData()
                                        if self.currentIndex > 15 {
                                            self.tableView.scrollToRow(at: IndexPath.init(row: self.currentIndex - 1, section: 0), at: UITableView.ScrollPosition.top, animated: false)
                                        }
                                        self.tableView.scrollToRow(at: IndexPath.init(row: self.currentIndex, section: 0), at: UITableView.ScrollPosition.middle, animated: false)
                                        let cell = self.tableView.cellForRow(at: IndexPath.init(row: self.currentIndex, section: 0)) as! AwemeListCell
                                        cell.playerView.play()
        })
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let cell = self.tableView.cellForRow(at: IndexPath.init(row: self.currentIndex, section: 0)) as! AwemeListCell
        cell.playerView.pause()
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
            if translatedPoint.y < -50 && self.currentIndex < 19 {
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
