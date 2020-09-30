//
//  ImagePickerFlowLayout.swift
//  VideoApp
//
//  Created by Lauren on 10/6/20.
//  Copyright © 2020 VideoApp. All rights reserved.
//

import UIKit

open class ImagePickerFlowLayout: UICollectionViewFlowLayout {
    
    open override func prepare() {
        super.prepare()
        let windowWidth = UIScreen.main.bounds.width
        self.minimumLineSpacing = 1
        self.minimumInteritemSpacing = 1
        
        let numberOfItemsPerRow: CGFloat = 4
        let spacingBetweenCells: CGFloat = 1

        let totalSpacing = (2 * spacingBetweenCells) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row

        let width = (windowWidth - totalSpacing)/numberOfItemsPerRow
        self.itemSize = CGSize(width: width, height: width)
        
    }

}
