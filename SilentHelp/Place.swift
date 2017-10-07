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
    var name: String
    var address: String?
    var lat : CLLocationDegrees
    var lon : CLLocationDegrees
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }

    init(name: String, address: String, lat:CLLocationDegrees, lon: CLLocationDegrees) {
        self.name = name
        self.address = address
        self.lat = lat
        self.lon = lon
    }

    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as! String;
        self.address = aDecoder.decodeObject(forKey: "address") as! String;
        self.lat = aDecoder.decodeDouble(forKey: "lat") as! CLLocationDegrees;
        self.lon = aDecoder.decodeDouble(forKey: "lon") as! CLLocationDegrees;
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.address, forKey: "address")
        aCoder.encode(self.lat, forKey: "lat")
        aCoder.encode(self.lon, forKey: "lon")
    }

}

struct PlaceSet {
    
    static func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: "silentZoneListUserDefaultKey")
        }
        defaults.synchronize()
    }
    
    static func getPlaceSetData() -> [Place] {
        
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "silentZoneListUserDefaultKey") != nil{
            return NSKeyedUnarchiver.unarchiveObject(with: defaults.object(forKey: "silentZoneListUserDefaultKey") as! Data) as! [Place]
        } else {
            return [Place]()
        }
    }
}

////FOR DEMO
//struct DemoSet {
//    static func getDemoData() -> [Place] {
//        let demoSilentZone = Place(name: "Somewhere", address: "450 Granville St, Vancouver, BC")
//        let demoSilentZone2 = Place(name: "Somewhere2", address: "450 Granville St, Vancouver, BC")
//        return [demoSilentZone, demoSilentZone2]
//    }
//}

