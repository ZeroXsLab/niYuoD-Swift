//
//  AwemeListCell.swift
//  niYuoD
//
//  Created by Xhandsome on 2019/2/27.
//  Copyright © 2019 ZeroXsLab. All rights reserved.
//

import UIKit

class AwemeListCell: UITableViewCell {
    
    var aweme: Aweme?
    
    var playerView: AVPlayerView = AVPlayerView.init()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if let _ = self.playerView.player {
            if self.playerView.playStatus {
                self.playerView.pause()
            } else {
                self.playerView.play()
            }
        }
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubViews() {
        self.contentView.addSubview(playerView)
    }
    
    func initData(aweme: Aweme) {
        self.aweme = aweme
        playerView.setPlayerSourceUrl(urlString: aweme.video?.play_addr?.url_list.first ?? "")
//        playerView.play()
    }

}
