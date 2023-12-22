//
//  NewCutomerViewController.swift
//  VIN-Bladel
//
//  Created by Olivia Marunde on 1/25/18.
//  Copyright © 2018 John Hersey High School. All rights reserved.
//

import UIKit

class NewCustomerVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var newFirstName: UITextField!
    @IBOutlet weak var newLastName: UITextField!
    @IBOutlet weak var newEmail: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBAction func confirmNewInfo(_ sender: UIButton) {
        
        if newFirstName.text != "" && newLastName.text != "" && newEmail.text != ""
        {
            customer = CustomerData(key: "", ID: "", title: "", first: newFirstName.text!, last: newLastName.text!, address1: "1900 E Thomas", address2: "", city: "Arlington Heights", state: "IL", zip: "60004", country: "", email: newEmail.text!, home: "", work: "")
            
            CustomerDatabase.addNewCustomer(newCustomer: customer!)
            car?.vehicleCustomerID = customer?.customerID
        }
        
        performSegue(withIdentifier: "newCustomerToCarInfo", sender: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if newFirstName.text != "" && newLastName.text != "" && newEmail.text != ""
        {
            confirmButton.backgroundColor = UIColor(named: "accentColor")
            confirmButton.isEnabled = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
        view.endEditing(true)
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true  
        
        confirmButton.isEnabled = false
        confirmButton.layer.cornerRadius = 35
        
        newFirstName.delegate = self
        newLastName.delegate = self
        newEmail.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newCustomerToCarInfo" {
            if let car = car {
                VehicleDatabase.addNewVehicle(newVehicle: car)
                Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (timer) in
                    VehicleDatabase.pullFromFirebase()
                }
            }
        }
    }
}
