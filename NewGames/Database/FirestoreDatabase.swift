//
//  FirestoreDatabase.swift
//  NewGames
//
//  Created by Şükrü Özkoca on 17.11.2022.
//

import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import UIKit

class FirestoreDatabase {
    private let firebaseDb = Firestore.firestore()
    
    var durum: Int?
    
    func getHighScore() {
        firebaseDb.collection("UserInfo").whereField("email", isEqualTo: Auth.auth().currentUser?.email).getDocuments { snapshot, error in
            if error != nil {
                print(error?.localizedDescription)
            }
            else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    for document in snapshot!.documents {
                        self.firebaseDb.collection("UserInfo").addSnapshotListener { snapshot, error in
                            if let highscore = document.get("highScore") as? Int {
                                self.durum = highscore
                              //  self.sendData()
                            }
                        }
                    }
                }
            }
        }
    }

}

/*
extension FirestoreDatabase: TodoDB {
    func add(usingTodoItem todoItem: TodoItem) -> Bool {
        
        do{
           let ref =  try firebaseDb.collection(todosCollection)
                .addDocument(from: todoItem)
            print("Add Document \(ref.documentID)")
        }
        catch let error{
            print("Add Document failed: \(error)")
            return false
        }
        return true
        
      
    }
    
    func update(usingTodoItem todoItem: TodoItem) {
        firebaseDb
            .collection(todosCollection)
            .whereField("email", isEqualTo: todoItem.email)
            .getDocuments { snapshot, error in
                if error != nil {
                    print(error!.localizedDescription)
                }
                else {
                   
                    if let document = snapshot?.documents.first {
                        
                        do {
                            try document.reference.setData(from: todoItem)
                        }
                        catch let error {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
    }
    
    func delete(usingMail mail: String) {
        //DELETE USER FALAN FİLAN GELECEK
    }
}
 */
