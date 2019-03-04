//
//  AVPlayerManager.swift
//  niYuoD
//
//  Created by Xhandsome on 2019/3/2.
//  Copyright © 2019 ZeroXsLab. All rights reserved.
//

import Foundation
import AVFoundation

class AVPlayerManager: NSObject {
    
    var playerArray = [AVPlayer]()
    
    private static let instance = { () -> AVPlayerManager in
        return AVPlayerManager.init()
    }()
    
    private override init() {
        super.init()
    }
    
    class func shared() -> AVPlayerManager {
        return instance
    }
    
    static func setAudioMode() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.moviePlayback, options: [])
            try AVAudioSession.sharedInstance().setActive(true, options: [])
        } catch {
            print("setAudioMode error: " + error.localizedDescription)
        }
    }
    
    func play(player: AVPlayer) {
        for object in playerArray {
            object.pause()
        }
        if !playerArray.contains(player) {
            playerArray.append(player)
        }
        player.play()
    }
    
    func pause(player: AVPlayer) {
        if playerArray.contains(player){
            player.pause()
        }
    }
    
    func pauseAll() {
        for object in playerArray {
            object.pause()
        }
    }
    
    func replay(player: AVPlayer){
        for object in playerArray {
            object.pause()
        }
        if playerArray.contains(player) {
            player.seek(to: CMTime.zero)
            play(player: player)
        } else {
            playerArray.append(player)
            play(player: player)
        }
    }
    
}
