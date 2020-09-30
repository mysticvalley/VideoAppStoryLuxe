//
//  EditViewControllerGestureRecognizerExtension.swift
//  VideoApp
//
//  Created by Lauren on 25/3/20.
//  Copyright © 2020 VideoApp. All rights reserved.
//

import UIKit

extension EditViewController: UIGestureRecognizerDelegate {
    func addGestureRecognisers() {
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        self.tapGestureRecognizer.delegate = self
        mainView.addGestureRecognizer(tapGestureRecognizer)
        
        self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action:  #selector(handlePan(_:)))
        self.panGestureRecognizer.delegate = self
        mainView.addGestureRecognizer(panGestureRecognizer)
        
    }
    
    //MARK: - Sprite Selection Methods
    func selectSprite(_ selectedSprite: SpriteView) {
        currentSelectedSprite = selectedSprite
        
        self.doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGestureRecognizer.delegate = self
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        currentSelectedSprite!.addGestureRecognizer(doubleTapGestureRecognizer)

        self.currentSelectedSprite?.showBorder(true)
        enableImageViewScrolling(false)
    }
    
    func deselectSprite() {
        guard let selectedSprite = currentSelectedSprite else {return}
        selectedSprite.showBorder(false)
        
        // TODO: Abstract out into another class
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.bottomBar.alpha = 1
        }, completion: nil)
        //        NotificationCenter.default.post(name: .spriteWasDeselected, object: self)
        
        if let sticker = currentSelectedSprite as? StickerSprite {
            if (sticker.stickerImageView.alpha <= 0.0) {
                sticker.isHidden = true
            }
        }

        self.currentSelectedSprite = nil
        enableImageViewScrolling(true)
    }
    
    // MARK: - Text Sprite Gesture
    @objc func handleDoubleTap(_ sender: UITapGestureRecognizer) {
        let touchedPoint = sender.location(in: self.mainView)
        if let textSprite = self.mainView.hitTest(touchedPoint, with: nil) as? TextSprite {

            let board  = UIStoryboard.init(name: "Main", bundle: nil)
            let textEditViewController = board.instantiateViewController(withIdentifier: "TextEditViewController") as! TextEditViewController
            textEditViewController.modalTransitionStyle = .crossDissolve
            textEditViewController.modalPresentationStyle = .overCurrentContext
            
            textEditViewController.delegate = self
            textEditViewController.setTextModel(with: textSprite.textModel)
            
            self.currentSelectedSprite = textSprite
            self.present(textEditViewController, animated: true, completion: nil)
        }
    }
    
    func enableImageViewScrolling(_ isAllowed : Bool) {
        guard numberOfFrames > 0 else { return }
        for i in 1...numberOfFrames {
            if let imageScrollView = view.getViewWithTag(i) as? ImageScrollView {
                imageScrollView.isScrollEnabled = isAllowed
                imageScrollView.pinchGestureRecognizer?.isEnabled = isAllowed
            }
        }
    }
    
    // MARK: - MainView Tap Gesure
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let touchedPoint = sender.location(in: self.mainView)
        if let sprite = self.mainView.hitTest(touchedPoint, with: nil) as? SpriteView {
            
            if currentSelectedSprite == sprite {
                deselectSprite()
            } else {
                deselectSprite()
                selectSprite(sprite)
            }
            return
        }
        
        // Catch any taps outside of sprite
        if currentSelectedSprite != nil {
            deselectSprite()
        }
    }
    
    // MARK: - Pan Gesture
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        if let current = currentSelectedSprite {
            switch gesture.state {
            case .began:
                isFrameEdited = true
                spriteOrigin = current.center
                // TODO: Hide bottom bar when StickerSprite is dragged
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    self.bottomBar.alpha = 0
                }, completion: nil)
                break
            case .changed:
                let translation = gesture.translation(in: self.mainView)
                let newPosition = CGPoint(x: spriteOrigin.x + translation.x, y: spriteOrigin.y + translation.y)
                current.center = newPosition
                break
            case .ended:
                // TODO: Abstract out into different file
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    self.bottomBar.alpha = 1
                }, completion: nil)
                break
            default:
                return
            }
            
        }
    }
    
    func shouldDeleteSprite(_ isDeleted: Bool) {
        if (isDeleted) {
            if let current = currentSelectedSprite {
                current.isHidden = true
                deselectSprite()
            }
        }
    }
}
