//
//  PlacesController.swift
//  FourSquare
//
//  Created by Punhan Shahmurov on 05.04.25.
//

import UIKit
import ParseCore

class PlacesController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPlace))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logOut))
        
    }
    
    @objc func addPlace() {
        
    }
    
    @objc func logOut() {

        PFUser.logOutInBackground { (error) in
            
            if error != nil {
                
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "")
                
            } else {
                
                self.performSegue(withIdentifier: "toLogIn", sender: nil)
                
            }
            
        }
        
    }
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true)
        
    }

}
