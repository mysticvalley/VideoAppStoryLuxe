//
//  StickerPackModel.swift
//  VideoApp
//
//  Created by Lauren on 17/5/20.
//  Copyright © 2020 VideoApp. All rights reserved.
//

import UIKit

struct StickerPackModel {
    var name: String
    var category: String
    var count: Int
    var isNeutral: Bool
    var isPaid: Bool
    
    var lightPackImages: [UIImage] {
        var packImages: [UIImage] = []
        for i in 1...(count) {
            if let image = UIImage(named: "\(name)-light-\(i)") {
                packImages.append(image)
            }
        }
        return packImages
    }
    
    var darkPackImages: [UIImage] {
        var packImages: [UIImage] = []
        for i in 1...(count) {
            if let image = UIImage(named: "\(name)-dark-\(i)") {
                packImages.append(image)
            }
        }
        return packImages
    }
    
    var neutralPackImages: [UIImage] {
        var packImages: [UIImage] = []
        for i in 1...(count) {
            if let image = UIImage(named: "\(name)-neutral-\(i)") {
                packImages.append(image)
            }
        }
        return packImages
    }
}
