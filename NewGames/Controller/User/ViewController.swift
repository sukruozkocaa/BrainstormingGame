//
//  ViewController.swift
//  Games
//
//  Created by Şükrü Özkoca on 4.11.2022.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    let database = FirestoreDatabase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        emailTextField.text = "sukruozkoca19@hotmail.com"
        passwordTextField.text = "sukru1218"
        
        signButton.layer.cornerRadius = 25
        signButton.layer.backgroundColor = UIColor.green.cgColor
        
        signButton.layer.borderWidth = 5
        signButton.layer.borderColor = UIColor.systemPurple.cgColor
        
        signUpButton.layer.borderWidth = 5
        signUpButton.layer.borderColor = UIColor.systemPurple.cgColor
        
        signUpButton.layer.cornerRadius = 25
        signUpButton.layer.backgroundColor = UIColor.systemRed.cgColor
        
        let gradient = UIImage.gradientImage(bounds: titleLabel.bounds, colors: [.systemBlue,.systemRed])
        titleLabel.textColor = UIColor(patternImage: gradient)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: nil, action: nil)
    }
    
    @IBAction func SignInClicked(_ sender: Any) {
                
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else { return }
                
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            
            if let error = error as? NSError {
                
                switch AuthErrorCode.Code(rawValue: error.code) {
                    
                case .operationNotAllowed:
                    self.present(Service.createAlertController(title: "Error", message: error.localizedDescription), animated: true)
                    resetUserSetting()
                    break
                    
                case .userDisabled:
                    self.present(Service.createAlertController(title: "Error", message: error.localizedDescription), animated: true)
                    resetUserSetting()
                    break
                    
                case .wrongPassword:
                    self.present(Service.createAlertController(title: "Error", message: error.localizedDescription), animated: true)
                    resetUserSetting()
                    break
                    
                case .invalidEmail:
                    self.present(Service.createAlertController(title: "Error", message: error.localizedDescription), animated: true)
                    resetUserSetting()
                    break
                    
                default:
                    self.present(Service.createAlertController(title: "Error", message: error.localizedDescription), animated: true)
                    resetUserSetting()
                }
                
            } else {
                                
                let storyboard = UIStoryboard(name: "Game", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
                self.navigationController?.pushViewController(vc, animated: true)
                resetUserSetting()
                
            }
            
            func resetUserSetting() {
                self.emailTextField.clearTextField()
                self.passwordTextField.clearTextField()
            }
        }
    }

    @IBAction func signUpViewClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

