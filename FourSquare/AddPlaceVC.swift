//
//  AddPlaceVC.swift
//  FourSquare
//
//  Created by Punhan Shahmurov on 08.04.25.
//

import UIKit

class AddPlaceVC: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var typeLabel: UITextField!
    @IBOutlet weak var atmosphereLabel: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        imageView.isUserInteractionEnabled = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(gestureRecognizer)
        
    }
    
    @IBAction func nextStep(_ sender: UIButton) {
        
        if nameLabel.text != "" && typeLabel.text != "" && atmosphereLabel.text != "" {
            
            if let image = imageView.image {
                
                let placeModel = PlaceModel.shared
                placeModel.placeName = nameLabel.text ?? ""
                placeModel.placeType = typeLabel.text ?? ""
                placeModel.placeAtmosphere = atmosphereLabel.text ?? ""
                placeModel.placeImage = image
                
                performSegue(withIdentifier: "toMapVC", sender: nil)
            }
            
            
        } else {
            
            let alertController = UIAlertController(title: "Error", message: "Please fill all fields", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(alertAction)
            present(alertController, animated: true)
            
        }
        
        
    }
    
    @objc func imageTapped() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        dismiss(animated: true)
        
    }
    

}
