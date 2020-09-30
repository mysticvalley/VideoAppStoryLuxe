//
//  EditingTextView.swift
//  VideoApp
//
//  Created by Lauren on 12/6/20.
//  Copyright © 2020 VideoApp. All rights reserved.
//

import UIKit

/// TextView which implements text attribute change using NSAttributedString and NSMutableAttributedString.

class EditingTextView: UITextView {
    
    /// Typing attributes of the cursor.
    var currentTypingAttributes = [NSAttributedString.Key : Any]()

    func setFont(_ font: UIFont) {
        changeAttribute { (mutableString) in
            mutableString.setFont(font)
            self.currentTypingAttributes[NSAttributedString.Key.font] = font
        }
    }
    
    func setTextColor(to color: UIColor) {
        changeAttribute { (mutableString) in
            mutableString.setColor(color)
            self.currentTypingAttributes[NSAttributedString.Key.foregroundColor] = color
        }
    }
    
    func changeAttribute(change: @escaping (NSMutableAttributedString) -> Void) {
        let preAttributedRange = self.selectedRange
        guard let newMutableString = self.attributedText?.mutableCopy() as? NSMutableAttributedString else { return }

        change(newMutableString)

        self.attributedText = newMutableString.copy() as? NSAttributedString
        self.selectedRange = preAttributedRange
        
        // Udpate text attributes at cursor
        self.typingAttributes = currentTypingAttributes
    }
    
}
