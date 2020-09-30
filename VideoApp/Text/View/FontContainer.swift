//
//  FontContainer.swift
//  VideoApp
//
//  Created by Lauren on 29/5/20.
//  Copyright © 2020 VideoApp. All rights reserved.
//

import UIKit

class FontContainer: UIView {
    
    var scrollView: UIScrollView
    var contentView: UIView
    var containerStackView: UIStackView
    
    var firstFontButton: FontButtonView!
    var lastFontButton: FontButtonView!

    override init(frame: CGRect) {
        scrollView = UIScrollView()
        contentView = UIView()
        containerStackView = UIStackView()
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func commonInit() {
        self.translatesAutoresizingMaskIntoConstraints = false
        setupScrollView()
        setupContentView()
        setupContainerView()
        addIconsToContainerView()
    }
    
    func setupScrollView() {
        self.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func setupContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addChildView(contentView)
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
        ])
    }
    
    func setupContainerView() {
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.backgroundColor = .gray

        containerStackView.axis = .horizontal
        containerStackView.distribution = .fill
        containerStackView.alignment = .center
        containerStackView.spacing = 20
        contentView.addChildView(containerStackView)
    }
    
    func addIconsToContainerView() {
        let fontArr = FontPackData().fontArr
        for (index, fontModel) in fontArr.enumerated() {
            let fontButtonView = FontButtonView(frame: .zero, fontModel: fontModel)
            containerStackView.addArrangedSubview(fontButtonView)
            fontButtonView.heightAnchor.constraint(equalTo: containerStackView.heightAnchor).isActive = true
            
            if (index == 0) {
                firstFontButton = fontButtonView
            }
            if (index == fontArr.count - 1) {
                lastFontButton = fontButtonView
            }
        }
    }
    
}

