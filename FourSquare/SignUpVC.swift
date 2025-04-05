//
//  ViewController.swift
//  FourSquare
//
//  Created by Punhan Shahmurov on 05.04.25.
//

import UIKit
import ParseCore

class SignUpVC: UIViewController {
    
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    @IBAction func signInClicked(_ sender: Any) {
    
        if usernameLabel.text!.isEmpty || passwordLabel.text!.isEmpty {
            
            makeAlert(title: "Error", message: "Username or password is empty")
            
        } else {
            
            PFUser.logInWithUsername(inBackground: usernameLabel.text!, password: passwordLabel.text!) { (user, error) in
                
                if error != nil {
                
                    self.makeAlert(title: "Error", message: error!.localizedDescription)
                    
                } else {
                        
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                    
                }
                                  
            }
            
        }
        
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if usernameLabel.text!.isEmpty || passwordLabel.text!.isEmpty {
        
            makeAlert(title: "Error", message: "Username or password is empty")
            
        } else {
            
            let user = PFUser()
            
            user.username = usernameLabel.text
            user.password = passwordLabel.text
            user.signUpInBackground() { (success, error) in
                
                if error != nil {
                    
                    self.makeAlert(title: "Error", message: error!.localizedDescription)
                     
                    
                } else {
                    
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                    
                }
            }
            
        }
        
    }
    
    func makeAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        
    }
}

