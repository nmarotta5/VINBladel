//
//  customerCarsVC.swift
//  VIN-Bladel
//
//  Created by Alisha Fong on 3/1/18.
//  Copyright © 2018 John Hersey High School. All rights reserved.
//

import UIKit

class CustomerTableViewCell: UITableViewCell
{
    @IBOutlet weak var carLabel: UITextField!
}

class CustomerCarsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var customerCarTable: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    var carArray:[VehicleData] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        self.navigationItem.hidesBackButton = true  
        
        customerCarTable.delegate = self
        customerCarTable.dataSource = self
        
        nameLabel.text = "Customer: " + (customer?.customerFirst)! + " " + (customer?.customerLast)!
        carArray = VehicleDatabase.searchForCarsWithACertainCustomerID(customerID: (customer?.customerID)!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        carArray = VehicleDatabase.searchForCarsWithACertainCustomerID(customerID: (customer?.customerID)!)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return carArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomerTableViewCell
        
        cell.carLabel?.text = "  \(carArray[indexPath.row].vehicleModelYear!)" + " " + "\(carArray[indexPath.row].vehicleModel!)"

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        car = carArray[indexPath.row]
    }
}
