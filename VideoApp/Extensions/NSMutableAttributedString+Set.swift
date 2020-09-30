//
//  NSMutableAttributedString+Set.swift
//  VideoApp
//
//  Created by Lauren on 12/6/20.
//  Copyright © 2020 VideoApp. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    
    func setFont(_ font: UIFont) {
        self.addAttribute(.font, value: font, range: entireRange)
    }
    
    func setColor(_ color: UIColor) {
        self.addAttribute(.foregroundColor, value: color, range: entireRange)
    }
    
}

extension NSAttributedString {
    
    var entireRange: NSRange {
        NSMakeRange(0, self.length)
    }
    
    var foregroundColor: UIColor? {
        var color: UIColor?
        self.enumerateAttribute(.foregroundColor, in: entireRange) {value, range, stop in
            color = value as? UIColor
        }
        return color
    }
    
    var font: UIFont? {
        var font: UIFont?
        self.enumerateAttribute(.font, in: entireRange) {value, range, stop in
            font = value as? UIFont
        }
        return font
    }
}
