//
//  TopBarView.swift
//  VideoApp
//
//  Created by Lauren on 11/6/20.
//  Copyright © 2020 VideoApp. All rights reserved.
//

import UIKit

class TopBarView: UIView {
    
    let backButton: UIButton

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {

        let topContainer = UIView(frame: .zero)
        topContainer.translatesAutoresizingMaskIntoConstraints = false

        // Back button
        let backImage = UIImageView(image: UIImage(named: "Back"))
        backImage.translatesAutoresizingMaskIntoConstraints = false

        self.backButton = UIButton()
        backButton.translatesAutoresizingMaskIntoConstraints = false

        super.init(frame: .zero)
        
        topContainer.addSubview(backImage)
        topContainer.addSubview(backButton)

        self.addChildView(topContainer)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        //Layout top bar
        NSLayoutConstraint.activate([
            backButton.centerYAnchor.constraint(equalTo: topContainer.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 70),
            backButton.heightAnchor.constraint(equalTo: topContainer.heightAnchor),
            backButton.leftAnchor.constraint(equalTo: topContainer.leftAnchor),
            
            backImage.centerYAnchor.constraint(equalTo: topContainer.centerYAnchor),
            backImage.leftAnchor.constraint(equalTo: topContainer.leftAnchor, constant: 20),
            backImage.widthAnchor.constraint(equalTo: backImage.heightAnchor, multiplier: 1 / 17 * 10),     //aspect ratio of back image
            backImage.heightAnchor.constraint(equalTo: topContainer.heightAnchor, multiplier: 1 / 44 * 17),     //ratio of back image height to nar bar height
            
        ])
    }
    
}
