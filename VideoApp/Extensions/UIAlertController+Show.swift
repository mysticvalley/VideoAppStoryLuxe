//
//  UIAlertController+Show.swift
//  VideoApp
//
//  Created by Lauren on 7/6/20.
//  Copyright © 2020 VideoApp. All rights reserved.
//

import UIKit

public extension UIAlertController {
    func show() {
        if #available(iOS 13.0, *) {
            if var topController = UIApplication.shared.keyWindow?.rootViewController  {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                topController.present(self, animated: true, completion: nil)
            }
        } else {
            let win = UIWindow(frame: UIScreen.main.bounds)
            let vc = UIViewController()
            vc.view.backgroundColor = .clear
            win.rootViewController = vc
            win.windowLevel = UIWindow.Level.alert + 1
            win.makeKeyAndVisible()
            vc.present(self, animated: true, completion: nil)
        }
    }
}
