//
//  Extensions.swift
//  MyBoxMan
//
//  Created by Naqash on 7/10/18.
//  Copyright © 2018 Lecodeur. All rights reserved.
//

import UIKit

extension UILabel {
    @objc public var substituteFontName : String {
        get {
            return self.font.fontName;
        }
        set {
            let fontNameToTest = self.font.fontName.lowercased();
            var fontName = newValue;
            if fontNameToTest.range(of: "myboxman") != nil || fontNameToTest.range(of: "helveticaneue-bold") != nil {
                fontName = "MYBOXMAN";
            } else if fontNameToTest.range(of: "regular") != nil {
                fontName += "-Regular";
            } else if fontNameToTest.range(of: "bold") != nil {
                fontName += "-Bold";
            } else if fontNameToTest.range(of: "medium") != nil {
                fontName += "-Medium";
            } else if fontNameToTest.range(of: "light") != nil {
                fontName += "-Light";
            } else if fontNameToTest.range(of: "ultralight") != nil {
                fontName += "-UltraLight";
            } else {
                fontName = substituteFontName
            }
            self.font = UIFont(name: fontName, size: self.font.pointSize)
        }
    }
}
extension UINavigationController {
    func popToSpecificVC(viewController:UIViewController, animated:Bool) {
        var arrViewControllers:[UIViewController] = []
        arrViewControllers = self.viewControllers
        for vc:UIViewController in arrViewControllers {
            if(vc.isKind(of: viewController.classForCoder)){
                (self.popToViewController(vc, animated: animated))
                break
            }
        }
        
    }
    
    func backToViewController(viewController: Swift.AnyClass) {
        
        for element in viewControllers as Array {
            if element.isKind(of: viewController) {
                self.popToViewController(element, animated: true)
                break
            }
        }
    }
}
extension UITextView {
    
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
    
}
extension UIButton {
    @objc public var substituteFontName : String {
        get {
            return (self.titleLabel?.font.fontName)!
            
        }
        set {
            let fontNameToTest = self.titleLabel?.font.fontName.lowercased();
            var fontName = newValue;
            if fontNameToTest?.range(of: "myboxman") != nil || fontNameToTest?.range(of: "helveticaneue-bold") != nil {
                fontName = "MYBOXMAN";
            } else if fontNameToTest?.range(of: "regular") != nil {
                fontName += "-Regular";
            } else if fontNameToTest?.range(of: "bold") != nil {
                fontName += "-Bold";
            } else if fontNameToTest?.range(of: "medium") != nil {
                fontName += "-Medium";
            } else if fontNameToTest?.range(of: "light") != nil {
                fontName += "-Light";
            } else if fontNameToTest?.range(of: "ultralight") != nil {
                fontName += "-UltraLight";
            } else {
                fontName = substituteFontName
            }
            self.titleLabel?.font = UIFont(name: fontName, size: (self.titleLabel?.font.pointSize)!)
        }
    }
}
///////////////////////////////////////////////////////////////////////////////////////////

//                                    UIActionBlocks Extension

///////////////////////////////////////////////////////////////////////////////////////////
var ButtonBlockKey: UInt8 = 0
var ViewBlockKey: UInt8 = 1

typealias ActionBlock = () -> ()

class ActionBlockWrapper : NSObject {
    var block : ActionBlock
    init(block: @escaping ActionBlock) {
        self.block = block
    }
}

