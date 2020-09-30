//
//  MenuVC.swift
//  VideoApp
//
//  Created by Lauren on 21/05/20.
//  Copyright © 2020 VideoApp. All rights reserved.
//

import UIKit
import SafariServices

class AppUtils: NSObject, UIActionSheetDelegate {
    public let isSeBounds = UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 1136
    public let MY_GREY = UIColor(hexString: "202427")
    
    // User Default Strings
    private let baseAddress = "https://www.videoappstories.app"
        
    private var defaults = UserDefaults.standard
    
    //Singleton
    static let shared = AppUtils()
    private override init() { }

    class func displayAlert(message:String,title:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }

    // set space between lines of a UILabel
    func setLabelLineSpacing(label : UILabel,  space : CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = space
        let attrString = NSMutableAttributedString(string: label.text!)
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        label.attributedText = attrString
        label.textAlignment = .center
    }
    
    private func showWeb(url: String, on viewController: UIViewController) {
        if let url = URL(string: url) {
            let vc : SFSafariViewController!
            
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            vc = SFSafariViewController(url: url, configuration: config)
            viewController.present(vc, animated: true)
        }
    }
    
    public func showAbout(on viewController: UIViewController) {
        showWeb(url: "\(baseAddress)/about", on: viewController)
    }
    
    public func showCredits(on viewController: UIViewController) {
        showWeb(url: "\(baseAddress)/credits", on: viewController)
    }
    
    public func showTerms(on viewController: UIViewController) {
        showWeb(url: "\(baseAddress)/terms", on: viewController)
    }
    
    public func showPrivacy(on viewController: UIViewController) {
        showWeb(url: "\(baseAddress)/privacy", on: viewController)
    }
    
    public func showBilling(on viewController: UIViewController) {
        showWeb(url: "https://apps.apple.com/account/billing", on: viewController)
    }
    
    // For Facebook:
    // let appURL = URL(string: "fb://profile/\(Username)")!
    func openInstagram(on viewController: UIViewController) {
        let username =  "videoapp_123" // Your Instagram Username here
        let appURL = URL(string: "instagram://user?username=\(username)")!
        let application = UIApplication.shared

        if application.canOpenURL(appURL) {
            application.open(appURL, options: [:], completionHandler: nil)
        } else {
            // if Instagram app is not installed, open URL inside Safari
            showWeb(url: "https://instagram.com/\(username)", on: viewController)
        }
    }
    
}
