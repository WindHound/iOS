//
//  ViewController.swift
//  gpsTracker
//
//  Created by 신종훈 on 11/01/2018.
//  Copyright © 2018 신종훈. All rights reserved.
//

import UIKit
import CoreLocation
import CoreMotion

class GpsAndSensor: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var accXvalue: UILabel!
    @IBOutlet weak var accYvalue: UILabel!
    @IBOutlet weak var accZvalue: UILabel!
    @IBOutlet weak var gyrXvalue: UILabel!
    @IBOutlet weak var gyrYvalue: UILabel!
    @IBOutlet weak var gyrZvalue: UILabel!
    @IBOutlet weak var compass: UILabel!
    
    let locationManager = CLLocationManager()
    
    var motionManager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // For use when the app is open & in the background
        //locationManager.requestAlwaysAuthorization()
        
        //For use when the app is open
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        motionManager.accelerometerUpdateInterval = 0.5
        
        motionManager.gyroUpdateInterval = 0.1
        
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: {(data, error) in
            if let myData = data
            {
            
                self.accXvalue.text = "X: " + String(format: "%.2f", ((myData.acceleration.x) * 10 * -1))
                self.accYvalue.text = "Y: " + String(format: "%.2f", ((myData.acceleration.y) * 10 * -1))
                self.accZvalue.text = "Z: " + String(format: "%.2f", ((myData.acceleration.z) * 10 * -1))
//            print(String(format: "%.3f", totalWorkTimeInHours)) Reference purpose
            }
        })
        
        motionManager.startGyroUpdates(to: OperationQueue.current!, withHandler: {(data, error) in
            if let myData = data
            {
                print(myData.rotationRate)
                self.gyrXvalue.text = "X: " + String(format: "%.2f", ((myData.rotationRate.x)))
                self.gyrYvalue.text = "Y: " + String(format: "%.2f", ((myData.rotationRate.y)))
                self.gyrZvalue.text = "Z: " + String(format: "%.2f", ((myData.rotationRate.z)))
            }
        })
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print(location.coordinate)
            latitude.text = "Latitude:   " + String(location.coordinate.latitude)
            longitude.text = "Longitude: " + String(location.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        compass.text = String(format: "%.0f", newHeading.trueHeading)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopup()
        }
    }
  
    
    func showLocationDisabledPopup() {
        let alertController = UIAlertController(title: "Background Location Access Disabled", message: "To get the latitude and longitude, gps access is required", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) {(action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

