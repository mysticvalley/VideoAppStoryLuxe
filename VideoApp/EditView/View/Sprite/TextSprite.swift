//
//  TextSprite.swift
//  VideoApp
//
//  Created by Lauren on 13/10/19.
//  Copyright © 2019 VideoApp. All rights reserved.
//

import UIKit

@IBDesignable
class TextSprite: SpriteView {
    //MARK: - Text
    @IBInspectable
    var text: String = "" {
        didSet {
            textLabel.attributedText = text == ""
                ? NSAttributedString(string: placeholderText)
                : NSAttributedString(string: text)
        }
    }
    
    @IBInspectable
    var textColor: UIColor = .white {
        didSet {
            changeAttribute { (mutableString) in
                mutableString.setColor(self.textColor)
            }
        }
    }
    
    // MARK: - Font
    @IBInspectable
    var fontName: String = "Montserrat-Regular" {
        didSet {
            changeAttribute { (mutableString) in
                if let font = UIFont(name: self.fontName, size: self.fontSize) {
                    mutableString.setFont(font)
                }
            }
        }
    }
    
    @IBInspectable
    var fontSize: CGFloat = 20 {
        didSet {
            let adjustedFontSize =  MainViewSize.adjustmentRatio * fontSize
            fontSize = adjustedFontSize
            
            changeAttribute { (mutableString) in
                if let font = UIFont(name: self.fontName, size: self.fontSize) {
                    mutableString.setFont(font)
                }
            }
        }
    }
    
    let placeholderText = "double tap to edit"
    var textModel = TextModel()
    var textLabel = PaddingLabel()
    var firstLoad = true

    //MARK: - Initialiser
    
    override func commonInit() {
        super.commonInit()
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func changeAttribute(change: @escaping (NSMutableAttributedString) -> Void) {
        guard let newMutableString = textLabel.attributedText?.mutableCopy() as? NSMutableAttributedString else { return }
        change(newMutableString)
        textLabel.attributedText = newMutableString.copy() as? NSAttributedString
    }
    
    // MARK: - Drawing
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        if firstLoad {
            setupTextLabel()
            drawDashedBorder()
            showBorder(textLabel.text! == placeholderText)
            firstLoad = false
        }

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.translatesAutoresizingMaskIntoConstraints = true
    }

    // Only set up after initialised
    func setupTextLabel() {
        // Frame needs to be set for IBDesignable to react
        textLabel.attributedText = text == ""
            ? NSAttributedString(string: placeholderText)
            : NSAttributedString(string: text)
        
        changeAttribute { (mutableString) in
            if let font = UIFont(name: self.fontName, size: self.fontSize) {
                mutableString.setFont(font)
            }
            mutableString.setColor(self.textColor)
        }

        textLabel.isUserInteractionEnabled = false
        textLabel.numberOfLines = 0
        textLabel.textInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        textLabel.sizeToFit()

        contentView.addSubview(textLabel)

        let previousCenter = self.center
        self.frame.size = textLabel.frame.size
        contentView.frame.size = textLabel.frame.size
        self.center = previousCenter

        textModel.attributedText = textLabel.attributedText!
        textModel.originalFontSize = textLabel.font.fontDescriptor.pointSize
    }
    
    func getAlignment(from alignmentString: String) -> NSTextAlignment {
        switch alignmentString {
        case "left":
            return .left
        case "center":
            return .center
        case "right":
            return .right
        default:
            fatalError("invalid alignment for TextSprite")
        }
    }
    
}

extension TextSprite {
    override func prepareForInterfaceBuilder() {
        setupTextLabel()
    }
}

class PaddingLabel : UILabel {

    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                                          left: -textInsets.left,
                                          bottom: -textInsets.bottom,
                                          right: -textInsets.right)
        return textRect.inset(by: invertedInsets)
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
}
