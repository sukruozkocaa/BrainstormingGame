//
//  GameViewController.swift
//  Games
//
//  Created by Şükrü Özkoca on 7.11.2022.
//

import UIKit

import Firebase
import FirebaseDatabase


class GameViewController: UIViewController {
    
    @IBOutlet weak var currentEmail: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var leaderBoardButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    
    private let database = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //getData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getData()
    }
    
    func getData() {
        
        let firestore = Firestore.firestore()
        
        firestore.collection("UserInfo").whereField("email", isEqualTo: Auth.auth().currentUser?.email).getDocuments { snapshot, error in
            if error != nil {
                print(error?.localizedDescription)
            }
            else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    for document in snapshot!.documents {
                        firestore.collection("UserInfo").addSnapshotListener { snapshot, error in
                            if error != nil {
                                print(error?.localizedDescription)
                            }
                            if let highscore = document.get("highScore") as? Int {
                                self.highScoreLabel.text = "High Score: \(highscore)"
                            }
                            if let email = document.get("email") as? String {
                                self.currentEmail.text = email
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    @IBAction func logOutClicked(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(vc, animated: true)
        } catch {
            print("abc")
        }
    }
    @IBAction func topListClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Game", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TopScoreViewController") as! TopScoreViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func playClicked(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LevelViewController") as! LevelViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
