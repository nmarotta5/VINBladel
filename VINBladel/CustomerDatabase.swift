//
//  CustomerDatabase.swift
//  VIN-Bladel
//
//  Created by Alisha Fong on 1/30/18.
//  Copyright © 2018 John Hersey High School. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

var customerReference = Database.database().reference().root.child("customers")

class CustomerDatabase
{
    static var database = [CustomerData]()
    static var lastID = 0
    
    static func addNewCustomer(newCustomer: CustomerData)
    {
        let key = customerReference.childByAutoId().key!
        
        newCustomer.customerKey = String(lastID + 1)
        newCustomer.customerID = String(lastID + 1)
        
        database.append(newCustomer)
        let customerDictionary = newCustomer.createNewCustomer()
        customerReference.child(key).setValue(customerDictionary)
    }
    
    static func getAllCustomers() -> [CustomerData]
    {
        return database
    }
    
    static func getCustomerByName(first: String, last: String) -> CustomerData?
    {
        for customer in database
        {
            if customer.customerFirst.lowercased() == first.lowercased()
                && customer.customerLast.lowercased() == last.lowercased()
            { return customer }
        }
        return nil
    }
    
    static func getCustomerByKey(key: String) -> CustomerData?
    {
        for customer in database
        {
            if customer.customerKey == key { return customer }
        }
        return nil
    }
    
    static func getCustomerByID(ID: String) -> CustomerData?
    {
        for customer in database
        {
            if customer.customerID == ID { return customer }
        }
        return nil
    }
    
    static func pullFromFirebase()
    {
        database.removeAll()
        customerReference.observe(.value) { (snapshot) in
            for customers in snapshot.children.allObjects as! [DataSnapshot]
            {
                let object = customers.value as? [String: AnyObject]
//                let index = object?["Customer Index"] as! String
                let ID = object?["Customer ID"] as! String
                let key = customers.key
                let title = object?["Customer Title"] as! String
                let first = object?["Customer First Name"] as! String
                let last = object?["Customer Last Name"] as! String
                
                let add1 = object?["Customer Addr1"] as! String
                let add2 = object?["Customer Addr2"] as! String
                let city = object?["Customer City"] as! String
                let state = object?["Customer State"] as! String
                let country = object?["Customer Country"] as! String
                let zip = object?["Customer Zip Code"] as! String
                
                let email = object?["Customer Email"] as! String
                let home = object?["Customer Home Phone"] as! String
                let work = object?["Customer Work Phone"] as! String
                
                let customer = CustomerData(key: key, ID: ID, title: title, first: first, last: last, address1: add1, address2: add2, city: city, state: state, zip: zip, country: country, email: email, home: home, work: work)
                
                self.database.append(customer)
            }
            if let customerID = self.database.last?.customerID {
                if let id = Int(customerID) {
                    self.lastID = id
                }
            }
            
        }
    }
    
    static func pushToFirebase()
    {
        for customers in database
        {
            customers.updateToDatabase()
        }
    }
}


