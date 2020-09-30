//
//  StickerCell.swift
//  VideoApp
//
//  Created by Lauren on 3/7/19.
//  Copyright © 2019 VideoApp. All rights reserved.
//

import UIKit

class StickerCell: UICollectionViewCell {
    
    @IBOutlet weak var stickerImageView: UIImageView!
    
    private var iapWatermark: UIImageView?
    
    override func prepareForReuse() {
        super.prepareForReuse();
        iapWatermark?.removeFromSuperview()
        iapWatermark = nil
    }
    
    public func setIapWatermark(to image: UIImageView) {
        iapWatermark = image
    }

}
