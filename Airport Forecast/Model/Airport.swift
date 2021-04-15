//
//  Airport.swift
//  Airport Forecast
//
//  Created by Raj Tailor on 4/14/21.
//  Copyright © 2021 Raj Tailor. All rights reserved.
//

import CoreData

class AirportCoreData: NSManagedObject {
    
    @NSManaged var airportName: String
    @NSManaged var lat: NSNumber
    @NSManaged var lon: NSNumber
    @NSManaged var speedKnts: NSNumber
    @NSManaged var tempC: NSNumber
    
    
    func updateStack(with jsonDictionary: [String: Any]) throws {
        guard let airportName = jsonDictionary["airportName"] as? String,
            let lat = jsonDictionary["lat"] as? Float,
            let lon = jsonDictionary["lon"] as? Float,
            let speedKnts = jsonDictionary["speedKnts"] as? Double,
            let tempC = jsonDictionary["tempC"] as? Double
            else {
                throw NSError(domain: "", code: 100, userInfo: nil)
        }
        
        self.airportName = airportName
        self.lat = NSNumber(value: lat)
        self.lon = NSNumber(value: lon)
        self.speedKnts = NSNumber(value: speedKnts)
        self.tempC = NSNumber(value: tempC)
 
    }

}
