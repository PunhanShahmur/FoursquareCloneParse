//
//  MapVC.swift
//  FourSquare
//
//  Created by Punhan Shahmurov on 08.04.25.
//

import UIKit
import MapKit
import ParseCore

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonClicked))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(cancelButtonClicked))
        
            
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotation(gestureRecognizer:)))
        recognizer.minimumPressDuration = 2
        mapView.addGestureRecognizer(recognizer)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        
        let region = MKCoordinateRegion(center: location, span: span)
        
        mapView.setRegion(region, animated: true)
        
        
        
    }
    
    @objc func addAnnotation(gestureRecognizer: UIGestureRecognizer) {
        
        if gestureRecognizer.state != .began {
            
            let touches = gestureRecognizer.location(in: mapView)
            let coordinates = mapView.convert(touches, toCoordinateFrom: mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = PlaceModel.shared.placeName
            annotation.subtitle = PlaceModel.shared.placeType
            
            mapView.addAnnotation(annotation)
            
            PlaceModel.shared.placeLatitude = String(coordinates.latitude)
            PlaceModel.shared.placeLongitude = String(coordinates.longitude)
            
        }
        
    }
    
    
    @objc func saveButtonClicked() {
        
        let placeModel = PlaceModel.shared
        
        let object = PFObject(className: "Places")
        object["name"] = placeModel.placeName
        object["type"] = placeModel.placeType
        object["atmosphere"] = placeModel.placeAtmosphere
        object["latitude"] = placeModel.placeLatitude
        object["longitude"] = placeModel.placeLongitude
        
        if let imageData = placeModel.placeImage?.jpegData(compressionQuality: 0.1) {
            object["image"] = PFFileObject(name: "image-\(UUID().uuidString).jpg", data: imageData)
        }
        
        object.saveInBackground { (success, error) in
            if error != nil {
                
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
                
            } else {
                
                self.performSegue(withIdentifier: "toTableView", sender: self)
                
            }
        }
        
    }
    
    @objc func cancelButtonClicked() {
        dismiss(animated: true, completion: nil)
    }


}
