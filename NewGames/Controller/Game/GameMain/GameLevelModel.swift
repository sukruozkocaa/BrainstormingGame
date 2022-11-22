//
//  GameLevelModel.swift
//  NewGames
//
//  Created by Şükrü Özkoca on 14.11.2022.
//

import Foundation
import AVFoundation

class GameLevelModel {
   
    var audioPlayer: AVAudioPlayer?

    let level1 = ["ananas","armut","ananas","kavun","armut","kavun"]
    
    let level2 = ["elma","kavun","seftali","kavun","seftali","elma"]
    
    let level3 = ["avokado","portakal","seftali","elma","kavun","avokado","seftali","portakal","kavun","elma"]
    
    let level4 = ["ananas","armut","elma","kavun","seftali","muz","portakal","avokado","ananas","armut","elma","kavun","seftali","muz","portakal","avokado"]

    
    func succesSound() {
        
        let pathToSound = Bundle.main.path(forResource: "positive", ofType: "mp3")
        let url = URL(fileURLWithPath: pathToSound!)
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        }catch {
            print(error.localizedDescription)
        }
    }
}
