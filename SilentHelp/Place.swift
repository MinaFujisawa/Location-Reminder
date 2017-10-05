//
//  SilentZone.swift
//  SilentHelp
//
//  Created by MINA FUJISAWA on 2017/10/04.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import Foundation
class Place :NSObject, NSCoding {
    var name: String
    var address: String
    init(name: String, address: String) {
        self.name = name
        self.address = address
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as! String;
        self.address = aDecoder.decodeObject(forKey: "address") as! String;
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.address, forKey: "address")
    }
    
}

//FOR DEMO
struct DemoSet {
    static func getDemoData() -> [Place] {
        let demoSilentZone = Place(name: "Somewhere", address: "450 Granville St, Vancouver, BC")
        let demoSilentZone2 = Place(name: "Somewhere2", address: "450 Granville St, Vancouver, BC")
        return [demoSilentZone, demoSilentZone2]
    }
}
