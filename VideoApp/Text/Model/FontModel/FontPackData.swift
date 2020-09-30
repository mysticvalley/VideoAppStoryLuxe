//
//  FontPackData.swift
//  VideoApp
//
//  Created by Lauren on 28/5/20.
//  Copyright © 2020 VideoApp. All rights reserved.
//

import Foundation

class FontPackData {
    private let defaultFontSize = 20.0
    
    // Distant Memories
    private lazy var zane = FontModel(name: "Zane", font: CustomFont.montserratRegular.of(size: defaultFontSize), boldFont: CustomFont.montserratBold.of(size: defaultFontSize), isPaid: false)

    
    private lazy var distantMemories = FontPackModel(name: "distant memories", isPaid: false)

    public var fontPacks = [FontPackModel]()
    public var fontArr = [FontModel]()
    
    required init() {
        distantMemories.packs = [zane]

        fontPacks = [distantMemories]
        
        fontArr = [zane]
    }
    
    public func getFontPack(from fontModel: FontModel) -> FontPackModel {
        for fontPack in fontPacks {
            if (fontPack.packs.contains{$0.name == fontModel.name}) {
                return fontPack
            }
        }
        fatalError("Invalid font model")
    }
    
}