extension UIButton {
    func setAction(_ block: @escaping ActionBlock) {
        objc_setAssociatedObject(self, &ButtonBlockKey, ActionBlockWrapper(block: block), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        addTarget(self, action: #selector(UIButton.block_handleAction(_:)), for: .touchUpInside)
    }
    
    @objc func block_handleAction(_ sender: UIButton) {
        let wrapper = objc_getAssociatedObject(self, &ButtonBlockKey) as! ActionBlockWrapper
        wrapper.block()
    }
}
extension UIView {
    var heightConstraint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                $0.firstAttribute == .height && $0.relation == .equal
            })
        }
        set { setNeedsLayout() }
    }
    
    var widthConstraint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                $0.firstAttribute == .width && $0.relation == .equal
            })
        }
        set { setNeedsLayout() }
    }
    
    func addChildView(_ view: UIView) {
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    func setTapAction(_ block: @escaping ActionBlock) {
        objc_setAssociatedObject(self, &ViewBlockKey, ActionBlockWrapper(block: block), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UIView.tapAction(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    func getTextfieldWithTag(_ withTag:Int) -> UITextField
    {
        var button: UITextField = UITextField()
        if let theButton = self.viewWithTag(withTag) as? UITextField {
            button = theButton
        }
        
        return button
    }
    
    @objc func tapAction(_ sender: UITapGestureRecognizer) {
        let wrapper = objc_getAssociatedObject(self, &ViewBlockKey) as! ActionBlockWrapper
        wrapper.block()
    }
    
    func setLabelWithTag(_ text:String?, withTag:Int) -> UILabel
    {
        var label: UILabel = UILabel()
        if let theLabel = self.viewWithTag(withTag) as? UILabel {
            theLabel.text = text ?? ""
            label = theLabel
        }
        return label
    }
    func getLabelWithTag(_ withTag:Int) -> UILabel
    {
        var label: UILabel = UILabel()
        if let theLabel = self.viewWithTag(withTag) as? UILabel {
            label = theLabel
        }
        
        return label
    }
    func getButtonWithTag(_ withTag:Int) -> UIButton
    {
        var button: UIButton = UIButton()
        if let theButton = self.viewWithTag(withTag) as? UIButton {
            button = theButton
        }
        
        return button
    }
    func setImageWithTag(_ image:UIImage, withTag:Int){
        if let photo_bg = self.viewWithTag(withTag) as! UIImageView? {
            photo_bg.image = image
        }
    }
    func getViewWithTag(_ withTag:Int) -> UIView{
        var view: UIView = UIView()
        if let theView = self.viewWithTag(withTag) as UIView? {
            view = theView
        }
        
        return view
    }
    func getImageViewWithTag(_ withTag:Int) -> UIImageView{
        var imageView: UIImageView = UIImageView()
        if let theView = self.viewWithTag(withTag) as! UIImageView? {
            imageView = theView
        }
        
        return imageView
    }
    
    func getTextViewWithTag(_ withTag:Int) -> UITextView{
        var view: UITextView = UITextView()
        if let theView = self.viewWithTag(withTag) as! UITextView? {
            view = theView
        }
        
        return view
    }
    
    func getTextFieldWithTag(_ withTag:Int) -> UITextField{
        var view: UITextField = UITextField()
        if let theView = self.viewWithTag(withTag) as! UITextField? {
            view = theView
        }
        
        return view
    }
    
    func gone() {
        self.isHidden = true
        let heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        self.addConstraint(heightConstraint)
    }
}

extension UIImageView {
    func setImageFrom(link:String) {
        URLSession.shared.dataTask( with: URL(string:link)!, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                if let data = data {
                    
                    UIView.transition(with: self,
                                      duration:0.5,
                                      options: UIView.AnimationOptions.transitionCrossDissolve,
                                      animations: {  self.image = UIImage(data: data) },
                                      completion: nil)
                }
            }
        }).resume()
    }
    
}


///////////////////////////////////////////////////////////////////////////////////////////

//                                    UIColor Extension

///////////////////////////////////////////////////////////////////////////////////////////

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
//    func as1ptImage() -> UIImage {
//
//        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
//        let ctx = UIGraphicsGetCurrentContext()
//        self.setFill()
//        ctx!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return image!
//    }
//    convenience init(rgbaValue: UInt32) {
//        let red   = CGFloat((rgbaValue >> 24) & 0xff) / 255.0
//        let green = CGFloat((rgbaValue >> 16) & 0xff) / 255.0
//        let blue  = CGFloat((rgbaValue >>  8) & 0xff) / 255.0
//        let alpha = CGFloat((rgbaValue      ) & 0xff) / 255.0
//
//        self.init(red: red, green: green, blue: blue, alpha: alpha)
//    }
//
//
//    convenience init(hexString: String) {
//        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
//        var int = UInt32()
//        Scanner(string: hex).scanHexInt32(&int)
//        let a, r, g, b: UInt32
//        switch hex.characters.count {
//        case 3: // RGB (12-bit)
//            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
//        case 6: // RGB (24-bit)
//            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
//        case 8: // ARGB (32-bit)
//            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
//        default:
//            (a, r, g, b) = (1, 1, 1, 0)
//        }
//        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
//    }
//
//    //    func getMeansOfTrasportColors() -> UIColor
//    //    {
//    //        let selectedColor = UIColor(named: .turquoise)
//    //        let unSelectedColor = UIColor(named: .dimGrayText)
//    //
//    //        if self == selectedColor {
//    //            return unSelectedColor
//    //        }
//    //        else {
//    //            return selectedColor
//    //        }
//    //
//    //    }
}


///////////////////////////////////////////////////////////////////////////////////////////

//                                    Int Extension

///////////////////////////////////////////////////////////////////////////////////////////


extension Int {
    
    func toKiloMeters () -> Int {
        return (self/1000)
    }
    
}

///////////////////////////////////////////////////////////////////////////////////////////

//                                    DATE Extension

///////////////////////////////////////////////////////////////////////////////////////////


extension Date {
    
    var toMillis: Int64 {
        let nowDouble = timeIntervalSince1970
        return Int64(nowDouble*1000)
    }
    
    var timeDifference: Int64 {
        let currentTime = Date().toMillis
        let giveTime = toMillis
        return (giveTime - currentTime)/1000
    }
}


extension String {
    func lastCharacters(_ index: Int) -> String {
        return String(self.suffix(index))
    }
}
extension Double{
    
    func roundedToDigit(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func toKiloMetersDouble () -> Double {
        return (self/1000.0)
    }
    
    
}

extension UIViewController {
    
    func containerAddChildViewController(_ childViewController: UIViewController) {
        self.addChild(childViewController)
        self.view!.addSubview(childViewController.view!)
        childViewController.didMove(toParent: self)
    }
    func configureChildViewController(_ childController: UIViewController, onView: UIView?) {
        var holderView = self.view
        if let onView = onView {
            holderView = onView
        }
        addChild(childController)
        holderView?.addChildView(childController.view)
        childController.didMove(toParent: self)
    }
    
    func containerAddChildViewController(_ childViewController: UIViewController, withRootView rootView: UIView) {
        
        self.addChild(childViewController)
        rootView.addSubview(childViewController.view!)
        childViewController.didMove(toParent: self)
        
    }
    func containerRemoveChildViewController(_ childViewController: UIViewController) {
        // childViewController.willMove(toParentViewController: nil)
        childViewController.view!.removeFromSuperview()
        childViewController.removeFromParent()
    }
    
}

