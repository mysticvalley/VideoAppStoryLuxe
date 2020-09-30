//
//  UIView+AlphaFromPoint.swift
//  VideoApp
//
//  Created by Lauren on 12/5/20.
//  Copyright © 2020 VideoApp. All rights reserved.
//

import UIKit

extension UIView {
    func alphaFromPoint(point: CGPoint) -> CGFloat {
        var pixel: [UInt8] = [0, 0, 0, 0]
        let colourSpace = CGColorSpaceCreateDeviceRGB()
        let alphaInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: &pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colourSpace, bitmapInfo: alphaInfo.rawValue)

        context?.translateBy(x: -point.x, y: -point.y)

        self.layer.render(in: context!)

        let floatAlpha = CGFloat(pixel[3])
        return floatAlpha
    }
}
