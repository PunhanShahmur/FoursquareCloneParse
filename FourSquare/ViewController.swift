//
//  ViewController.swift
//  FourSquare
//
//  Created by Punhan Shahmurov on 05.04.25.
//

import UIKit
import ParseCore

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let parseObject = PFObject(className: "Fruits")
        parseObject["name"] = "Apple"
        parseObject["calories"] = 95
        
        //Save async olmalidi
        
        parseObject.saveInBackground { (success, error) in
            
            
        }
        
        let query = PFQuery(className: "Fruits")
        query.whereKey("calories", greaterThan: 100)
        query.findObjectsInBackground() { (objects, error) in
            
            if error != nil {
                self.makeAlert(title: "ERROR", message: error?.localizedDescription ?? "Error")
            } else {
                print(objects ?? "wda")
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

