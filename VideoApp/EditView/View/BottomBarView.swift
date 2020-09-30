//
//  BottomBarView.swift
//  VideoApp
//
//  Created by Lauren on 11/6/20.
//  Copyright © 2020 VideoApp. All rights reserved.
//

import UIKit

class BottomBarView: UIView {
    
    let textButton: UIButton
    let stickerButton: UIButton
    let colorPickerButton: UIButton
    let saveButton: UIButton
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        // Text button
        let textImage = UIImageView(image: UIImage(named: "textIcon"))
        textImage.translatesAutoresizingMaskIntoConstraints = false
        textImage.contentMode = .scaleAspectFit
        
        self.textButton = UIButton()
        textButton.translatesAutoresizingMaskIntoConstraints = false
        
        let textView = UIView(frame: .zero)
        textView.addChildView(textImage)
        textView.addChildView(textButton)
        
        // Sticker button
        let stickerImage = UIImageView(image: UIImage(named: "stickerIcon"))
        stickerImage.translatesAutoresizingMaskIntoConstraints = false
        stickerImage.contentMode = .scaleAspectFit
        
        self.stickerButton = UIButton()
        stickerButton.translatesAutoresizingMaskIntoConstraints = false
        
        let stickerView = UIView(frame: .zero)
        stickerView.addChildView(stickerImage)
        stickerView.addChildView(stickerButton)
        
        // ColorIcon button
        let colorPickerImage = UIImageView(image: UIImage(named: "colorIcon"))
        colorPickerImage.translatesAutoresizingMaskIntoConstraints = false
        colorPickerImage.contentMode = .scaleAspectFit
        colorPickerImage.tag = 101   //tag if need to disable
        
        self.colorPickerButton = UIButton()
        colorPickerButton.translatesAutoresizingMaskIntoConstraints = false
        colorPickerButton.tag = 102  //tag if need to disable
        
        let colorPickerView = UIView(frame: .zero)
        colorPickerView.addChildView(colorPickerImage)
        colorPickerView.addChildView(colorPickerButton)
        
        // Save button
        let saveImage = UIImageView(image: UIImage(named: "saveIcon"))
        saveImage.translatesAutoresizingMaskIntoConstraints = false
        saveImage.contentMode = .scaleAspectFit
        
        self.saveButton = UIButton()
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        let saveView = UIView(frame: .zero)
        saveView.addChildView(saveImage)
        saveView.addChildView(saveButton)
        
        //Stack View
        let stackView = UIStackView(arrangedSubviews: [textView, colorPickerView, stickerView, saveView])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(frame: .zero)
        
        self.addChildView(stackView)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    
}
