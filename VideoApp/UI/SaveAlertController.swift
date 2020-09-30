//
//  SaveAlertController.swift
//  VideoApp
//
//  Created by VideoApp on 1/6/19.
//  Copyright © 2019 VideoApp. All rights reserved.
//

import UIKit

class SaveAlertController: UIViewController {
    var isSavedAnimation = false
    
    @objc func dismissVc(completion: @escaping () -> Void) {
        let imgViewT = self.view.getLabelWithTag(11)
        imgViewT.text = "COMPLETED"
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.dismiss(animated: true) {
                completion()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0)
    }
}
