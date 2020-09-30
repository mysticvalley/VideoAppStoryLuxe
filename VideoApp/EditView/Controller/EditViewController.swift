//
//  EditFrameVC.swift
//  VideoApp
//
//  Created by VideoApp on 19/02/2019.
//  Copyright © 2019 VideoApp. All rights reserved.
//

import UIKit
import CropViewController
import PopupDialog
import Photos

class EditViewController: UIViewController {
    
    var imagePickerController: ImagePickerController!
    
    var mainView : UIView!
    var bottomBar: UIView!
    
    var previousImageView: UIImageView?
    
    var selectTag = 0
    var numberOfFrames = 0

    var isFrameEdited = false
    var previousColor: UIColor!
    var backgroundColorHex: String?
    
    //Sprite Gesture Recognizer
    var tapGestureRecognizer: UITapGestureRecognizer!
    var panGestureRecognizer: UIPanGestureRecognizer!
    var doubleTapGestureRecognizer: UITapGestureRecognizer!
    
    //Sprite variables
    var currentSelectedSprite: SpriteView?
    var spriteOrigin = CGPoint(x: 0.0, y: 0.0)
    
    //TextSprite variables
    var textModel = TextModel()
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = AppUtils.shared.MY_GREY
        
        self.mainView = self.view.getViewWithTag(40)
        self.mainView.clipsToBounds = true

        self.numberOfFrames = getNumberOfFrames()
        imageSetUp()
        
        self.imagePickerController = ImagePickerController(rootViewController: UIViewController(), maxSelectableCount: numberOfFrames)
        self.imagePickerController.didSelectAssets = { [weak self] assets in
            guard let self = self else { return }
            self.didSelect(assets)
            for asset in assets {
                self.imagePickerController.deselect(asset: asset)
            }
        }
        
        addGestureRecognisers()
        
        self.previousImageView = self.view.getImageViewWithTag(210)
        
        setupTopBar()
        setupBottomBar()

        setupPreviousColor()
        
