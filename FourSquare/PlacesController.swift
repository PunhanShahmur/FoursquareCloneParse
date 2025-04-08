//
//  PlacesController.swift
//  FourSquare
//
//  Created by Punhan Shahmurov on 05.04.25.
//

import UIKit
import ParseCore

class PlacesController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var nameArray: [String] = []
    var idArray: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPlace))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logOut))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getData()
        
        print(nameArray)
        
    }
    
    func getData() {
        
        let query = PFQuery(className: "Places")
        query.findObjectsInBackground { (objects, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
    
            } else {
                
                if objects != nil {
                    
                    self.idArray.removeAll(keepingCapacity: false)
                    self.nameArray.removeAll(keepingCapacity: false)
                    
                    for item in objects! {
                        if let placeName = item.object(forKey: "name") as? String {
                            if let placeId = item.objectId {
                                self.nameArray.append(placeName)
                                self.idArray.append(placeId)
                            }
                        }
                    }
                    
                    self.tableView.reloadData()
                }
                
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return idArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.textLabel?.text = nameArray[indexPath.row]
        return cell
        
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        
//        
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        
//        
//        
//    }
    
    
    
    
    
    
    
    @objc func addPlace() {
        performSegue(withIdentifier: "toAddPlaceVC", sender: nil)
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
