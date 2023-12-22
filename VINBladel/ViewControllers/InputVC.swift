//
//  InputVC.swift
//  VIN-Bladel
//
//  Created by Alisha Fong on 12/4/17.
//  Copyright © 2017 John Hersey High School. All rights reserved.
//

import UIKit

class InputVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var vinTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        vinTextfield.delegate = self
        
        vinTextfield.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        searchButton.isEnabled = false
        searchButton.setTitleColor(UIColor.white, for: .normal)
        searchButton.layer.cornerRadius = 35
    }
    
    
    @objc func textFieldDidChange()
    {
        if vinTextfield.text?.count == 17
        {
            searchButton.backgroundColor = UIColor(named: "accentColor")
            searchButton.isEnabled = true
        }
        else
        {
            searchButton.isEnabled = false
            searchButton.backgroundColor = UIColor(named: "disableColor")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    
    
    @IBAction func searchVIN(_ sender: Any)
    {
        car = VehicleDatabase.searchByVIN(vin: vinTextfield.text!)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            if car?.fromDatabase == true
            {
                customer = CustomerDatabase.getCustomerByID(ID: (car?.vehicleCustomerID)!)
                self.performSegue(withIdentifier: "manualToCarInfo", sender: nil)
            }
            else {
                self.performSegue(withIdentifier: "inputNotFound", sender: nil)
            }
        })
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is DataNotFoundVC
        {
            if(car?.error != nil) {
                let alert = UIAlertController(title: "Error", message: car?.error, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
