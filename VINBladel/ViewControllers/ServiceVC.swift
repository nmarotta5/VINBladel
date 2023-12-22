//
//  ServiceVC.swift
//  VIN-Bladel
//
//  Created by Alisha Fong on 3/1/18.
//  Copyright © 2018 John Hersey High School. All rights reserved.
//

import UIKit
import WebKit

var partList = PartsDatabase.partsUsed

class ServiceVC: UIViewController, UIPickerViewDataSource, UITableViewDataSource, UIPickerViewDelegate, UITableViewDelegate {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var webView: UIWebView!
    
    var output: String = ""
    var services = ServiceDatabase.database
    var allParts = PartsDatabase.database
    var firstTime = true
    
    var currentPartList: [Part] = []
    var currentService: String!
    var tableComposer: TableComposer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.hidesBackButton = true
        
        if let cs = services.first?.name {
            currentService = cs
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        createTableAsHTML()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let first = customer?.customerFirst else { return }
        guard let last = customer?.customerLast else { return }
        
        guard let carMake = car?.vehicleMake else { return }
        guard let carModel = car?.vehicleModel else { return }
        
        infoLabel.text = " \(first) \(last) - \(carMake) \(carModel) "
        
    
    }
    
    func createTableAsHTML() {
        tableComposer = TableComposer()
        let tableHTML = tableComposer.renderInvoice(partsUsed: partList)
        webView.loadHTMLString(tableHTML, baseURL: URL(fileURLWithPath: tableComposer.pathToTableHTMLTemplate))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if firstTime {
            for part in allParts {
                if part.associatedService == currentService {
                    currentPartList.append(part)
                }
            }
            firstTime = false
        }
        
        return currentPartList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let formattedPrice = String(format: "%.2f", currentPartList[indexPath.row].partPrice!)
        cell.textLabel?.text = "\(currentPartList[indexPath.row].partName!)-$\(formattedPrice)"
        cell.detailTextLabel?.text = "Quantity:\(currentPartList[indexPath.row].quantity)"
        if currentPartList[indexPath.row].beenChecked {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if UITableViewCell.AccessoryType.checkmark == cell?.accessoryType {
            cell?.accessoryType = .none
            currentPartList[indexPath.row].beenChecked = false
        } else {
            cell?.accessoryType = .checkmark
            currentPartList[indexPath.row].beenChecked  = true
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return services.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return services[row].name!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentService = services[row].name!
        firstTime = true
        currentPartList.removeAll()
        tableView.reloadData()
    }
    
    @IBAction func whenConfirmButtonPressed(_ sender: UIButton) {
        let rowChosen = pickerView.selectedRow(inComponent: 0)
        let description = services[rowChosen].name!
        let price = services[rowChosen].price!
        let total: String
        if price == 0 {
            total = ""
        }
        else {
            total = String(format: "%.2f", price)
        }
        partList.append(PartUsed(quantity: "", description: description, price: "", total: total))
        
//        for cell in tableView.visibleCells {
//            if cell.accessoryType == UITableViewCell.AccessoryType.checkmark {
//                let tuple = getDescriptionQuantityPrice(cell: cell)
//                partList.append(PartUsed(quantity: "\(tuple.quantity)", description: " - \(tuple.description)", price: String(format: "%.2f", tuple.price), total: String(format: "%.2f",(tuple.quantity * tuple.price))))
//            }
//        }
        
        for part in currentPartList {
            if part.beenChecked {
                partList.append(PartUsed(quantity: "\(part.quantity)", description: " - \(part.partName!)", price: String(format: "%.2f", part.partPrice!), total: String(format: "%.2f",(part.quantity * part.partPrice!))))
            }
        }
       createTableAsHTML()
    }
    
    func getDescriptionQuantityPrice(cell: UITableViewCell) -> (description: String,quantity:Double,price:Double) {
        var description: String = ""
        var quantity: Double = 0.0
        var price: Double = 0.0
        
        if let indexOfDash = cell.textLabel?.text?.firstIndex(of: "-"), let text = cell.textLabel?.text?.prefix(upTo: indexOfDash) {
            description = "\(text)"
        }
        
        if let amount = PartsDatabase.getPriceFor(partNamed: description) {
            price = amount
        }
        
        if let indexOfColon = cell.detailTextLabel?.text?.firstIndex(of: ":"), let indexAfter = cell.detailTextLabel?.text?.index(after: indexOfColon), let text = cell.detailTextLabel?.text?.suffix(from: indexAfter), let number = Double(text)
        {
            quantity = number
        }
        return (description,quantity,price)
    }
    
    @IBAction func whenClearButtonPressed(_ sender: UIButton) {
        partList.removeAll()
        
        createTableAsHTML()
        
        for part in allParts {
            part.quantity = 1.0
            part.beenChecked = false
        }
        tableView.reloadData()
        
    }
    
    
    @IBAction func whenLongPressRecognized(_ sender: UILongPressGestureRecognizer) {

        if sender.state == UIGestureRecognizer.State.ended {
            
            let touchPoint = sender.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                let alert = UIAlertController(title: "Quantity?", message: nil, preferredStyle: .alert)
                alert.addTextField { (textfield) in
                    textfield.keyboardType = .decimalPad
                    textfield.placeholder = "Enter Quantity Here"
                }
                alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
                    if let text = alert.textFields?.first?.text {
                        if let quantity = Double(text) {
                            let cell = self.tableView.cellForRow(at: indexPath)
                            cell?.detailTextLabel?.text = "Quantity:\(quantity)"
                            self.currentPartList[indexPath.row].quantity = quantity
                            cell?.accessoryType = .checkmark
                            self.currentPartList[indexPath.row].beenChecked = true
                        }
                    }
                }))
                present(alert, animated: true, completion: nil)
            }
        }
    }
}
