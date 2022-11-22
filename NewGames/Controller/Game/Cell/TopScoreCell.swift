//
//  TopScoreCell.swift
//  Games
//
//  Created by Şükrü Özkoca on 8.11.2022.
//

import UIKit

class TopScoreCell: UITableViewCell {

    @IBOutlet weak var orderSuccessLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(email: String, score: Int, order: Int) {
        emailLabel.text = email
        scoreLabel.text = "\(score) sn"
        orderSuccessLabel.text = "\(order+1)."
    }
}
