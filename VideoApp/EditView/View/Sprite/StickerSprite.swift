//
//  StickerSprite.swift
//  VideoApp
//
//  Created by Lauren on 16/1/20.
//  Copyright © 2020 VideoApp. All rights reserved.
//

import UIKit

class StickerSprite: SpriteView {
    
    var stickerImageView = UIImageView()
    
    init(frame: CGRect, stickerImageView: UIImageView) {
        super.init(frame: frame)
        super.commonInit()
        self.stickerImageView = stickerImageView
        contentView.addSubview(stickerImageView)
        contentView.frame = stickerImageView.frame
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        super.commonInit()
    }

//    func drawDashedBorder() {
//        outerBorder = CAShapeLayer()
//        outerBorder.strokeColor = UIColor(hexString: "88949e").cgColor
//        outerBorder.lineDashPattern = [4, 2]
//        outerBorder.frame = stickerImageView.bounds
//        outerBorder.fillColor = .none
//        outerBorder.path = UIBezierPath(rect: stickerImageView.frame).cgPath
//        contentView.layer.addSublayer(outerBorder)
//    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return alphaFromPoint(point: point) >= 10
    }
    
}
