//
//  UIView-Extension.swift
//  NewGames
//
//  Created by Şükrü Özkoca on 14.11.2022.
//

import Foundation
import UIKit

extension UIView {
    func finishLevelView() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.red.cgColor
    }
}
