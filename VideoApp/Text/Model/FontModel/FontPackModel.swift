//
//  FontPackModel.swift
//  VideoApp
//
//  Created by Lauren on 28/5/20.
//  Copyright © 2020 VideoApp. All rights reserved.
//

import Foundation

class FontPackModel {
    var name: String
    var isPaid: Bool
    var packs: [FontModel]

    init(name: String, isPaid: Bool) {
        assert(name != "")
        self.name = name
        self.isPaid = isPaid
        self.packs = []
    }
}
