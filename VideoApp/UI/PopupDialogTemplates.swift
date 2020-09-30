//
//  PopupDialogTemplates.swift
//  VideoApp
//
//  Created by Lauren on 7/6/20.
//  Copyright © 2020 VideoApp. All rights reserved.
//

import UIKit
import PopupDialog

struct PopupDialogTemplates {
    static func setupEditViewAlertAppearance() {
        let dialogAppearance = PopupDialogDefaultView.appearance()
        dialogAppearance.titleColor     = .white
        dialogAppearance.messageColor   = UIColor(white: 0.8, alpha: 1)

        // Customize the container view appearance
        let pcv = PopupDialogContainerView.appearance()
        pcv.backgroundColor = UIColor(hexString: "2B3135")
        pcv.cornerRadius    = 6

        // Customize overlay appearance
        let ov = PopupDialogOverlayView.appearance()
        ov.blurEnabled     = true
        ov.opacity         = 0.7
        ov.color           = .black

        let deleteAppearance = DestructiveButton.appearance()
        deleteAppearance.titleColor     = UIColor(white: 0.6, alpha: 1)
        deleteAppearance.buttonColor    = UIColor(hexString: "30363B")
        deleteAppearance.separatorColor = UIColor(hexString: "2B3135")

        let saveAppearance = CancelButton.appearance()
        saveAppearance.titleColor       = .white
        saveAppearance.buttonColor      = UIColor(hexString: "30363B")
        saveAppearance.separatorColor   = UIColor(hexString: "2B3135")
    }
    
}
