//
//  AVPlayerView.swift
//  niYuoD
//
//  Created by Xhandsome on 2019/3/2.
//  Copyright © 2019 ZeroXsLab. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices

protocol AVPlayerUpdateDelegate: NSObjectProtocol {
    func onPlayItemStatusUpdate(status: AVPlayerItem.Status)
    func onProgressUpdate(current: CGFloat, total: CGFloat)
}

class AVPlayerView: UIView, URLSessionDelegate, AVAssetResourceLoaderDelegate, URLSessionDataDelegate, URLSessionTaskDelegate {
    
    var session: URLSession?
    var playerLayer: AVPlayerLayer = AVPlayerLayer.init()
    var player: AVPlayer?
    var playerItem: AVPlayerItem?
    var sourceURL: URL?
    var sourceScheme: String?
    var urlAsset: AVURLAsset?
    var data: Data?
    var response: HTTPURLResponse?
    var pendingRequests = [AVAssetResourceLoadingRequest]()
    var task: URLSessionDataTask?
    var cancelLoadingQueue: DispatchQueue?
    var hasRetry: Bool = false
    var delegate: AVPlayerUpdateDelegate?
    var timeObserver: Any?

    init() {
        super.init(frame: screenFrame)
        initSubView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubView() {
        session = URLSession.init(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        playerLayer = AVPlayerLayer.init(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        self.layer.addSublayer(self.playerLayer)
        addProgressObserver()
        cancelLoadingQueue = DispatchQueue.init(label: "com.start.cancelloadingqueue")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        playerLayer.frame = self.layer.bounds
        CATransaction.commit()
    }
    
    func setPlayerSourceUrl(urlString: String){
        sourceURL = URL.init(string: urlString)
        var components = URLComponents.init(url: sourceURL!, resolvingAgainstBaseURL: false)
        sourceScheme = components?.scheme
        DispatchQueue.main.async { [weak self] in
            components?.scheme = "streaming"
            self?.sourceURL = components?.url
            if let url = self?.sourceURL {
                self?.urlAsset = AVURLAsset.init(url: url)
                self?.urlAsset?.resourceLoader.setDelegate(self, queue: DispatchQueue.main)
                if let asset = self?.urlAsset {
                    let assetKeys = [
                        "playable",
                        "hasProtectedContent"
                    ]
                    self?.playerItem = AVPlayerItem.init(asset: asset, automaticallyLoadedAssetKeys: assetKeys)
                    self?.playerItem?.addObserver(self!, forKeyPath: "status", options: [.initial, .new], context: nil)
                    self?.player = AVPlayer.init(playerItem: self?.playerItem)
                    self?.playerLayer.player = self?.player
                    self?.addProgressObserver()
                }
            }
        }
    }
    
    func cancelLoading() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        playerLayer.isHidden = true
        CATransaction.commit()
        playerItem?.removeObserver(self, forKeyPath: "status")
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
        }
        pause()
        player = nil
        playerItem = nil
        playerLayer.player = nil
        cancelLoadingQueue?.async { [weak self] in
            self?.urlAsset?.cancelLoading()
            self?.task?.cancel()
            self?.task = nil
            self?.data = nil
            self?.response = nil
            for loadingRequest in self?.pendingRequests ?? [] {
                if !loadingRequest.isFinished {
                    loadingRequest.finishLoading()
                }
            }
            self?.pendingRequests.removeAll()
        }
    }
    
    func rate() -> CGFloat {
        return CGFloat.init(player?.rate ?? 0)
    }
    
    func play() {
        AVPlayerManager.shared().play(player: player!)
    }
    
    func pause() {
        AVPlayerManager.shared().pause(player: player!)
    }
    
    func replay() {
        AVPlayerManager.shared().replay(player: player!)
    }
    
    func updatePlayerState(){
        if player?.rate == 0 {
            play()
        } else {
            pause()
        }
    }
    
    deinit {
        playerItem?.removeObserver(self, forKeyPath: "status")
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        let httpResponse = dataTask.response as! HTTPURLResponse
        let code = httpResponse.statusCode
        if code == 200 {
            completionHandler(URLSession.ResponseDisposition.allow)
            self.data = Data.init()
            self.response = httpResponse
            self.processPendingRequests()
        } else {
            completionHandler(URLSession.ResponseDisposition.cancel)
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.data?.append(data)
        self.processPendingRequests()
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            NSLog("AVPlayer resouce download error \(error!.localizedDescription)")
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
        completionHandler(nil)
    }
    
    func processPendingRequests() {
        var completedRequests = [AVAssetResourceLoadingRequest]()
        for loadingRequest in self.pendingRequests {
            let didRespondCompletely = respondWithDataForRequest(loadingRequest: loadingRequest)
            if didRespondCompletely {
                completedRequests.append(loadingRequest)
                loadingRequest.finishLoading()
            }
        }
        for completedRequest in completedRequests {
            if let index = pendingRequests.firstIndex(of: completedRequest) {
                pendingRequests.remove(at: index)
            }
        }
    }
    
    func respondWithDataForRequest(loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        let mimeType = self.response?.mimeType ?? ""
        let contentType = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType as CFString, nil)
        loadingRequest.contentInformationRequest?.isByteRangeAccessSupported = true
        loadingRequest.contentInformationRequest?.contentType = contentType?.takeRetainedValue() as String?
        loadingRequest.contentInformationRequest?.contentLength = (self.response?.expectedContentLength)!
        var startOffset: Int64 = loadingRequest.dataRequest?.requestedOffset ?? 0
        if loadingRequest.dataRequest?.currentOffset != 0 {
            startOffset = loadingRequest.dataRequest?.currentOffset ?? 0
        }
        if Int64(data?.count ?? 0) < startOffset {
            return false
        }
        let unreadBytes: Int64 = Int64(data?.count ?? 0) - startOffset
        let numberOfBytesToRespondWidth: Int64 = min(Int64(loadingRequest.dataRequest?.requestedLength ?? 0), unreadBytes)
        if let subdata = (data?.subdata(in: Int(startOffset) ..< Int(startOffset + numberOfBytesToRespondWidth))) {
            loadingRequest.dataRequest?.respond(with: subdata)
            let endOffset: Int64 = startOffset + Int64(loadingRequest.dataRequest?.requestedLength ?? 0)
            return Int64(data?.count ?? 0) >= endOffset
        }
        return false
    }
    
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        if task == nil {
            if var url = loadingRequest.request.url {
                var components = URLComponents.init(url: url, resolvingAgainstBaseURL: false)
                components?.scheme = sourceScheme ?? "https"
                url = components?.url ?? url
                let request = URLRequest.init(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 60)
                task = session?.dataTask(with: request)
                task?.resume()
            }
        }
        pendingRequests.append(loadingRequest)
        return true
    }
    
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, didCancel loadingRequest: AVAssetResourceLoadingRequest) {
        if let index = pendingRequests.firstIndex(of: loadingRequest) {
            pendingRequests.remove(at: index)
        }
    }
    
    func addProgressObserver(){
        timeObserver = player?.addPeriodicTimeObserver(forInterval: CMTime.init(value: 1, timescale: 1),
                                                       queue: DispatchQueue.main,
                                                       using: {[weak self] time in
                                                        let current = CMTimeGetSeconds(time)
                                                        let total = CMTimeGetSeconds(self?.playerItem?.duration ?? CMTime.init())
                                                        if total == current {
                                                            self?.replay()
                                                        }
                                                        self?.delegate?.onProgressUpdate(current: CGFloat.init(current), total: CGFloat.init(total))
        })
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            let status = playerItem?.status ?? AVPlayerItem.Status.unknown
            switch status {
            case .readyToPlay:
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                playerLayer.isHidden = false
                CATransaction.commit()
                play()
            case .unknown:
                break
            case .failed:
                if !hasRetry {
                    cancelLoading()
                    var url = sourceURL ?? URL.init(string: "")!
                    var components = URLComponents.init(url: url, resolvingAgainstBaseURL: false)
                    components?.scheme = sourceScheme ?? "https"
                    url = components?.url ?? url
                    setPlayerSourceUrl(urlString: url.absoluteString)
                    hasRetry = true
                }
            }
            delegate?.onPlayItemStatusUpdate(status: playerItem?.status ?? AVPlayerItem.Status.unknown)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

}
