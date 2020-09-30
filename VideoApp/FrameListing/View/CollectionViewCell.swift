//
//  CollectionViewCell.swift
//  VideoApp
//
//  Created by VideoApp on 14/02/2019.
//  Copyright © 2019 VideoApp. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.contentView.layer.cornerRadius = 6.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
