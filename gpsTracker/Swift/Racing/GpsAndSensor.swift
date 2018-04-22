//
//  ViewController.swift
//  gpsTracker
//
//  Created by David Shin on 11/01/2018.
//  Copyright © 2018 David Shin. All rights reserved.
//

import UIKit
import CoreLocation
import CoreMotion

struct sailboat : Encodable {
    var competitorID: Int
    var boatID : Int
    var raceID : Int
    var timeMilli : Int
    var longitude : Double
    var latitude : Double
    var x : [Double] // accelerometer
    var y : [Double]
    var z : [Double]
    var dX : [Double] // gyroscope
    var dY : [Double]
    var dZ : [Double]
    var angle : [Int]
}


class GpsAndSensor: UIViewController, CLLocationManagerDelegate {
    
    var competitorID : Int = 0
    var boatID : Int = 0
    var raceID : Int = 0
    var lat : Double = 0.0
    var long : Double = 0.0
    var speed = String()
    var x : [Double] = []
    var y : [Double] = []
    var z : [Double] = []
    var dX : [Double] = []
    var dY : [Double] = []
    var dZ : [Double] = []
    var angle : [Int] = []
    var compass : Double = 0
    var gyrX : Double = 0
    var gyrY : Double = 0
    var gyrZ : Double = 0
    
    let date = Date()
    
    var producedfile : [String] = []
    var filetosend : [String] = []
    var sentfile : [String] = []
    
    @IBOutlet weak var networkimage: UIImageView!
    @IBOutlet weak var gpsImage: UIImageView!
    
    
    var timer = Timer()
    
    var time = 0
    
    let locationManager = CLLocationManager()
    var motionManager = CMMotionManager()
    
    var postURL : String = "movedata/add"
    
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
        
        motionManager.accelerometerUpdateInterval = 1/5
        
        motionManager.gyroUpdateInterval = 1/5
        
    }
    
    func updateSensors() {
        
//        let amount = 10.000001
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .decimal
//        formatter.maximumFractionDigits = 2
//        let formattedAmount = formatter.string(from: amount as NSNumber)!
//        print(formattedAmount) // 10
        
        motionManager.startAccelerometerUpdates()
        motionManager.startGyroUpdates()
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: {(data, error) in
            if let myData = data
            {
                if self.x.count < 60 {
                    self.x.append((myData.acceleration.x) * -10)
                    self.y.append((myData.acceleration.y) * -10)
                    self.z.append((myData.acceleration.z) * -10)
                    self.angle.append(Int(self.compass))
                    if self.dX.last == self.gyrX {
                        self.dX.append(0)
                        self.dY.append(0)
                        self.dZ.append(0)
                    } else {
                        self.dX.append(self.gyrX)
                        self.dY.append(self.gyrY)
                        self.dZ.append(self.gyrZ)
                    }
                    
                }
                
            }
        })

        motionManager.startGyroUpdates(to: OperationQueue.current!, withHandler: {(data, error) in
            if let myData = data
            {
                if self.dX.count < 60 {
                    self.gyrX = (myData.rotationRate.x)
                    self.gyrY = (myData.rotationRate.y)
                    self.gyrZ = (myData.rotationRate.z)
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
        x.removeAll()
        y.removeAll()
        z.removeAll()
        dX.removeAll()
        dY.removeAll()
        dZ.removeAll()
        angle.removeAll()
    }
    
    // Location manager functions
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            if !checkSensors() {
                updateSensors()
                gpsImage.image = #imageLiteral(resourceName: "GPS_connected")
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GpsAndSensor.action), userInfo: nil, repeats: true)
            }
            
//            print(location.coordinate)
            lat = location.coordinate.latitude
            long = location.coordinate.longitude
//            speed = String(location.speed)
        }
    }
    
   
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {

        compass = newHeading.trueHeading

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
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        var filename = String(describing: date)
        let endIndex = filename.index(filename.endIndex, offsetBy: -6)
        filename = String(filename[..<endIndex])
        
        saveUploadedFilesSet(fileName: filename)

        clearArrays()
    }
    
    // Function to save the data from the sensors and locations to json file
    func saveUploadedFilesSet(fileName:String) {
        

//        print("gyrX: \(dX)")
//        print("gyrY: \(dY)")
//        print("gyrZ: \(dZ)")

        let newData = sailboat(competitorID: competitorID, boatID: boatID, raceID: raceID, timeMilli: Int(TimeInterval(date.timeIntervalSince1970 * 1000)), longitude: long, latitude: lat, x: x, y: y, z: z, dX: dX, dY: dY, dZ: dZ, angle: angle)
        
        guard let jsonData = try? JSONEncoder().encode(newData) else {return}
        
        guard let json = try? JSONSerialization.jsonObject(with: jsonData, options: [.allowFragments]) else {return}
        
        print(json)
        
        guard let DocumentDirURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {return}
            
        let jsonURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("json")
            
//        print(jsonURL)
        
        do {
            try jsonData.write(to: jsonURL)
        } catch {
            print(error)
        }
        
        guard let url = URL (string: "\(baseURL)\(postURL)") else {return}
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.httpBody = jsonData

        let session = URLSession.shared
        session.dataTask(with: request) {(data, response, error) in
            if let response = response {
                print(response)
            }

            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                    print(json)
                } catch {
                    print(error)
                }
            }
            
            if let error = error {
                print(error)
            }
        }.resume()

        
        
        do {
            let DocumentDirURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let jsonURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("json")
            
            let jsonReadData = NSData(contentsOf: jsonURL)
            
            if let jsonReadData = jsonReadData {
                let sailInfo = try JSONSerialization.jsonObject(with: jsonReadData as Data, options: .mutableContainers)
//                print(sailInfo)
            }
            
        } catch{
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

    @IBAction func stop(_ sender: Any) {
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
        motionManager.stopAccelerometerUpdates()
        motionManager.stopGyroUpdates()
        
        timer.invalidate()
        
        performSegue(withIdentifier: "Back To Info", sender: self)
    }
    
}

