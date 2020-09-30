//
//  FrameSeriesData.swift
//  VideoApp
//
//  Created by Lauren on 14/5/20.
//  Copyright © 2020 VideoApp. All rights reserved.
//

import Foundation

struct FrameSeriesData {
    
    static let frames = ["frame1", "frame2" ]

    private lazy var frame1 = FrameModel(name: "Frame1", count: 1, isPaid: false)
    private lazy var frame2 = FrameModel(name: "Frame2", count: 1, isPaid: false)

    private var index: Int
    
    public var frameModelArr = [FrameModel]()
    
    private var frameString: String
    
    public var frameModel: FrameModel {
        if let frameModel = frameModelArr.first(where: {$0.name.lowercased() == frameString}) {
            return frameModel
        } else {
            fatalError("Frame model does not exist")
        }
    }

    init(segment: Int) {
        self.index = segment - 1
        self.frameString = FrameSeriesData.frames[index]
        // Order does not matter here
        self.frameModelArr = [frame1, frame2]
    }
    
}
