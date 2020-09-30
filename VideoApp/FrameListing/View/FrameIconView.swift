//
//  IconView.swift
//  VideoApp
//
//  Created by Lauren on 15/5/20.
//  Copyright © 2020 VideoApp. All rights reserved.
//

import UIKit

class FrameIconView: UIView {
    var label: UILabel!
    var button: UIButton!
    var centerYConstraint: NSLayoutConstraint?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(frame: CGRect, index: Int) {
        super.init(frame: frame)
        
        self.backgroundColor = .white

        label = UILabel()
        label.text = String(index)

        self.button = UIButton()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.button.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(label)
        self.addChildView(button)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
}
