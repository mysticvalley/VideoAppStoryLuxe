//
//  StickerPackData.swift
//  VideoApp
//
//  Created by Lauren on 26/1/20.
//  Copyright © 2020 VideoApp. All rights reserved.
//

import UIKit

class StickerPackData {
    public var isDarkMode: Bool
    
    private var currentLoadedStickers: [StickerCategoryModel]!

    // Doodles
    private lazy var magic = StickerPackModel(name: "magic", category: "doodles", count: 6, isNeutral: false, isPaid: false)

    // Categories
    private lazy var doodles = StickerCategoryModel(name: "doodles")

    public lazy var categories: [StickerCategoryModel] = []
    
    required init() {
        isDarkMode = false
        currentLoadedStickers = loadStickers()
    }
    
    private func loadStickers() -> [StickerCategoryModel] {
        self.categories = [doodles]
        doodles.packs = [magic]

        for category in categories {
            category.packImages = []
            for pack in category.packs {
                if pack.isNeutral {
                    category.packImages.append(pack.neutralPackImages)
                } else if !isDarkMode {
                    category.packImages.append(pack.lightPackImages)
                } else {
                    fatalError("Invalid sticker type")
                }
            }
        }
        
        return categories
    }
    
    public func getStickerPackModel(for categoryIndex: Int, packIndex: Int) -> StickerPackModel {
        return categories[categoryIndex].packs[packIndex]
    }
    
    public func getNumberOfStickerPacks(for categoryIndex: Int) -> Int {
        return categories[categoryIndex].packs.count
    }
    
    public func getCategoryName(for categoryIndex: Int) -> String {
        return categories[categoryIndex].name
    }
    
    public func getStickers(for categoryIndex: Int) -> [[UIImage]] {
        return categories[categoryIndex].packImages
    }
    
}
