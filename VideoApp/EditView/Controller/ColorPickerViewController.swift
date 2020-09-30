//
//  ColorPickerViewController2.swift
//  VideoApp
//
//  Created by Lauren on 16/6/20.
//  Copyright © 2020 VideoApp. All rights reserved.
//

import UIKit

public protocol ColorPickerDelegate: class {
    func selectColor(hexValue : String)
    func cancelColor()
    func saveColor(hexValue : String)
}


class ColorPickerViewController: UIViewController {

    weak var delegate: ColorPickerDelegate?

    var hexColor = ""
    
    var isUsingOverlay = false

    @IBOutlet weak var paletteHeight: UIConstraintX!
    @IBOutlet weak var hsbaSliderGroup: HSBASliderGroup!
    @IBOutlet weak var colorStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hsbaSliderGroup.saturationSlider.barHeight = 7
        hsbaSliderGroup.brightnessSlider.barHeight = 7
        hsbaSliderGroup.borderWidth = 0
        paletteHeight.constant = setPaletteHeight()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.view.animShow()
        if hexColor != "" {
            self.multiColorAct(hexVal: hexColor)
        }
    }
    
    func setPaletteHeight() -> CGFloat {
        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436  {
            return 38.67
        }
        else if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 1792 {
            return 43.5
        }
        else if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 1136 {
            return 31.5
        }
        else if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 1334 {
            return 38.5
        }
        else if UIDevice().userInterfaceIdiom == .phone && (UIScreen.main.nativeBounds.height == 2208 || UIScreen.main.nativeBounds.height == 1920) {
            return 43.5
        }
        else if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2688 {
            return 43.33
        }
        return 0
    }

    @IBAction func color1(_ sender: Any) {
        self.multiColorAct(hexVal: "F0D2CD")
    }
    @IBAction func color2(_ sender: Any) {
        self.multiColorAct(hexVal: "AE9AC9")
    }
    @IBAction func color3(_ sender: Any) {
        self.multiColorAct(hexVal: "365888")
    }
    @IBAction func color4(_ sender: Any) {
        self.multiColorAct(hexVal: "BBCAD7")
    }
    @IBAction func color5(_ sender: Any) {
        self.multiColorAct(hexVal: "9BC78C")
    }
    @IBAction func color6(_ sender: Any) {
        self.multiColorAct(hexVal: "EEDD81")
    }
    @IBAction func color7(_ sender: Any) {
        self.multiColorAct(hexVal: "E88C6F")
    }
    @IBAction func color8(_ sender: Any) {
        self.multiColorAct(hexVal: "AD3232")
    }

    func multiColorAct(hexVal : String) {
        self.hsbaSliderGroup.color = UIColor(hexString: hexVal)
        self.updateBackgroundColor()
    }

    @IBAction func hsbaSliderGroupValueChanged(_ sender: HSBASliderGroup) {
        if !isUsingOverlay {
            updateBackgroundColor()
        }
    }
    
    @IBAction func hsbaSliderGroupTouchDown(_ sender: HSBASliderGroup) {
        updateBackgroundColor()
    }
    
    @IBAction func hsbaSliderGroupTouchUpInside(_ sender: HSBASliderGroup) {
        updateBackgroundColor()
    }
    
    func updateBackgroundColor() {
        self.delegate?.selectColor(hexValue: self.hsbaSliderGroup.color.hexString())
    }

    @IBAction func closeAct(_ sender: UIButton) {
        self.delegate?.cancelColor()
        self.view.animHide(currentView: self)
    }
    
    @IBAction func saveAct(_ sender: UIButton) {
        self.delegate?.selectColor(hexValue: self.hsbaSliderGroup.color.hexString())
        self.delegate?.saveColor(hexValue: self.hsbaSliderGroup.color.hexString())
        self.view.animHide(currentView: self)
    }
}

extension UIView {
    func animShow(){
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn],
                       animations: {
                        self.center.y -= self.bounds.height
                        self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
    }
    func animHide(currentView : UIViewController){
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear],
                       animations: {
                        self.center.y += self.bounds.height
                        self.layoutIfNeeded()

        },  completion: {(_ completed: Bool) -> Void in
            currentView.dismiss(animated: false, completion: nil)
        })
    }
}
