//
//  ViewController.swift
//  CoordViaSMS
//
//  Created by Harut on 29.12.14.
//  Copyright (c) 2014 Harut Arakelyan. All rights reserved.
//

import UIKit
import CoreLocation
import MessageUI

class ViewController: UIViewController, CLLocationManagerDelegate, MFMessageComposeViewControllerDelegate {
    
    var locationManager = CLLocationManager()
    var coordinate: CLLocationCoordinate2D!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        coordinate = manager.location.coordinate
    }
    

    
    @IBAction func getAddress(sender: AnyObject) {
        
        addressLabel.text = String(format: "%f, %f", arguments: [coordinate.longitude, coordinate.longitude])
        getAddresFromLocation(coordinate)
    }
    
    func getAddresFromLocation(location: CLLocationCoordinate2D) {
        var urlString = String(format: "https://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true&key=AIzaSyAPwi-ubPl36fAL438TDMFSOunafZpZbRA", arguments: [location.latitude, location.longitude])
        var url = NSURL(string: urlString)
        var jsonData = NSData(contentsOfURL: url!)
        var err: NSError?
        var jsonDict: NSDictionary = NSJSONSerialization.JSONObjectWithData(jsonData!, options:NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        if jsonDict["status"] as String == "OK" {
            println("yed")
            let results: NSArray = jsonDict["results"] as NSArray
            if results.count > 0 {
                var fullAddressesDict: NSDictionary = results[0] as NSDictionary
                var tempAddress = String(fullAddressesDict["formatted_address"] as NSString)
                self.addressLabel.text = tempAddress
                self.addressLabel.sizeToFit()
            }
        }
    }
    
    @IBAction func launchMessageComposeViewController(sender: AnyObject) {
        if MFMessageComposeViewController.canSendText() {
            let messageVC = MFMessageComposeViewController()
            messageVC.messageComposeDelegate = self
            messageVC.recipients = ["1111111111", "2222222222"]
            messageVC.body = "hello phone"
            self.presentViewController(messageVC, animated: true, completion: nil)
        }
        else {
            println("User hasn't setup Messages.app")
        }
    }

    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

