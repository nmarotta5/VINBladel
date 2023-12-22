//
//  PartOrService.swift
//  VIN-Bladel
//
//  Created by Joel Koreth on 3/14/18.
//  Copyright © 2018 John Hersey High School. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class Part
{
    var associatedService: String!
    var partName: String!
    var partPrice: Double!
    var beenChecked: Bool!
    var quantity: Double
    
    init(associatedService: String, partName: String, partPrice: Double!) {
        self.associatedService = associatedService
        self.partName = partName
        self.partPrice = partPrice
        self.beenChecked = false
        self.quantity = 1.0
    }
}
