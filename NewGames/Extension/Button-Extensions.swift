//
//  Button-Extensions.swift
//  NewGames
//
//  Created by Şükrü Özkoca on 14.11.2022.
//

import Foundation
import UIKit

extension UIButton {
    func gameButton() {
        self.backgroundColor = UIColor.orange
        self.tintColor = UIColor.white
        self.layer.cornerRadius = 15
        self.layer.style = .none
        self.titleLabel?.font = UIFont(name: "AvenirNextCondensed-Heavy", size: 30)!
    }
}
