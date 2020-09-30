//
//  TextSprite.swift
//  VideoApp
//
//  Created by Lauren on 19/10/19.
//  Copyright © 2019 VideoApp. All rights reserved.
//

import UIKit

class SpriteView: UIView, UIGestureRecognizerDelegate {
    
    let contentView = UIView()
    var outerBorder = CAShapeLayer()
    var innerBorder = CAShapeLayer()
    var spriteTapGestureRecognizer: UIGestureRecognizer!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        
        self.addSubview(contentView)
        contentView.frame = self.bounds
        self.contentView.backgroundColor = .clear
        contentView.isUserInteractionEnabled = false

    }
    
    @IBAction func dismissAct(_ sender: Any) {
        DispatchQueue.main.async {
            self.isHidden = true
        }
    }
    
    func drawDashedBorder() {
        self.outerBorder = CAShapeLayer()
        outerBorder.strokeColor = UIColor(hexString: "202427").withAlphaComponent(0.3).cgColor
        outerBorder.lineDashPattern = [4, 2]
        outerBorder.fillColor = .none
        outerBorder.lineWidth = 0.5
        
        let outerBorderFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        outerBorder.frame = outerBorderFrame
        outerBorder.path = UIBezierPath(rect: outerBorderFrame).cgPath
        
        self.innerBorder = CAShapeLayer()
        innerBorder.strokeColor = UIColor(hexString: "e8e8e8").cgColor
        innerBorder.lineDashPattern = [4, 2]
        innerBorder.lineWidth = 1
        innerBorder.fillColor = .none
        
        let innerBorderFrame = CGRect(x: 0.5, y: 0.5, width: self.bounds.width-2, height: self.bounds.height-2)
        innerBorder.frame = innerBorderFrame
        innerBorder.path = UIBezierPath(rect: innerBorderFrame).cgPath
        
        self.contentView.layer.addSublayer(innerBorder)
        self.layer.addSublayer(outerBorder)
    }
    
    func showBorder(_ shouldShow: Bool) {
        self.outerBorder.isHidden = !shouldShow
        self.innerBorder.isHidden = !shouldShow
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
