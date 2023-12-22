//
//  SearchCustomerViewController.swift
//  VIN-Bladel
//
//  Created by Olivia Marunde on 1/25/18.
//  Copyright © 2018 John Hersey High School. All rights reserved.
//

import UIKit

class SearchCustomerViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var inputFirstName: UITextField!
    @IBOutlet weak var inputLastName: UITextField!
    @IBOutlet weak var pulledText: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        searchButton.isEnabled = false
        searchButton.setTitleColor(UIColor(red:0.71, green:0.76, blue:0.80, alpha:1.0), for: .disabled)
        searchButton.setTitleColor(UIColor.white, for: .normal)
        searchButton.layer.borderColor = UIColor(red:0.71, green:0.76, blue:0.80, alpha:1.0).cgColor
        searchButton.layer.borderWidth = 3
        searchButton.layer.cornerRadius = 35
        
        confirmButton.isEnabled = false
        confirmButton.setTitleColor(UIColor(red:0.71, green:0.76, blue:0.80, alpha:1.0), for: .disabled)
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        confirmButton.layer.borderColor = UIColor(red:0.71, green:0.76, blue:0.80, alpha:1.0).cgColor
        confirmButton.layer.borderWidth = 3
        confirmButton.layer.cornerRadius = 35
        
        inputFirstName.delegate = self
        inputLastName.delegate = self
    }
    
    @IBAction func search(_ sender: UIButton)
    {
        pulledText.text = ""
        if CustomerDatabase.getCustomerByName(first: inputFirstName.text!, last: inputLastName.text!) != nil
        {
            customer = CustomerDatabase.getCustomerByName(first: inputFirstName.text!, last: inputLastName.text!)
            VehicleDatabase.addNewVehicle(newVehicle: car!)
            confirmButton.backgroundColor = UIColor(red: 47.0/255.0, green: 108.0/255.0, blue: 178.0/255.0, alpha: 1.0)
            confirmButton.isEnabled = true
        }
        else
        {
            pulledText.text = "Customer not found. Try Again"
            pulledText.textColor = UIColor(red:0.73, green:0.12, blue:0.20, alpha:1.0)
        }
    }
    
    @IBAction func confirm(_ sender: UIButton)
    {
        performSegue(withIdentifier: "searchCustomerToCarInfo", sender: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if inputFirstName.text != "" && inputLastName.text != ""
        {
            searchButton.isEnabled = true
            searchButton.backgroundColor = UIColor(named: "accentColor")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
        view.endEditing(true)
        return true
    }
    
}
