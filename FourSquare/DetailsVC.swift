//
//  DetailsVC.swift
//  FourSquare
//
//  Created by Punhan Shahmurov on 08.04.25.
//

import UIKit
import MapKit
import ParseCore

class DetailsVC: UIViewController, MKMapViewDelegate {

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
        detailsMapLabel.delegate = self
        
         
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
                    
                    if let placeType = myObject["type"] as? String {
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
                    
                    self.createMapView()
                    
                }
                
            }
            
        }
        
    }
    
    func createMapView() {
        
        let location = CLLocationCoordinate2D(latitude: chosenLatitude, longitude: chosenLongitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        
        let region = MKCoordinateRegion(center: location, span: span)
        
        detailsMapLabel.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = location
        
        detailsMapLabel.addAnnotation(annotation)
        
        annotation.title = detailsNameLabel.text
        annotation.subtitle = detailsTypeLabel.text
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil {
            
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            pinView?.canShowCallout = true
            
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
            
        } else {
            
            pinView?.annotation = annotation
            
        }
        
        return pinView
        
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if self.chosenLongitude != 0.0 && self.chosenLatitude != 0.0 {
            
            let requestLocation = CLLocation(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
            
            CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarks, error) in
                
                if let placemark = placemarks {
                    if placemark.count > 0  {
                        
                        let mkPlacemark = MKPlacemark(placemark: placemark[0])
                        
                        let mapItem = MKMapItem(placemark: mkPlacemark)
                        
                        mapItem.name = self.detailsNameLabel.text
                        
                        let launchOptions: [String: Any] = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                        
                        mapItem.openInMaps(launchOptions: launchOptions)
                         
                        
                    }
                }
                
            }
            
        }
    }
     

}
