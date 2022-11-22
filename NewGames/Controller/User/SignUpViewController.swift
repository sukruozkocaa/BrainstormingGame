//
//  SignUpViewController.swift
//  Games
//
//  Created by Şükrü Özkoca on 5.11.2022.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordRetryTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var highScore = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradient = UIImage.gradientImage(bounds: signUpLabel.bounds, colors: [.systemBlue,.systemYellow])
        
        signUpLabel.textColor = UIColor(patternImage: gradient)
        signUpButton.layer.cornerRadius = 15
                                                                                  
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        if emailTextField.text != "" && passwordTextField.text == passwordRetryTextField.text {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { auth, error in
                if error != nil {
                    print(error?.localizedDescription)
                }
                else {
                    let firestore = Firestore.firestore()
                    
                    let userDictionary = ["email" : self.emailTextField.text!, "password" : self.passwordTextField.text!, "highScore" : self.highScore] as [String : Any]
                    
                    firestore.collection("UserInfo").addDocument(data: userDictionary) { error in
                        if error != nil {
                            print(error?.localizedDescription)
                        }
                        else {
                            print("Kayıt Başarılı")
                        }
                    }
                }
            }
        }
    }
    
}