        PopupDialogTemplates.setupEditViewAlertAppearance()
        
    }
    
    private func setupPreviousColor() {
        // Non-main view background color view, i.e. not taking up the whole mainview
        self.previousColor = mainView.backgroundColor!
        
        if let colorView = view.viewWithTag(41) {
            self.previousColor = colorView.backgroundColor
        }
    }
    
    public func getNumberOfFrames() -> Int {
        var numberOfFrames = 0
        for i in 1... {
            if let _ = self.view.getViewWithTag(i) as? ImageScrollView {
                numberOfFrames = i
            } else {
                break
            }
        }
        
        if self.restorationIdentifier == "Vesper9" || self.restorationIdentifier == "Vesper10" {
            // No images
            assert(numberOfFrames == 0)
        }
        return numberOfFrames
    }

    func hideBottomBar() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.bottomBar.alpha = 0
        }, completion: nil)
    }
    
    func showBottomBar() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.bottomBar.alpha = 1
        }, completion: nil)
    }
    

    func setupTopBar() {
        let topBar = self.view.getViewWithTag(99)
        
        let topBarView = TopBarView()
        topBarView.backButton.addTarget(self, action: #selector(backAct), for: .touchUpInside)
        topBar.addSubview(topBarView)

        //Layout top bar
        NSLayoutConstraint.activate([
            topBarView.bottomAnchor.constraint(equalTo: topBar.bottomAnchor),
            topBarView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            topBarView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            topBarView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
        ])
    }
    
    func setupBottomBar() {
        self.bottomBar = self.view.getViewWithTag(100)
        
        let bottomContainer = UIView(frame: .zero)
        bottomContainer.backgroundColor = AppUtils.shared.MY_GREY
        bottomContainer.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.addSubview(bottomContainer)
        
        let bottomBarView = BottomBarView()
        bottomBarView.textButton.addTarget(self, action: #selector(addTextAct), for: .touchUpInside)
        bottomBarView.stickerButton.addTarget(self, action: #selector(stickerAct(_:)), for: .touchUpInside)
        bottomBarView.colorPickerButton.addTarget(self, action: #selector(colorPickAct(_:)), for: .touchUpInside)
        bottomBarView.saveButton.addTarget(self, action: #selector(downloadImageAct), for: .touchUpInside)

        bottomContainer.addSubview(bottomBarView)
        
        NSLayoutConstraint.activate([
            bottomContainer.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            bottomContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            bottomContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            bottomContainer.heightAnchor.constraint(equalToConstant: 60),
            
            bottomBarView.centerYAnchor.constraint(equalTo: bottomContainer.centerYAnchor),
            bottomBarView.centerXAnchor.constraint(equalTo: bottomContainer.centerXAnchor),
            bottomBarView.heightAnchor.constraint(equalTo: bottomContainer.heightAnchor, multiplier: 0.46),
            bottomBarView.leftAnchor.constraint(equalTo: bottomContainer.leftAnchor),
            bottomBarView.rightAnchor.constraint(equalTo: bottomContainer.rightAnchor),
        ])
    }
    
    func convertToRadian(degrees: CGFloat) -> CGFloat {
        return degrees * CGFloat.pi / 180
    }
    

    //MARK: - Set up ImageScrollView
    func imageSetUp() {
        guard numberOfFrames > 0 else { return }
        for i in 1...numberOfFrames {
            if let imgView: ImageScrollView = self.view.getViewWithTag(i) as? ImageScrollView {
                
                imgView.plusView = self.view.getViewWithTag(30 + i)
                imgView.movableMediaDelegate = self
                imgView.setup()

            }
        }
    }

    //MARK: - Download Action
    @IBAction func downloadImageAct() {
        saveCompletionHandler = nil
        self.downloadImage()
    }
    
    var saveCompletionHandler: (() -> Void)?
    var customAlert: SaveAlertController!
    
    func showExportingAlert() {
        let Board : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        self.customAlert = Board.instantiateViewController(withIdentifier: "Saved") as? SaveAlertController

        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve

        self.present(customAlert, animated: true, completion: nil)
    }
    
    func hideExportingAlert() {
        DispatchQueue.main.async {
            self.customAlert.dismissVc { [weak self] in
                guard let self = self else { return }
                if let completion = self.saveCompletionHandler {
                    completion()
                }
            }
        }
    }
        
    func downloadImage() {
        executePhotoLibraryCodeIfAuthorised {
            self.deselectSprite()
            self.isFrameEdited = false
            self.showExportingAlert()
            UIImageWriteToSavedPhotosAlbum(self.generateExportImage(), self, #selector(self.imageCompletionSelector(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    @objc func imageCompletionSelector(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeMutableRawPointer?) {
        if let error = error {
            print("Error Saving ARKit Scene \(error)")
        } else {
            print("ARKit Scene Successfully Saved")
            hideExportingAlert()
        }
    }
    
    func executePhotoLibraryCodeIfAuthorised(completion: (() -> Void)? = nil) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized, .limited:
            DispatchQueue.main.async {
                if let complete = completion { complete() }
            }
            break
        case .denied, .restricted, .notDetermined:
            requestAuthorisation(completion: completion)
            break
        }
    }
    
    func requestAuthorisation(completion: (() -> Void)? = nil) {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized, .limited:
                DispatchQueue.main.async {
                    if let complete = completion { complete() }
                }
                break
            case .denied, .restricted:
                let alert = UIAlertController(title: "Access Needed", message: "VideoApp requires permission to save your stories. Please allow read & write access in your privacy settings", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Don't Allow", style: .default))
                alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { action in
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }))
                
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
                break
            case .notDetermined:
                //Should not be reached
                assert(false, "Invalid authorisation for photo library")
                break
            }
        }
    }
    
    func generateExportImage() -> UIImage {
        let captureView = self.mainView!
        let captureViewBounds = captureView.bounds
        let rendererFormat = UIGraphicsImageRendererFormat.default()
        rendererFormat.scale = 4

        let renderer = UIGraphicsImageRenderer(bounds: captureViewBounds, format: rendererFormat)
        return renderer.image { rendererContext in
            captureView.layer.render(in: rendererContext.cgContext)
        }
    }
    
    //MARK: - Back Action
    @objc func backAct() {
        if isFrameEdited == true {
            
            let backAlert = PopupDialog(
                title: "Save this story to your gallery?",
                message: "Your edits will not be saved otherwise",
                buttonAlignment: .horizontal,
                transitionStyle: .zoomIn,
                preferredWidth: 200)
            

            let saveButton = CancelButton(title: "Save", height: 45, dismissOnTap: true ) { [weak self] in
                guard let self = self else { return }
                self.saveCompletionHandler = {
                    self.navigationController?.popViewController(animated: true)
                    self.imagePickerController = nil
                }
                self.downloadImage()
            }

            let deleteButton = DestructiveButton(title: "Delete", height: 45, dismissOnTap: true) { [weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async() {
                    self.navigationController?.popViewController(animated: true)
                    self.imagePickerController = nil
                }
            }

            backAlert.addButtons([saveButton, deleteButton])
            
            DispatchQueue.main.async {
                self.present(backAlert, animated: true, completion: nil)
            }
            
        } else {
            DispatchQueue.main.async() {
                self.navigationController?.popViewController(animated: true)
                self.imagePickerController = nil
            }
        }
    }
    
}

extension EditViewController: ColorPickerDelegate {
    
    //MARK: - Color Picker Action
    @IBAction func colorPickAct(_ sender: UIButton) {
        let board  = UIStoryboard.init(name: "Main", bundle: nil)
        let colorPickerViewController = board.instantiateViewController(withIdentifier: "ColorPickerViewController") as! ColorPickerViewController
        
        colorPickerViewController.delegate = self
        colorPickerViewController.hexColor = previousColor.hexString()
        colorPickerViewController.providesPresentationContextTransitionStyle = true
        colorPickerViewController.definesPresentationContext = true
        colorPickerViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        colorPickerViewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(colorPickerViewController, animated: true, completion: nil)
    }
    
    func selectColor(hexValue: String) {
        isFrameEdited = true
        let view1 = self.view.getViewWithTag(40)
        let view2 = self.view.getViewWithTag(41)
        let view3 = self.view.getViewWithTag(42)
        let view4 = self.view.getViewWithTag(43)
        let view5 = self.view.getViewWithTag(44)
        
        // remove image
        let imgViewT = self.view.getImageViewWithTag(210)
        imgViewT.isHidden = true
        
        DispatchQueue.main.async {
            
            if self.restorationIdentifier != "Eden5" {
                view1.backgroundColor = UIColor(hexString: hexValue)
            }
            view2.backgroundColor = UIColor(hexString: hexValue)
            view3.backgroundColor = UIColor(hexString: hexValue)
            view4.backgroundColor = UIColor(hexString: hexValue)
            view5.backgroundColor = UIColor(hexString: hexValue)
        }
    }
    
    func saveColor(hexValue: String) {
        UIView.animate(withDuration: 0.1, animations: {
            self.view.frame.origin.y = 0
        }, completion: nil)
        
        self.previousImageView = nil
        self.previousColor = UIColor(hexString: hexValue)
    }
    
    func cancelColor() {
        isFrameEdited = true
        
        if let previousImageView = self.previousImageView {
            previousImageView.isHidden = false
        }
        
        let view1 = self.view.getViewWithTag(40)
        let view2 = self.view.getViewWithTag(41)
        let view3 = self.view.getViewWithTag(42)
        let view4 = self.view.getViewWithTag(43)
        let view5 = self.view.getViewWithTag(44)
        
        UIView.animate(withDuration: 0.1, animations: {
            self.view.frame.origin.y = 0
        }, completion: nil)
        
        DispatchQueue.main.async {
            view1.backgroundColor = self.previousColor
            view2.backgroundColor = self.previousColor
            view3.backgroundColor = self.previousColor
            view4.backgroundColor = self.previousColor
            view5.backgroundColor = self.previousColor
        }
    }

}
