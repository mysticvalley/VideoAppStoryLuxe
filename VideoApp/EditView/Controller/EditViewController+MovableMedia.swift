//
//  EditViewController+MovableMedia.swift
//  VideoApp
//
//  Created by Lauren on 9/6/20.
//  Copyright © 2020 VideoApp. All rights reserved.
//

import AVKit

extension EditViewController: MovableMediaDelegate {
    
    func didTap(on imageTag: Int) {
        if currentSelectedSprite == nil {
            self.selectTag = imageTag
            if imagePickerController != nil && !imagePickerController.isBeingPresented {
                self.present(imagePickerController, animated: true)
            }
        } else {
            deselectSprite()
        }
    }
    
}
