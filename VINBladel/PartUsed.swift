//
//  TableStorage.swift
//  VIN-Bladel
//
//  Created by Robert D. Brown on 6/2/18.
//  Copyright © 2018 John Hersey High School. All rights reserved.
//

import Foundation

class PartUsed {
    var quantity: String = ""
    var description: String = ""
    var price: String = ""
    var total: String = ""
    
    init(quantity: String, description: String, price: String, total: String) {
        self.quantity = quantity
        self.description = description
        self.price = price
        self.total = total
    }
}
