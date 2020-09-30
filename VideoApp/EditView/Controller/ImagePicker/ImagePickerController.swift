//
//  ImagePickerController.swift
//  VideoApp
//
//  Created by Lauren on 8/6/20.
//  Copyright © 2020 VideoApp. All rights reserved.
//

import UIKit
import DKImagePickerController

/// Wrapper class for DKImagePickerController

class ImagePickerController: DKImagePickerController {

    init(rootViewController: UIViewController, maxSelectableCount: Int) {
        super.init(rootViewController: rootViewController)
        
        self.assetType = .allAssets
        self.maxSelectableCount = maxSelectableCount
        self.allowSwipeToSelect = true
        self.showsCancelButton = true
        self.sourceType = .photo
        self.UIDelegate = ImagePickerUIDelegate()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
}
