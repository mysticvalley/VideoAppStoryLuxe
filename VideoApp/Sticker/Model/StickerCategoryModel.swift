//
//  StickerCategoryModel.swift
//  VideoApp
//
//  Created by Lauren on 17/5/20.
//  Copyright © 2020 VideoApp. All rights reserved.
//

import UIKit

class StickerCategoryModel {
    var name: String
    var packs: [StickerPackModel]
    var packImages: [[UIImage]]
    
    init(name: String) {
        self.name = name
        self.packs = []
        self.packImages = []
    }
}
