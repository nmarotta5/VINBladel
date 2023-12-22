//
//  TableComposer.swift
//  VIN-Bladel
//
//  Created by Robert D. Brown on 6/2/18.
//  Copyright © 2018 John Hersey High School. All rights reserved.
//

import UIKit

class TableComposer {
    
    let pathToTableHTMLTemplate = Bundle.main.path(forResource: "Table", ofType: "html")!
    var pdfFilename: String!
    
    init() {
        
    }
    
    
    func renderInvoice(partsUsed: [PartUsed]) -> String {
        
        do {
            var HTMLContent = try String(contentsOfFile: pathToTableHTMLTemplate)
            var counter = 1
            for part in partsUsed {
                let quantity = part.quantity
                let description = part.description
                let price = (part.price == "" ? part.price : "$" + part.price)
                let total = (part.total == "" ? part.total : "$" + part.total)
                
                HTMLContent = HTMLContent.replacingOccurrences(of: "#Q\(counter)#", with: quantity)
                HTMLContent = HTMLContent.replacingOccurrences(of: "#D\(counter)#", with: description)
                HTMLContent = HTMLContent.replacingOccurrences(of: "#P\(counter)#", with: price)
                HTMLContent = HTMLContent.replacingOccurrences(of: "#T\(counter)#", with: total)
                
                counter += 1
            }
            
            for _ in counter...16 {
                HTMLContent = HTMLContent.replacingOccurrences(of: "#Q\(counter)#", with: "")
                HTMLContent = HTMLContent.replacingOccurrences(of: "#D\(counter)#", with: "")
                HTMLContent = HTMLContent.replacingOccurrences(of: "#P\(counter)#", with: "")
                HTMLContent = HTMLContent.replacingOccurrences(of: "#T\(counter)#", with: "")
                
                counter += 1
            }
            

            return HTMLContent
        } catch {
            print("Unable to open and use HTML template files.")
        }
        
        return ""
    }
}

