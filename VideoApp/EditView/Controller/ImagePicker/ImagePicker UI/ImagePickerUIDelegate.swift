//
//  ImagePickerUIDelegate.swift
//  VideoApp
//
//  Created by Lauren on 10/6/20.
//  Copyright © 2020 VideoApp. All rights reserved.
//

import UIKit
import DKImagePickerController

open class ImagePickerUIDelegate: DKImagePickerControllerBaseUIDelegate {
   
    override open func createDoneButtonIfNeeded() -> UIButton {
        if self.doneButton == nil {
            let button = UIButton(type: .custom)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            button.setTitleColor(.white, for: .normal)
            button.setTitleColor(UIColor.white.withAlphaComponent(0.4), for: .disabled)
            button.addTarget(self.imagePickerController, action: #selector(DKImagePickerController.done), for: .touchUpInside)
            self.doneButton = button
        }
        
        updateDoneButtonTitle(self.doneButton!)

        return self.doneButton!
    }
    
    override open func updateDoneButtonTitle(_ button: UIButton) {
        if (self.imagePickerController.selectedAssets.count == self.imagePickerController.maxSelectableCount) {
            button.setTitle("Done(\(self.imagePickerController.selectedAssets.count))", for: .normal)
            button.isEnabled = true
        } else if (self.imagePickerController.selectedAssets.count > 0) {
            button.setTitle("Select(\(self.imagePickerController.selectedAssets.count))", for: .normal)
            button.isEnabled = true
        } else {
            button.setTitle("Select", for: .normal)
            button.isEnabled = false
        }
        
        button.sizeToFit()
    }
    

    override open func layoutForImagePickerController(_ imagePickerController: DKImagePickerController) -> UICollectionViewLayout.Type {
        return ImagePickerFlowLayout.self
    }
    
}
