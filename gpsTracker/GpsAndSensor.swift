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

struct sailboat {
    let id: String
    let longitude : String
    let latitude : String
    let speed : String
    let accXvalue : String
    let accYvalue : String
    let accZvalue : String
    let gyrXvalue : String
    let gyrYvalue : String
    let gyrZvalue : String
    let comp : String
}

class GpsAndSensor: UIViewController, CLLocationManagerDelegate {
    
    var lat : Double = 0.0
    var long : Double = 0.0
    var speed = String()
    var accXvalues : [String] = []
    var accYvalues : [String] = []
    var accZvalues : [String] = []
    var gyrXvalues : [String] = []
    var gyrYvalues : [String] = []
    var gyrZvalues : [String] = []
    var comp : [String] = []
    var compass = String()
    
    var producedfile : [String] = []
    var filetosend : [String] = []
    var sentfile : [String] = []
    
    @IBOutlet weak var networkimage: UIImageView!
    @IBOutlet weak var gpsImage: UIImageView!
    
    
    var timer = Timer()
    
    var time = 0
    
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
        
        motionManager.accelerometerUpdateInterval = 1/60
        
        motionManager.gyroUpdateInterval = 1/60
        
    }
    
    func updateSensors() {
        
        motionManager.startAccelerometerUpdates()
        motionManager.startGyroUpdates()
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: {(data, error) in
            if let myData = data
            {
                if self.accXvalues.count < 60 {
                    self.accXvalues.append(String(format: "%.2f", ((myData.acceleration.x) * -10)))
                    self.accYvalues.append(String(format: "%.2f", ((myData.acceleration.y) * -10)))
                    self.accZvalues.append(String(format: "%.2f", ((myData.acceleration.z) * -10)))
                    self.comp.append(self.compass)

                }
                
            }
        })

        motionManager.startGyroUpdates(to: OperationQueue.current!, withHandler: {(data, error) in
            if let myData = data
            {
                if self.gyrXvalues.count < 60 {
                    self.gyrXvalues.append(String(format:"%.2f", myData.rotationRate.x))
                    self.gyrYvalues.append(String(format:"%.2f", myData.rotationRate.y))
                    self.gyrZvalues.append(String(format:"%.2f", myData.rotationRate.z))
                }
            }
        })
        
        
        
    }
    
    func checkSensors() -> Bool {
        if motionManager.isGyroActive || motionManager.isAccelerometerActive {
            return true
        } else {
            return false
        }
    }
    
    func clearArrays() {
        accXvalues.removeAll()
        accYvalues.removeAll()
        accZvalues.removeAll()
        gyrXvalues.removeAll()
        gyrYvalues.removeAll()
        gyrZvalues.removeAll()
        comp.removeAll()
    }
    
    // Location manager functions
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            if !checkSensors() {
                updateSensors()
                gpsImage.image = #imageLiteral(resourceName: "GPS_connected")
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GpsAndSensor.action), userInfo: nil, repeats: true)
            }
            
            print(location.coordinate)
            lat = location.coordinate.latitude
            long = location.coordinate.longitude
            speed = String(location.speed)
        }
    }
    
   
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {

        compass = String(format: "%.0f", newHeading.trueHeading)

    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopup()
        }
    }
  
    // Do this action every second
    @objc func action() {
        
        time += 1
        
        let date = Date()
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        var filename = String(describing: date)
        let endIndex = filename.index(filename.endIndex, offsetBy: -6)
        filename = filename.substring(to: endIndex)
        
        saveUploadedFilesSet(fileName: filename)

        clearArrays()
    }
    
    // Function to save the data from the sensors and locations to json file
    func saveUploadedFilesSet(fileName:String) {
        
        var data : [String : String] = [:]
        
        print("Id : 1, Time = \(fileName), Latitude: \(lat), Longitude: \(long)")
        data["Id"] = "1"
        data["Time"] = "\(fileName)"
        data["Latitude"] = "\(lat)"
        data["Longitude"] = "\(long)"
        
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        
            let DocumentDirURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            let jsonURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("json")
            print(jsonURL)
            
            do {
                try jsonData.write(to: jsonURL)
            } catch let error as Error {
                print(error)
            }
            
            
        } catch let error as Error{
            print(error)
        }
        
        do {
            let DocumentDirURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let jsonURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("json")
            
            let jsonReadData = NSData(contentsOf: jsonURL)
            
            if let jsonReadData = jsonReadData {
                let sailInfo = try JSONSerialization.jsonObject(with: jsonReadData as Data, options: .mutableContainers)
                let readData = sailInfo as! [String : String]
                let id = readData["I§d"], time = readData["Time"], latitude = readData["Latitude"], longitude = readData["Longitude"]
                
                print(id, time, latitude, longitude)
            }
            
        } catch let error as Error {
            print(error)
        }
        
        
        
//        let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
//        print("File Path: \(fileURL.path)")
//
//        let writeString = "id, \(fileName), \(lat), \(long)"
//        do {
//            try writeString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf32)
//        } catch let error as Error {
//            print("Failed to write to URL")
//            print(error)
//        }
//
//        producedfile.append("\(fileName).txt")
//        filetosend.append("\(fileName).txt")
//
//        var readString = ""
//        do {
//            readString = try String(contentsOf: fileURL)
//        } catch let error as Error {
//            print("Failed to read file")
//            print(error)
//        }
//
//        print("Contents of the file \(readString)")
    
        
        
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

