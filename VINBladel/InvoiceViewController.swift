//
//  InvoiceViewController.swift
//  VIN-Bladel
//
//  Created by Robert D. Brown on 8/28/18.
//  Copyright © 2018 John Hersey High School. All rights reserved.
//

import UIKit
import WebKit
import FirebaseDatabase
import FirebaseStorage

class InvoiceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    let userDefaults = UserDefaults.standard
    var currentVIN: String!
    
    var serviceRecords: [String] = []
    var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        //currentVIN = userDefaults.object(forKey: "VIN") as! String
        currentVIN = car?.VIN
        
        let databaseRef = Database.database().reference().root.child("serviceRecords").child(currentVIN)
        databaseRef.observe(.value) { (snapshot) in
            var counter = 0
            for date in snapshot.children.allObjects as! [DataSnapshot]
            {
                let serviceRecordDate = date.key
                self.serviceRecords.append(serviceRecordDate)
                let storageRef = Storage.storage().reference(forURL: "gs://vinbladel.appspot.com/\(self.currentVIN!)/\(self.serviceRecords[counter]).jpg")
                storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                    if let error = error {
                        print(error)
                    } else {
                        self.images.append(UIImage(data: data!)!)
                    }
                    self.tableView.reloadData()
                }
                counter += 1
            }
            
            
        }
        
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") {
            cell.textLabel?.text = "Service Record Dated: \(serviceRecords[indexPath.row])"
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        imageView.image = images[indexPath.row]
    }
    
    @IBAction func whenPrintButtonPressed(_ sender: UIButton) {
        let printInfo = UIPrintInfo(dictionary:nil)
        printInfo.outputType = UIPrintInfo.OutputType.general
        printInfo.jobName = "My Print Job"
        
        // Set up print controller
        let printController = UIPrintInteractionController.shared
        printController.printInfo = printInfo
        
        // Assign a UIImage version of my UIView as a printing iten
        printController.printingItem = imageView.image
        
        // Do it
        printController.present(from: self.view.frame, in: self.view, animated: true, completionHandler: nil)
    }
    
}
