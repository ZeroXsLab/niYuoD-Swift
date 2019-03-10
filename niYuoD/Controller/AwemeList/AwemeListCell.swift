//
//  AwemeListCell.swift
//  niYuoD
//
//  Created by Xhandsome on 2019/2/27.
//  Copyright © 2019 ZeroXsLab. All rights reserved.
//

import UIKit
import AVFoundation

typealias OnPlayerReady = () -> Void

class AwemeListCell: UITableViewCell, AVPlayerUpdateDelegate {
    
    var aweme: Aweme?
    var container: UIView = UIView.init()
    var playerView: AVPlayerView = AVPlayerView.init()
    var descLabel: UILabel = UILabel.init()
    var isPlayerReady: Bool = false
    var onPlayerReady: OnPlayerReady?
    var singleTapGesture: UITapGestureRecognizer?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubViews() {
        playerView.delegate = self
        self.contentView.backgroundColor = UIColor.gray
        self.contentView.addSubview(playerView)
        self.contentView.addSubview(container)
        singleTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(singleTapAction(sender:)))
        container.addGestureRecognizer(singleTapGesture!)
        descLabel.text = ""
        descLabel.textColor = UIColor.white
        container.addSubview(descLabel)
    }
    
    func initData(aweme: Aweme) {
        self.aweme = aweme
        playerView.setPlayerSourceUrl(urlString: aweme.video?.play_addr?.url_list.first ?? "")
        descLabel.text = aweme.desc ?? "Description:"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playerView.cancelLoading()
        descLabel.text = ""
        isPlayerReady = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        container.frame = self.bounds
        descLabel.frame = CGRect.init(x: 10, y: self.bounds.size.height - 20, width: self.bounds.size.width - 20, height: 12)
    }
    
    func play() {
        playerView.play()
    }
    
    func pause() {
        playerView.pause()
    }
    
    func replay() {
        playerView.replay()
    }
    
    func onPlayItemStatusUpdate(status: AVPlayerItem.Status) {
        switch status {
        case .readyToPlay:
            isPlayerReady = true
            onPlayerReady?()
            break
        default:
            break
        }
    }
    
    @objc func singleTapAction(sender: UITapGestureRecognizer){
        playerView.updatePlayerState()
    }

}
