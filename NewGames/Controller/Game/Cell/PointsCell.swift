//
//  PointsCell.swift
//  Games
//
//  Created by Şükrü Özkoca on 8.11.2022.
//

import UIKit


class PointsCell: UICollectionViewCell {

    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var lock: UIView!
    @IBOutlet weak var lockImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        gameImage.layer.cornerRadius = gameImage.frame.size.width / 2.1
        gameImage.clipsToBounds = true
    }
    
    func configure(lockHidden: Bool, gameHidden: Bool) {
        gameImage.isHidden = gameHidden
        lock.isHidden = !gameImage.isHidden
        
        if gameHidden == true {
            UIView.animate(withDuration: 0.3) {
                self.gameImage.alpha = 0
                self.lockImage.alpha = 1
            }
        }
        
        else {
            UIView.animate(withDuration: 0.3) {
                self.gameImage.alpha = 1
                self.gameImage.layer.borderWidth = 2
                self.lockImage.alpha = 0
            }
        }
    }
    
    func borderConfigure(isColor: Bool) {
        
        if isColor == true {
            self.gameImage.layer.borderColor = UIColor.green.cgColor
        }
        else {
            self.gameImage.layer.borderColor = UIColor.red.cgColor
        }
    }
}

