//
//  Parts+Services.swift
//  VIN-Bladel
//
//  Created by Joel Koreth on 3/14/18.
//  Copyright © 2018 John Hersey High School. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

var partsReference = Database.database().reference().root.child("parts")

class PartsDatabase{
    static var dictionary = [String:[String:Double]]()
    static var database:[Part] = []
    static var partsUsed:[PartUsed] = []
    
    static func pullFromFirebase()
    {
        partsReference.observe(.value) { (snapshot) in
            for part in snapshot.children.allObjects as! [DataSnapshot]
            {
                let service = part.key
                if let object = part.value as? [String: Any] {
                    var tempData = [String:Double]()
                    for (partName,price) in object {
                        if let partPrice = Double("\(price)") {
                            tempData[partName] = partPrice
                            let newPart = Part(associatedService: service, partName: partName, partPrice: partPrice)
                            database.append(newPart)
                        }
                    }
                    dictionary[service] = tempData
                }
            }
        }
    }
    
    static func getPriceFor(partNamed: String) -> Double? {
        
        for part in database {
            
            if part.partName == partNamed {
                return part.partPrice
            }
        }
        return nil
    }
}
