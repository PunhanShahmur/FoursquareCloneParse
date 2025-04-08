import Foundation
import UIKit


class PlaceModel {
    
    //Singleton
    static let shared = PlaceModel()
    
    var placeName = ""
    var placeType = ""
    var placeAtmosphere = ""
    var placeImage: UIImage?
    var placeLongitude: String?
    var placeLatitude: String?
    
    
    
}
