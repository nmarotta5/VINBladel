//
//  CarInfoViewController.swift
//  VIN-Bladel
//
//  Created by Olivia Marunde on 12/11/17.
//  Copyright © 2017 John Hersey High School. All rights reserved.
//

import UIKit

class CarInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var carLabel: UILabel!
    @IBOutlet weak var carTextField: UITextField!
}

class CarInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var nameLabel: UILabel!
    
    let userDefaults = UserDefaults.standard
    
    var labelTitles = ["VIN:", "Make:", "Model:", "Submodel:", "Model Year:", "Engine (L):", "Cylinders:", "Transmission:", "Drive Type:", "Mileage:","","","",""]
    var textViewInformation = [String?]()
    
    var passed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.hidesBackButton = true
        
        
        
        textViewInformation = [car?.VIN, car?.vehicleMake, car?.vehicleModel, car?.vehicleSubModel, car?.vehicleModelYear, car?.vehicleDisplacement, car?.vehicleCylinder, car?.vehicleTransmission, car?.vehicleDriveType, car?.vehicleMileage," "," "," "," "]

        nameLabel.text = " Customer: " + (customer?.customerFirst)! + " " + (customer?.customerLast)!
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        updateDefaults()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateDefaults()
    }
    
    func updateDefaults() {
        
        updateData()
        
        userDefaults.set(car?.vehicleMake, forKey: "Make")
        userDefaults.set(car?.vehicleModel, forKey: "Model")
        userDefaults.set(car?.vehicleModelYear, forKey: "Year")
        userDefaults.set(car?.vehicleMileage, forKey: "Mileage")
        userDefaults.set(car?.VIN, forKey: "VIN")
    }
    
    func updateData() {
        car?.VIN = textViewInformation[0]
        car?.vehicleMake = textViewInformation[1]
        car?.vehicleModel = textViewInformation[2]
        car?.vehicleSubModel = textViewInformation[3]
        car?.vehicleModelYear = textViewInformation[4]
        car?.vehicleDisplacement = textViewInformation[5]
        car?.vehicleCylinder = textViewInformation[6]
        car?.vehicleTransmission = textViewInformation[7]
        car?.vehicleDriveType = textViewInformation[8]
        car?.vehicleMileage = textViewInformation[9]
        
        if let vin = car?.VIN {
            car?.updateAField(field: "VIN", value: vin)
        }
        
        if let make = car?.vehicleMake {
            car?.updateAField(field: "Make Description", value: make)
        }
        
        if let model = car?.vehicleModel {
            car?.updateAField(field: "Model Description", value: model)
        }
        
        if let submodel = car?.vehicleSubModel {
            car?.updateAField(field: "VehicleSubModel", value: submodel)
        }
        
        if let year = car?.vehicleModelYear {
            car?.updateAField(field: "Year", value: year)
        }
        
        if let displacement = car?.vehicleDisplacement {
            car?.updateAField(field: "Engine Description", value: displacement)
        }
        
        if let cylinders = car?.vehicleCylinder {
            car?.updateAField(field: "Number of Cylinders", value: cylinders)
        }
        
        if let transmission = car?.vehicleTransmission {
            car?.updateAField(field: "Transmission", value: transmission)
        }
        
        if let driveType = car?.vehicleDriveType {
            car?.updateAField(field: "VehicleDriveType", value: driveType)
        }
        
        if let mileage = car?.vehicleMileage {
            car?.updateAField(field: "Mileage", value: mileage)
        }
        
        if let customerId = customer?.customerID {
            car?.updateAField(field: "Customer ID", value: customerId)
        }
    }
    
    override func viewWillLayoutSubviews() {
        var customTabFrame = self.tabBarController?.tabBar.frame
        customTabFrame?.size.height = CGFloat(80)
        customTabFrame?.origin.y = self.view.frame.size.height - CGFloat(80)
        self.tabBarController?.tabBar.frame = customTabFrame!
        tabBarController?.tabBar.barStyle = .black
        tabBarController?.tabBar.tintColor = .white
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        
        updateDefaults()
        
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != textViewInformation[textField.tag]
        {
            textViewInformation[textField.tag] = textField.text
        }
    
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labelTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CarInfoTableViewCell
        cell.carLabel?.text = " \(labelTitles[indexPath.row])"
        cell.carTextField.tag = indexPath.row
        cell.carTextField.text = textViewInformation[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}
