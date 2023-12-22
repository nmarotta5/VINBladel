//
//  ViewController.swift
//  VIN-Bladel
//
//  Created by Joel Koreth on 12/1/17.
//  Copyright © 2017 John Hersey High School. All rights reserved.
//

import UIKit

var car : VehicleData?
var customer : CustomerData?

class ViewController: UIViewController {
    
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var manualButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scanButton.layer.cornerRadius = 40
        manualButton.layer.cornerRadius = 40
        searchButton.layer.cornerRadius = 40
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchNameSegue" {
            let nvc = segue.destination as! SearchByNameVC
            nvc.passedBoolean = false
        }
    }
    
    @IBAction func startAgain(segue: UIStoryboardSegue) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        CustomerDatabase.pullFromFirebase()
        VehicleDatabase.pullFromFirebase()
        PartsDatabase.pullFromFirebase()
        ServiceDatabase.pullFromFirebase()
    }
}
