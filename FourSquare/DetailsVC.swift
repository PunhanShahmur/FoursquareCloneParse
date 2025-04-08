//
//  DetailsVC.swift
//  FourSquare
//
//  Created by Punhan Shahmurov on 08.04.25.
//

import UIKit
import MapKit
import ParseCore

class DetailsVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var detailsNameLabel: UILabel!
    @IBOutlet weak var detailsTypeLabel: UILabel!
    @IBOutlet weak var detailsAtmosphereLabel: UILabel!
    @IBOutlet weak var detailsMapLabel: MKMapView!
   
    var chosenId: String = ""
    
    var chosenLatitude: Double = 0
    var chosenLongitude: Double = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        getData()
        
         
    }
    
    func getData() {
        
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: chosenId)
        query.findObjectsInBackground { (objects, error) in
         
            if error != nil {
                
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
                
            } else {
                
                if objects != nil {
                    
                    let myObject = objects![0]
                    
                    if let placeName = myObject["name"] as? String {
                        self.detailsNameLabel.text = placeName
                    }
                    
                    if let placeType = myObject["category"] as? String {
                        self.detailsTypeLabel.text = placeType
                    }
                    
                    if let placeAtmosphere = myObject["atmosphere"] as? String {
                        self.detailsAtmosphereLabel.text = placeAtmosphere
                    }
                    
                    if let placeLatitude = myObject["latitude"] as? String,
                       let placeLongitude = myObject["longitude"] as? String {
                        
                        if let placeLatitudeDouble = Double(placeLatitude),
                           let placeLongitudeDouble = Double(placeLongitude) {
                            
                            self.chosenLatitude = placeLatitudeDouble
                            self.chosenLongitude = placeLongitudeDouble
                        }
                        
                    }
                    
                    if let imageData = myObject["image"] as? PFFileObject {
                        imageData.getDataInBackground { (imageData, error) in
                            if imageData != nil {
                                self.imageView.image = UIImage(data: imageData!)
                            }
                        }
                    }
                    
                }
                
            }
            
        }
        
    }
     

}
