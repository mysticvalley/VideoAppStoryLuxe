//
//  MovableView.swift
//  VideoApp
//
//  Created by Lauren on 27/6/20.
//  Copyright © 2020 VideoApp. All rights reserved.
//

import AVKit

class MovableView: UIView {
    
    var previewImageView: UIImageView?
    
    /// Object used to pass data when being dragged
    var localObject: Any
    
    private var playerLooper: AVPlayerLooper?
    private var queuePlayer: AVQueuePlayer?

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(image: UIImage) {
        self.previewImageView = UIImageView(image: image)
        self.localObject = previewImageView!
        
        super.init(frame: .zero)
        
        self.frame.size = image.size
        self.addSubview(previewImageView!)
    }
    
    var video: AVAsset?
    
    // TODO: Abstract into separate class
    init(video: AVAsset) {
        self.video = video
        self.localObject = video
        
        super.init(frame: .zero)
        
        let thumbnail = video.generateThumbnail()
        self.previewImageView = UIImageView(image: thumbnail)
        self.frame.size = thumbnail!.size
        
        let playerItem = AVPlayerItem(asset: video)
        queuePlayer = AVQueuePlayer(playerItem: playerItem)
        self.playerLooper = AVPlayerLooper(player: queuePlayer!, templateItem: playerItem)
        let playerLayer = AVPlayerLayer(player: queuePlayer)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = self.bounds
        self.layer.addSublayer(playerLayer)
        queuePlayer!.play()
    }
    
    public func pauseVideo() {
        queuePlayer?.pause()
    }
    
    public func playVideo() {
        queuePlayer?.play()
    }
    
//    private func generateThumbnail(from asset: AVAsset) -> UIImage? {
//        do {
//            let imgGenerator = AVAssetImageGenerator(asset: asset)
//            imgGenerator.appliesPreferredTrackTransform = true
//            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
//            let thumbnail = UIImage(cgImage: cgImage)
//            return thumbnail
//        } catch let error {
//            print("*** Error generating thumbnail: \(error.localizedDescription)")
//            return nil
//        }
//    }

}

extension AVAsset {
    func generateThumbnail() -> UIImage? {
        do {
            let imgGenerator = AVAssetImageGenerator(asset: self)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
}
