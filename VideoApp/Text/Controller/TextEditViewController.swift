//
//  TextEditViewController.swift
//  VideoApp
//
//  Created by Lauren on 13/10/19.
//  Copyright © 2019 VideoApp. All rights reserved.
//

import UIKit
import UIFontComplete

protocol TextEditDelegate: class {
    func updateTextSprite(with model : TextModel)
}

class TextEditViewController: UIViewController, UITextFieldDelegate {
    
    weak public var delegate: TextEditDelegate?
    
    @IBOutlet weak var textEditView: EditingTextView!
    @IBOutlet var toolbarView: UIView!
    @IBOutlet weak var bottomToolbar: UIView!
    @IBOutlet weak var bottomStackView: UIStackView!
    private var fontContainer: FontContainer!
    
    @IBOutlet weak var colorImage: UIImageView!
    @IBOutlet weak var doneImage: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    
    private var keyboardHeight: CGFloat?
    private var textModel = TextModel()

    private var currentFontButtonView: FontButtonView?
    
    private var previousFontSize: CGFloat!
    private var previousTextColor: UIColor!
    
    private var isFirstLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextField()
        setupFontContainer()
        setupToolbar()
        
        NotificationCenter.default.addObserver( self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textEditView.becomeFirstResponder()
    }

    public func setTextModel(with model: TextModel) {
        self.textModel = model
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }
    }
    
    // MARK: - Setup views
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        textEditView.isEditable = true
        textEditView.inputAccessoryView = toolbarView
        textEditView.keyboardAppearance = .dark
        textEditView.tintColor = .white
        textEditView.becomeFirstResponder()
        DispatchQueue.main.async {
            self.textEditView.selectAll(nil)
        }
        let coveredHeight = keyboardHeight! + toolbarView.frame.height
        let textViewX = textEditView.frame.origin.x
        let textViewY = textEditView.frame.origin.y
        let textViewWidth = textEditView.frame.width
        let viewHeight = self.view.frame.height
        let textViewHeight = viewHeight - coveredHeight - 40

        textEditView.frame = CGRect(x: textViewX, y: textViewY, width: textViewWidth, height: textViewHeight)
        
    }
    
    private func setupTextField() {
        textEditView.attributedText = textModel.attributedText
        // Set font to 20 so that it is readable in textview. Will set to original font size when done editing
        textEditView.font = textModel.attributedText.font?.withSize(20)
        textEditView.currentTypingAttributes = textEditView.typingAttributes
        updateBackgroundToContrastWithText()
    }
    
    private func setupFontContainer() {
        self.fontContainer = FontContainer()
        toolbarView.addSubview(fontContainer)
        NSLayoutConstraint.activate([
            fontContainer.topAnchor.constraint(equalTo: toolbarView.topAnchor),
            fontContainer.bottomAnchor.constraint(equalTo: bottomToolbar.topAnchor),
            fontContainer.leadingAnchor.constraint(equalTo: toolbarView.leadingAnchor),
            fontContainer.trailingAnchor.constraint(equalTo: toolbarView.trailingAnchor),
        ])
        
        for (index, fontButtonView) in fontContainer.containerStackView.arrangedSubviews.enumerated() {
            let fontButtonView = fontButtonView as! FontButtonView
            fontButtonView.button.addTarget(self, action: #selector(changeFontAct(_:)), for: .touchUpInside)
            fontButtonView.button.tag = index
        }
        
        setCurrentSelectedFont()
    }
    
    private func setCurrentSelectedFont() {
        var selectedFontButtonView = fontContainer.firstFontButton
        if let fontButtonViews = fontContainer.containerStackView.subviews as? [FontButtonView] {

            // Check if font is a part of the font packs
            selectedFontButtonView = fontButtonViews.first(where: {
                $0.fontModel.font?.fontName == textModel.attributedText.font?.fontName
            })
            
            // If selected font not found, check bold fonts
            if selectedFontButtonView == nil {
                selectedFontButtonView = fontButtonViews.first(where: {
                    return $0.fontModel.boldFont?.fontName == textModel.attributedText.font?.fontName
                })
            }

            // If selected font still not found
            if selectedFontButtonView == nil {
                print("[TextEditViewController] \(textModel.attributedText.font!.fontName) is not in font pack")
            }
        }
        
        self.currentFontButtonView = selectedFontButtonView
        currentFontButtonView?.isUserInteractionEnabled = false
        currentFontButtonView?.underline.isHidden = false
    }
    
    private func setupToolbar() {
        self.isFirstLoad = false
    }
    
    // MARK: - Toolbar actions
    
//    @objc func changeFontAct(_ fontButtonView: FontButtonView) {
    @objc private func changeFontAct(_ sender: UIButton) {
        let fontButtonView = fontContainer.containerStackView.arrangedSubviews[sender.tag] as! FontButtonView
        //MARK: IAP for Fonts
        // TODO: Update if fonts can buy individually
        if let chosenFont = fontButtonView.fontModel.font {
            let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
            selectionFeedbackGenerator.prepare()
            selectionFeedbackGenerator.selectionChanged()
            textEditView.setFont(chosenFont)
        }

        if let current = currentFontButtonView {
            current.isUserInteractionEnabled = true
            current.underline.isHidden = true
        }
        
        fontButtonView.isUserInteractionEnabled = false
        fontButtonView.underline.isHidden = false
        self.currentFontButtonView = fontButtonView
    }
    
    @IBAction private func changeTextColorAct(_ sender: Any) {

        self.view.endEditing(true)
        let board  = UIStoryboard.init(name: "Main", bundle: nil)
        let colorPickerViewController = board.instantiateViewController(withIdentifier: "ColorPickerViewController") as! ColorPickerViewController
        
        self.previousTextColor = textEditView.currentTypingAttributes[NSAttributedString.Key.foregroundColor] as? UIColor
        colorPickerViewController.hexColor = previousTextColor.hexString()
        
        colorPickerViewController.delegate = self
        colorPickerViewController.modalPresentationStyle = .overCurrentContext
        UIView.animate(withDuration: 0.3) {
            self.cancelButton.alpha = 0
        }
        self.present(colorPickerViewController, animated: false, completion: nil)
    }
    
    @IBAction private func cancelAct(_ sender: Any) {
        textEditView.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Text edit delegate
    
    @IBAction private func doneEditingAct(_ sender: Any) {
        updateTextModel()
        delegate?.updateTextSprite(with: textModel)
        textEditView.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }

    private func updateTextModel() {
        textModel.attributedText = textEditView.attributedText
    }
    
}

extension TextEditViewController: ColorPickerDelegate {
    
    func selectColor(hexValue: String) {
        textEditView.setTextColor(to: UIColor(hexString: hexValue))
        updateBackgroundToContrastWithText()
    }
    
    func saveColor(hexValue: String) {
        self.textEditView.becomeFirstResponder()
        UIView.animate(withDuration: 0.3) {
            self.cancelButton.alpha = 1
        }
    }
    
    func cancelColor() {
        UIView.animate(withDuration: 0.3) {
            self.cancelButton.alpha = 1
        }
        textEditView.setTextColor(to: previousTextColor)
        updateBackgroundToContrastWithText()
        textEditView.becomeFirstResponder()
    }
    
    func updateBackgroundToContrastWithText() {
        if let textColor = textEditView.attributedText.foregroundColor {
            UIView.animate(withDuration: 0.3) {
                if textColor.hexString() < "777777" {
                    self.view.backgroundColor = UIColor(hue: 205/360, saturation: 0.14, brightness: 0.58, alpha: 0.9)
                } else {
                    self.view.backgroundColor = UIColor(hue: 205/360, saturation: 0.14, brightness: 0.20, alpha: 0.9)
                }
            }
        }
    }
    
}
