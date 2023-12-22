//
//  InvoiceComposer.swift
//  VIN-Bladel
//
//  Created by Olivia Marunde on 3/14/18.
//  Copyright © 2018 John Hersey High School. All rights reserved.
//

import UIKit

class InvoiceComposer {
    
    let pathToInvoiceHTMLTemplate = Bundle.main.path(forResource: "ServiceRecord", ofType: "html")
    let herseyLogoImageURL = "https://brownmm.github.io/HerseyLogo.png"
    let aseLogoImageURL = "https://brownmm.github.io/ASELogo.png"
    let twitterLogoImageURL = "https://brownmm.github.io/@HerseyAuto.png"
    var pdfFilename: String!
    var vehicleDatabase = VehicleDatabase.database
    
    let userDefaults = UserDefaults.standard
    
    init() {
        
    }

    func renderInvoice(customer: CustomerData, partList: [PartUsed]) -> String! {
        do {
            var HTMLContent = try String(contentsOfFile: pathToInvoiceHTMLTemplate!)
            
            let name = "\(customer.customerFirst!) \(customer.customerLast!)"
            HTMLContent = HTMLContent.replacingOccurrences(of: "#NAME#", with: name)
            
            let interval = TimeInterval(exactly: 0)
            let date = Date(timeIntervalSinceNow: interval!)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-YY"
            let dateString = dateFormatter.string(from: date)
            HTMLContent = HTMLContent.replacingOccurrences(of: "#DATE#", with: dateString)
            
            let make = userDefaults.object(forKey: "Make") as! String
            HTMLContent = HTMLContent.replacingOccurrences(of: "#MAKE#", with: make)
            
            let model = userDefaults.object(forKey: "Model") as! String
            HTMLContent = HTMLContent.replacingOccurrences(of: "#MODEL#", with: model)
            
            let year = userDefaults.object(forKey: "Year") as! String
            HTMLContent = HTMLContent.replacingOccurrences(of: "#YEAR#", with: year)
            
            let mileage = userDefaults.object(forKey: "Mileage") as! String
            HTMLContent = HTMLContent.replacingOccurrences(of: "#MILEAGE#", with: mileage)
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#HERSEY_LOGO_IMAGE#", with: herseyLogoImageURL)
            HTMLContent = HTMLContent.replacingOccurrences(of: "#ASE_LOGO_IMAGE#", with: aseLogoImageURL)
            HTMLContent = HTMLContent.replacingOccurrences(of: "#TWITTER#", with: twitterLogoImageURL)
            
            
            var counter = 1
            var totalCost:Double = 0
            for part in partList {
                let quantity = part.quantity
                let description = part.description
                let price = (part.price == "" ? part.price : "$" + part.price)
                let total = (part.total == "" ? part.total : "$" + part.total)
                
                if let total = Double(part.total) {
                    totalCost += total
                }
                
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
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#TOTAL#", with: "$" + String(format: "%.2f", totalCost))
            
            return HTMLContent
        } catch {
            print("Unable to open and use HTML template files.")
        }
        
        return nil
    }
    
    func exportHTMLContentToPDF(HTMLContent: String) {
        let printPageRenderer = CustomPrintPageRenderer()
        
        let printFormatter = UIMarkupTextPrintFormatter(markupText: HTMLContent)
        printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
        
        let pdfData = drawPDFUsingPrintPageRenderer(printPageRenderer: printPageRenderer)
        
        pdfFilename = "\(AppDelegate.getAppDelegate().getDocDir())/ServiceRecord.pdf"
        pdfData?.write(toFile: pdfFilename, atomically: true)
    }
    
    
    func drawPDFUsingPrintPageRenderer(printPageRenderer: UIPrintPageRenderer) -> NSData! {
        let data = NSMutableData()
        
        UIGraphicsBeginPDFContextToData(data, CGRect.zero, nil)
        for i in 0..<printPageRenderer.numberOfPages {
            UIGraphicsBeginPDFPage()
            printPageRenderer.drawPage(at: i, in: UIGraphicsGetPDFContextBounds())
        }
        
        UIGraphicsEndPDFContext()
        
        return data
    }
}
