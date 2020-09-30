//
//  TextExtension.swift
//  VideoApp
//
//  Created by Lauren on 31/3/20.
//  Copyright © 2020 VideoApp. All rights reserved.
//

import UIKit

extension EditViewController: TextEditDelegate {
    
    @objc func addTextAct() {
        isFrameEdited = true
        deselectSprite()
        
        let newTextSprite = TextSprite()
        newTextSprite.translatesAutoresizingMaskIntoConstraints = true
        mainView.addSubview(newTextSprite)
        newTextSprite.setupTextLabel()
        
        let labelSize = newTextSprite.textLabel.frame.size
        let spriteWidth : CGFloat = labelSize.width
        let centerX = mainView.frame.width / 2 - spriteWidth / 2
        let spriteHeight : CGFloat = labelSize.height
        let centerY = mainView.frame.height / 2 - spriteHeight / 2
        let centerPoint = CGPoint(x: centerX, y: centerY)
        
        newTextSprite.frame = CGRect(origin: centerPoint, size: labelSize)
        
        selectSprite(newTextSprite)
    }
    
    func updateTextSprite(with model: TextModel) {
        isFrameEdited = true
        
        guard let textSprite = currentSelectedSprite as? TextSprite else { return }
        
        if model.attributedText.string == "" {
            deselectSprite()
            textSprite.removeFromSuperview()
            return
        }
        
        // TODO: Use setupText in textsprite
        
        let updatedLabel = PaddingLabel()
        updatedLabel.numberOfLines = 0
        updatedLabel.textInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        updatedLabel.attributedText = model.attributedText
        
        guard let newMutableString = updatedLabel.attributedText?.mutableCopy() as? NSMutableAttributedString else { return }
        // Use original font size so that preset text won't change size after being edited
        if let font = model.attributedText.font, let originalFontSize = model.originalFontSize {
            newMutableString.setFont(font.withSize(originalFontSize))
        }
        updatedLabel.attributedText = newMutableString.copy() as? NSAttributedString

        updatedLabel.sizeToFit()
        updatedLabel.frame = CGRect(origin: .zero, size: updatedLabel.frame.size)
        updatedLabel.isUserInteractionEnabled = false

        textSprite.textModel = model
        textSprite.textLabel = updatedLabel

        textSprite.contentView.subviews.forEach({ $0.removeFromSuperview() })
        textSprite.contentView.addSubview(updatedLabel)
        textSprite.contentView.frame = updatedLabel.frame
        textSprite.bounds = updatedLabel.frame

        textSprite.outerBorder.removeFromSuperlayer()
        textSprite.innerBorder.removeFromSuperlayer()
        textSprite.drawDashedBorder()

        textSprite.isUserInteractionEnabled = true
        
        selectSprite(textSprite)
    }
}
