//
//  MainViewSize.swift
//  VideoApp
//
//  Created by Lauren on 15/6/20.
//  Copyright © 2020 VideoApp. All rights reserved.
//

import UIKit

struct MainViewSize {

    private static let baseWidth: CGFloat = 355.33
    
    private static var width: CGFloat {
        switch UIDevice.current.screenType {
        case .iPhones_5_5s_5c_SE:
            return 261
        case .iPhones_6_6s_7_8:
            return 317
        case .iPhones_6Plus_6sPlus_7Plus_8Plus:
            return 355.33
        case .iPhone_11Pro, .iPhones_X_XS:
            return 398.33 - 40
        case .iPhone_XR_11:
            return 446 - 40
        case .iPhone_XSMax_ProMax:
            return 445.33 - 40
        default:
            print("Unknown device type")
            return 355.33
        }
    }
    
    static var adjustmentRatio: CGFloat {
        width / baseWidth
    }
}


