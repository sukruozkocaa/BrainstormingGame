//
//  GameViewModel.swift
//  NewGames
//
//  Created by Şükrü Özkoca on 16.11.2022.
//

import AVFoundation
import Firebase
import FirebaseFirestore
import FirebaseDatabase

class GameViewModel {
    static let shared = GameViewModel()
    
    var db: Firestore!
    
    var highscore: Int!
}
