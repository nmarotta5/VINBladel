//
//  ScanVC.swift
//  VIN-Bladel
//
//  Created by Alisha Fong on 12/4/17.
//  Copyright © 2017 John Hersey High School. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseDatabase

class ScanVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate
{
    var barcode = ""
    
    @IBOutlet weak var barcodeLabel: UILabel!
    
    let session = AVCaptureSession()
    let sessionQueue = DispatchQueue(label: AVCaptureSession.self.description(), attributes: [], target: nil)
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        session.beginConfiguration()
        
        let videoDevice = AVCaptureDevice.default(for: .video)
        
//        if (videoDevice != nil) {
            let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!)
            
//            if (videoDeviceInput != nil) {
//                if (session.canAddInput(videoDeviceInput!)) {
                    session.addInput(videoDeviceInput!)
//                }
//            }
            let metadataOutput = AVCaptureMetadataOutput()
            
//            if (session.canAddOutput(metadataOutput)) {
                session.addOutput(metadataOutput)
                
                metadataOutput.metadataObjectTypes = [
                    .upce,
                    .ean8,
                    .ean13,
                    .code39,
                    .code39Mod43,
                    .code128,
                    .itf14,
                    .code93,
                    .qr,
                    .dataMatrix,
                    .pdf417,
                    .aztec,
                    .face,
                    .interleaved2of5
                ]
                
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        session.commitConfiguration()
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        videoPreviewLayer?.frame = view.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        view.bringSubviewToFront(self.barcodeLabel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        car = nil
        barcodeLabel.text = "No barcode is detected"
        barcodeLabel.textColor = .white
        sessionQueue.async {
            self.session.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sessionQueue.async {
            self.session.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if (metadataObjects.count > 0 && metadataObjects.first is AVMetadataMachineReadableCodeObject) {
            let scan = metadataObjects.first as! AVMetadataMachineReadableCodeObject
            
            if scan.stringValue?.first == "I"
            {
                var imported: String = scan.stringValue!
                imported.remove(at: (scan.stringValue?.startIndex)!)
                barcode = imported
            }
                
            else
            {
                barcode = scan.stringValue!
            }
            
            while(car == nil) {
                car = VehicleDatabase.searchByVIN(vin: self.barcode)
            }
            
            barcodeLabel.textColor = UIColor(red:0.31, green:0.63, blue:0.46, alpha:1.0)
            barcodeLabel.text = barcode
            segueToCarInfo( UIButton() )
        }
        
        if metadataObjects.count == 0 {
            barcodeLabel.textColor = UIColor.white
            barcodeLabel.text = "No barcode is detected"
        }
    }
    
    @IBAction func segueToCarInfo(_ sender: Any)
    {
        
        session.stopRunning()
        
        if (car?.error != nil) {
            let alert = UIAlertController(title: "Error", message: car?.error, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            session.startRunning()
        }
        else {
            if (car?.fromDatabase)!
            {
                customer = CustomerDatabase.getCustomerByID(ID: (car?.vehicleCustomerID)!)
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    self.performSegue(withIdentifier: "scanToCarInfo", sender: nil)

                })
            }
            else
            {
                car?.vehicleKey = self.barcode
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.performSegue(withIdentifier: "scanNotFound", sender: nil)
                })

            }
        }
    }
}

