//
//  Constants.swift
//  niYuoD
//
//  Created by Xhandsome on 2019/2/26.
//  Copyright © 2019 ZeroXsLab. All rights reserved.
//

import Foundation
import UIKit

let BaseUrl: String = "http://116.62.9.17:8080/douyin/"
let NetworkDomain: String = "com.network.niYuoD"

let FindUserByUID_URL: String = "user"
let FindAwemePostByPageURL: String = "aweme/post"
let FindAwemeFavoriteByPageURL: String = "aweme/favorite"

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height
let screenFrame = UIScreen.main.bounds
let statusBarHeight = UIApplication.shared.statusBarFrame.height
let cellGap: CGFloat = 9.0

let safeAreaTopHeight: CGFloat = 64

let bigFont: UIFont = UIFont.systemFont(ofSize: 26.0)
let midFont: UIFont = UIFont.systemFont(ofSize: 14.0)
let smallFont: UIFont = UIFont.systemFont(ofSize: 10.0)

enum LoadingType: Int {
    case LoadStateIdle
    case LoadStateLoading
    case LoadStateAll
    case LoadStateFailed
}
