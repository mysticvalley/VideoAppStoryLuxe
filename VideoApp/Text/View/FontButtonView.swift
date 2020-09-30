//
//  FontButtonView.swift
//  VideoApp
//
//  Created by Lauren on 29/5/20.
//  Copyright © 2020 VideoApp. All rights reserved.
//

import UIKit

class FontButtonView: UIView {
    var fontModel: FontModel
    var button: UIButton
    var underline: UIView

    init(frame: CGRect, fontModel: FontModel) {
        self.fontModel = fontModel
        self.button = UIButton()
        self.underline = UIView()
        super.init(frame: frame)

        self.addChildView(button)
        button.setTitle(fontModel.name, for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        button.titleLabel?.font = fontModel.font?.withSize(17)

        button.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(underline)
        underline.translatesAutoresizingMaskIntoConstraints = false
        underline.backgroundColor = .white
        underline.isHidden = true
        
        NSLayoutConstraint.activate([
            underline.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            underline.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            underline.heightAnchor.constraint(equalToConstant: 2),
            underline.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8)
        ])
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
