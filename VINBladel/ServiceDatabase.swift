//
//  ServiceDatabase.swift
//  VIN-Bladel
//
//  Created by Joel Koreth on 5/1/18.
//  Copyright © 2018 John Hersey High School. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

var serviceReference = Database.database().reference().root.child("Services")

class ServiceDatabase{
    static var database: [Service] = []
    
    static func pullFromFirebase()
    {
        database.removeAll()
        serviceReference.observe(.value) { (snapshot) in
            for service in snapshot.children.allObjects as! [DataSnapshot]
            {
                let currentService = service.key
                if let price = service.value as? Double {
                    let newService = Service(name: currentService, price: price)
                    database.append(newService)
                }
            }
            database = database.sorted(by: {$0.name < $1.name})
        }
        
    }
    
    static func getPriceFor(serviceNamed: String) -> Double? {
        for service in database {
            if service.name == serviceNamed {
                return service.price
            }
        }
        return nil
    }
    
    
}
