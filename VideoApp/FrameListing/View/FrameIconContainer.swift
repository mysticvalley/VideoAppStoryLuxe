//
//  FrameIconView.swift
//  VideoApp
//
//  Created by Lauren on 15/5/20.
//  Copyright © 2020 VideoApp. All rights reserved.
//

import UIKit

class FrameIconContainer: UIView {
    
    var scrollView: UIScrollView!
    var contentView: UIView!
    var videoAppIcon: UIView!
    var imager: UIImageView!
    var line: UIView!
    var iapButton: UIButton!
    var containerView: UIView!
    var frameIconViews = [FrameIconView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        self.translatesAutoresizingMaskIntoConstraints = false
        setupScrollView()
        setupContentView()
        setupIcon()
        setupContainerView()
        addIconsToContainerView()
        
        let views = self.subviews(ofType: UIView.self)
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func setupScrollView() {
        scrollView = UIScrollView()
        self.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            scrollView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor),
            scrollView.bottomAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor),
        ])
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
    }
    
    func setupContentView() {
        contentView = UIView()
        scrollView.addChildView(contentView)
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
    
    func setupIcon() {
        videoAppIcon = UIView()

        let widthConstraint = UIScreen.main.bounds.width * 0.23913
        contentView.addSubview(videoAppIcon)
        NSLayoutConstraint.activate([
            videoAppIcon.widthAnchor.constraint(equalTo: videoAppIcon.heightAnchor),
            videoAppIcon.widthAnchor.constraint(equalToConstant: widthConstraint),
            videoAppIcon.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.824242),
            videoAppIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            videoAppIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        ])
    }
    
    func setupContainerView() {
        containerView = UIView()
        containerView.clipsToBounds = false
        
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            contentView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            containerView.leadingAnchor.constraint(equalTo: videoAppIcon.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func addIconsToContainerView() {
        var prevIconView = UIView()
        for (index) in 0...1 {
            let frameIconView = FrameIconView(frame: .zero, index: index)
            containerView.addSubview(frameIconView)
            frameIconViews.append(frameIconView)
            frameIconView.tag = index + 1
            
            let centerYConstraint = frameIconView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
            frameIconView.centerYConstraint = centerYConstraint

            NSLayoutConstraint.activate([
                frameIconView.widthAnchor.constraint(equalTo: frameIconView.heightAnchor, multiplier: 4/5),
                frameIconView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.193237),
                centerYConstraint,
            ])
            
            if (index == 0) {
                NSLayoutConstraint.activate([
                    frameIconView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
                ])
            } else if (index == 1) {
                NSLayoutConstraint.activate([
                    frameIconView.leadingAnchor.constraint(equalTo: prevIconView.trailingAnchor, constant: 5),
                    frameIconView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                ])
            } else {
                NSLayoutConstraint.activate([
                    frameIconView.leadingAnchor.constraint(equalTo: prevIconView.trailingAnchor, constant: 5)
                ])
            }
            
            prevIconView = frameIconView

        }
    }
    
}

