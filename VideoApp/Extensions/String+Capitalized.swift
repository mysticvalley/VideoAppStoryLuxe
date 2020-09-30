//
//  String+Capitalized.swift
//  VideoApp
//
//  Created by Lauren on 22/5/20.
//  Copyright © 2020 VideoApp. All rights reserved.
//

import Foundation
extension String {
    func capitalizedFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizedFirstLetter()
    }
}
