//
//  UIConstraintX.swift
//  MyBoxMan
//
//  Created by Naqash on 12/28/18.
//  Copyright © 2018 Lecodeur. All rights reserved.
//

import UIKit

@IBDesignable
class UIConstraintX: NSLayoutConstraint {
    
    @IBInspectable var topSpace: CGFloat = 0 {
        didSet {
            if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height >= 2436  {
                self.constant = topSpace
            }
           else if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 1792 {
                self.constant = topSpace
            }
        }
    }
    
//    @IBInspectable var iphoneSE_Const: CGFloat = 0 {
//        didSet {
//            if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 1136  {
//                self.constant = iphoneSE_Const
//            }
//        }
//    }
}
class UIConstraintY: NSLayoutConstraint {
    
    @IBInspectable var horizantalSpace: CGFloat = 0 {
        didSet {
            if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height > 1334 {
                self.constant = horizantalSpace
            }
        }
    }
}
