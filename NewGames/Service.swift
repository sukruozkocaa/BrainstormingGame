//
//  Service.swift
//  NewGames
//
//  Created by Şükrü Özkoca on 14.11.2022.
//

import Foundation
import UIKit

class Service {
    static func createAlertController(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title:  "OK", style: .default) { (action) in
            alert.dismiss(animated: true,completion: nil)
        }
        
        alert.addAction(okAction)
        
        return alert
    }
    
    static func levelFinishAlertController(title:String,message:String,score: Int) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { UIAlertAction in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                LevelViewController().navigationController?.popViewController(animated: true)
            }
        }
        let retryButton = UIAlertAction(title: "Retry", style: .default) { UIAlertAction in
            LevelViewController().navigationController?.popViewController(animated: true)

        }
        alert.addAction(okButton)
        alert.addAction(retryButton)
        LevelViewController().present(alert, animated: true)
    }
}
