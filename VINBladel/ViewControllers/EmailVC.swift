//
//  PartsVC.swift
//  VIN-Bladel
//
//  Created by Alisha Fong on 4/30/18.
//  Copyright © 2018 John Hersey High School. All rights reserved.
//

import UIKit
import MessageUI
import WebKit
import FirebaseStorage
import FirebaseDatabase

class EmailVC: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    var invoiceComposer: InvoiceComposer!
    var HTMLContent: String!
    let userDefaults = UserDefaults.standard
    var mechanics: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        let databaseRef = Database.database().reference().root.child("mechanics")
        databaseRef.observe(.value) { (snapshot) in
            for mechanic in snapshot.children.allObjects as! [DataSnapshot]
            {
                self.mechanics.append(mechanic.key)
            }
        }
        createInvoiceAsHTML()
    }
    
    @objc func exportData() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        createInvoiceAsHTML()
    }
    
    func createInvoiceAsHTML() {
        invoiceComposer = InvoiceComposer()
        
        if let invoiceHTML = invoiceComposer.renderInvoice(customer: customer!, partList: partList) {
            webView.loadHTMLString(invoiceHTML, baseURL: NSURL(string: invoiceComposer.pathToInvoiceHTMLTemplate!)! as URL)
            HTMLContent = invoiceHTML
        }
    }
    
    @IBAction func addTechnicianButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add Technician", message: nil, preferredStyle: .alert)
        for mechanic in mechanics {
            alert.addAction(UIAlertAction(title: mechanic, style: .default, handler: { (action) in
                self.HTMLContent = self.HTMLContent.replacingOccurrences(of: "#TECH#", with: mechanic)
                self.webView.loadHTMLString(self.HTMLContent, baseURL: URL(fileURLWithPath: self.invoiceComposer.pathToInvoiceHTMLTemplate!))
            }))
        }
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addProblemButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add Problem", message: "Please add any problems found", preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = "Describe Problem"
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            if let problems = alert.textFields?.first?.text {
                self.HTMLContent = self.HTMLContent.replacingOccurrences(of: "__", with: "  \(problems)")
                self.webView.loadHTMLString(self.HTMLContent, baseURL: URL(fileURLWithPath: self.invoiceComposer.pathToInvoiceHTMLTemplate!))
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func sendEmailButtonPressed(_ sender: UIButton) {
        invoiceComposer.exportHTMLContentToPDF(HTMLContent: HTMLContent)
        DispatchQueue.main.async {
            self.sendEmail()
        }
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([(customer?.customerEmail)!])
            mail.setSubject("Your Car is Ready *Please Read*")
            mail.setMessageBody("Your car is ready to be picked up at the Auto Shop. Please pick up your keys by 2PM.\n\nWe can now accept donations via Credit Card. To donate using a Credit Card please see Karen Flickinger in the Main Office.\n\nPlease See Attached Service Record.\n\nPayment for service is donation only. We do NOT charge for services.", isHTML: false)
            
            mail.addAttachmentData(NSData(contentsOfFile: invoiceComposer.pdfFilename)! as Data, mimeType: "application/pdf", fileName: "ServiceRecord.pdf")
            
            present(mail, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        saveToFirebase()
    }
    
    func saveToFirebase() {
        let pdf = URL(fileURLWithPath: "\(AppDelegate.getAppDelegate().getDocDir())/ServiceRecord.pdf")
        let image = drawPDFfromURL(url: pdf)!
        let imageData = image.jpegData(compressionQuality: 0.8)
        
        let vin = userDefaults.object(forKey: "VIN") as! String
        
        let interval = TimeInterval(exactly: 0)
        let date = Date(timeIntervalSinceNow: interval!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-YY"
        let dateString = dateFormatter.string(from: date)
        
        let storageRef = Storage.storage().reference(withPath: "\(vin)/\(dateString).jpg")
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        storageRef.putData(imageData!, metadata: uploadMetaData) { (metadata, error) in
            if error != nil {
                print("Error \(String(describing: error?.localizedDescription))")
            } else {
                print("Complete")
            }
        }
        
        let invoicesRef = Database.database().reference().root.child("serviceRecords")
        invoicesRef.child(vin).child(dateString).setValue("1")
    }
    
    func drawPDFfromURL(url: URL) -> UIImage? {
        guard let document = CGPDFDocument(url as CFURL) else { return nil }
        guard let page = document.page(at: 1) else { return nil }
        
        let pageRect = page.getBoxRect(.mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        let img = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(pageRect)
            
            ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
            
            ctx.cgContext.drawPDFPage(page)
        }
        
        return img
    }
    
    @IBAction func whenPrintButtonPressed(_ sender: UIButton) {
        invoiceComposer.exportHTMLContentToPDF(HTMLContent: HTMLContent)
        let printInfo = UIPrintInfo(dictionary:nil)
        printInfo.outputType = UIPrintInfo.OutputType.general
        printInfo.jobName = "My Print Job"
        
        // Set up print controller
        let printController = UIPrintInteractionController.shared
        printController.printInfo = printInfo
        
        let pdf = URL(fileURLWithPath: "\(AppDelegate.getAppDelegate().getDocDir())/ServiceRecord.pdf")
        let image = drawPDFfromURL(url: pdf)!
        
        // Assign a UIImage version of my UIView as a printing iten
        printController.printingItem = image
        
        // Do it
        printController.present(from: self.view.frame, in: self.view, animated: true, completionHandler: nil)
        
        saveToFirebase()
    }
    
    override func viewWillLayoutSubviews() {
        var customTabFrame = self.tabBarController?.tabBar.frame
        customTabFrame?.size.height = CGFloat(80)
        customTabFrame?.origin.y = self.view.frame.size.height - CGFloat(80)
        self.tabBarController?.tabBar.frame = customTabFrame!
        tabBarController?.tabBar.barStyle = .black
        tabBarController?.tabBar.tintColor = .white
    }
}
