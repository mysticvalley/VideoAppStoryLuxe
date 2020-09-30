//
//  EditViewController+ImagePicker.swift
//  VideoApp
//
//  Created by Lauren on 21/5/20.
//  Copyright © 2020 VideoApp. All rights reserved.
//

import UIKit
import DKImagePickerController
import Photos

extension EditViewController {
    
    func didSelect(_ assets: [DKAsset]) {
        isFrameEdited = true
        
        if assets.count == 0 { return }

        var frameIndexArr = Array<Int>(1...self.numberOfFrames)
        frameIndexArr.remove(at: self.selectTag - 1)
        frameIndexArr.insert(self.selectTag, at: 0)
        
        for allocationIndex in 0..<assets.count {
            let frameIndex = frameIndexArr[allocationIndex]
            guard let movableMediaContainer = self.view.getViewWithTag(frameIndex) as? ImageScrollView else { return }
            
            if assets[allocationIndex].type == .photo {
                fetchImage(from: assets, allocationIndex: allocationIndex, movableMediaContainer: movableMediaContainer)
            } else {
                fetchVideo(from: assets, allocationIndex: allocationIndex, movableMediaContainer: movableMediaContainer)
            }
        }
    }
    
    func fetchImage(from assets: [DKAsset], allocationIndex: Int, movableMediaContainer: ImageScrollView) {
        let options = PHImageRequestOptions()

        assets[allocationIndex].fetchOriginalImage(options: options) { (image, info) in
            DispatchQueue.main.async {
                movableMediaContainer.display(image: image!)
            }
        }
    }
        

    func fetchVideo(from assets: [DKAsset], allocationIndex: Int, movableMediaContainer: ImageScrollView) {
        let options = PHVideoRequestOptions()
        assets[allocationIndex].fetchAVAsset(options: options) { (video, info) in
            DispatchQueue.main.async {
                movableMediaContainer.display(video: video!)
            }
        }
    }
    
}
