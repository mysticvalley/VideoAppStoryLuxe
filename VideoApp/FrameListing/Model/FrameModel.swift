//
//  FrameModel.swift
//  VideoApp
//
//  Created by Lauren on 14/5/20.
//  Copyright © 2020 VideoApp. All rights reserved.
//

import Foundation

struct FrameModel {
    var name: String
    var count: Int
    var isPaid: Bool

    init(name: String, count: Int, isPaid: Bool) {
        assert(name != "")
        assert(count > 0)
        self.name = name
        self.count = count
        self.isPaid = isPaid
    }
}
