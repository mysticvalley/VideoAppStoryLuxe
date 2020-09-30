//
//  Extension.swift
//  VideoApp
//
//  Created by Lauren on 14/06/2019.
//  Copyright © 2019 VideoApp. All rights reserved.
//

import UIKit

extension EditViewController: StickerViewDelegate {
    
    @objc func stickerAct(_ sender: Any) {
        let board  = UIStoryboard.init(name: "Main", bundle: nil)
        if let stickerVC = board.instantiateViewController(withIdentifier: "StickerVC") as? StickerVC {
            stickerVC.delegate = self
            stickerVC.modalPresentationStyle = .overCurrentContext
            self.present(stickerVC, animated: true)
        }
    }
    
    func addSticker(stickerImage: UIImage) {
        isFrameEdited = true
        deselectSprite()
        
        let stickerImageView = UIImageView(image: stickerImage)
        
        // TODO: Enable for sticker tint color
//        let templateImage = stickerImage.withRenderingMode(.alwaysTemplate)
//        let stickerImageView = UIImageView(image: templateImage)
//        stickerImageView.tintColor = .red
        
        let originalWidth = stickerImageView.frame.width
        let originalHeight = stickerImageView.frame.height
        
        let minUnit : CGFloat = 100
        var newHeight = minUnit
        var newWidth = minUnit
        
        let scale = originalHeight / originalWidth
        if (originalHeight > minUnit) || (originalWidth > minUnit) {
            if scale < 1 {
                newHeight = newWidth * scale
            } else if scale > 1 {
                newWidth = newHeight / scale
            }
        }
        
        let stickerSize = CGSize(width: newWidth, height: newHeight)
        let stickerFrame = CGRect(origin: .zero, size: stickerSize)
        stickerImageView.frame = stickerFrame

        let stickerSprite = StickerSprite(frame: stickerFrame, stickerImageView: stickerImageView)
        self.mainView.addSubview(stickerSprite)
        
        let centerPoint = CGPoint(x:  self.mainView.frame.width/2 - newWidth/2, y: self.mainView.frame.height/2 - newHeight/2)
        stickerSprite.frame = CGRect(origin: centerPoint, size: stickerSize)
        
        stickerSprite.drawDashedBorder()
        
        selectSprite(stickerSprite)
    }
}
