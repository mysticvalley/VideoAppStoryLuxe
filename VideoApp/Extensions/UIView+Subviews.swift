//
//  UIView+subviews.swift
//  VideoApp
//
//  Created by Lauren on 18/5/20.
//  Copyright © 2020 VideoApp. All rights reserved.
//

import UIKit

extension UIView {
    // Usage: let arr = myView.subviews(ofType: MyButtonClass.self)
    func subviews<T:UIView>(ofType WhatType:T.Type) -> [T] {
        var result = self.subviews.compactMap {$0 as? T}
        for sub in self.subviews {
            result.append(contentsOf: sub.subviews(ofType:WhatType))
        }
        return result
    }
}
