//
//  TopScoreViewController.swift
//  Games
//
//  Created by Şükrü Özkoca on 8.11.2022.
//

import UIKit
import Firebase
import FirebaseFirestore


class TopScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    var usersList: [String] = []
    var usersScore: [Int] = []
    
    var scoreFilter: [Int] = []
    
    var sortUser: [String] = []
    var sortScore: [Int] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "TopScoreCell", bundle: nil), forCellReuseIdentifier: "TopScoreCell")
        getData()
    }
    
    func getData() {
        let firestore = Firestore.firestore()
        firestore.collection("UserInfo").addSnapshotListener { snapshot, error in
            if error != nil {
                print(error?.localizedDescription)
            }
            else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    for document in snapshot!.documents {
                        if let score = document.get("highScore") as? Int {
                            if let users = document.get("email") as? String {
                                
                                self.usersList.append(users)
                                self.usersScore.append(score)
                                
                                self.tableView.delegate = self
                                self.tableView.dataSource = self
                            }
                        }
                        
                        self.scoreFilter = self.usersScore.filter {$0 != 0}

                        let scoreOffset = self.scoreFilter.enumerated().sorted {$1.element < $0.element}.map {$0.offset}
                        
                        self.sortUser = scoreOffset.map{ self.usersList[$0]}
                        
                        self.sortScore = self.scoreFilter.sorted()
                     
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sortScore.count < 10 {
            return sortScore.count
        }
        else {
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: TopScoreCell = tableView.dequeueReusableCell(withIdentifier: "TopScoreCell", for: indexPath) as? TopScoreCell else { return UITableViewCell() }
        cell.configure(email: sortUser[indexPath.row], score: sortScore[indexPath.row],order: indexPath.row)
        return cell
    }
}
