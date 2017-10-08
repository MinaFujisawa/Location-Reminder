//
//  SilentZone.swift
//  SilentHelp
//
//  Created by MINA FUJISAWA on 2017/10/04.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import Foundation
import GooglePlaces

class Place :NSObject, NSCoding {
    var comment: String
    var placeName: String
    var fullAddress: String?
    var lat : CLLocationDegrees
    var lon : CLLocationDegrees
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }

    init(comment: String, placeName:String, fullAddress: String, lat:CLLocationDegrees, lon: CLLocationDegrees) {
        self.comment = comment
        self.placeName = placeName
        self.fullAddress = fullAddress
        self.lat = lat
        self.lon = lon
    }

    required init?(coder aDecoder: NSCoder) {
        self.comment = aDecoder.decodeObject(forKey: "comment") as! String;
        self.placeName = aDecoder.decodeObject(forKey: "placeName") as! String;
        self.fullAddress = aDecoder.decodeObject(forKey: "fullAddress") as! String;
        self.lat = aDecoder.decodeDouble(forKey: "lat") as! CLLocationDegrees;
        self.lon = aDecoder.decodeDouble(forKey: "lon") as! CLLocationDegrees;
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.comment, forKey: "comment")
        aCoder.encode(self.placeName, forKey: "placeName")
        aCoder.encode(self.fullAddress, forKey: "fullAddress")
        aCoder.encode(self.lat, forKey: "lat")
        aCoder.encode(self.lon, forKey: "lon")
    }

}

struct PlaceSet {
    let placeListKey:String = placeListViewController().placeListKey
    static func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: "placeListUserDefaultKey")
        }
        defaults.synchronize()
    }
    
    static func getPlaceSetData() -> [Place] {
        
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "placeListUserDefaultKey") != nil{
            return NSKeyedUnarchiver.unarchiveObject(with: defaults.object(forKey: "placeListUserDefaultKey") as! Data) as! [Place]
        } else {
            return [Place]()
        }
    }
}

