//
//  DataNotFoundViewController.swift
//  VIN-Bladel
//
//  Created by Olivia Marunde on 1/25/18.
//  Copyright © 2018 John Hersey High School. All rights reserved.
//

import UIKit

class DataNotFoundVC: UIViewController {
    
    @IBOutlet weak var newCustomerButton: UIButton!
    @IBOutlet weak var previousCustomerButton: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        newCustomerButton.layer.cornerRadius = 60
        previousCustomerButton.layer.cornerRadius = 60
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PreviousCustomer" {
            let nvc = segue.destination as! SearchByNameVC
            nvc.passedBoolean = true
        }
        
    }
}
