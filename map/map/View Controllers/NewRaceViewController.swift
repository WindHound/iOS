import UIKit
import CoreLocation

class NewRaceViewController: UIViewController
{
    
    @IBOutlet weak var launchPromptStackView: UIStackView!
    @IBOutlet weak var dataStackView: UIStackView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        dataStackView.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        locationManager.stopUpdatingLocation()
    }
    
    //Tap Start Button
    @IBAction func startTapped()
    {
        startRace()
    }
    
    //Tap Stop Button
    @IBAction func stopTapped()
    {
        let alertController =       UIAlertController  (title: "End Recording?",
                                                        message: "Do you wish to end your Recording?",
                                                        preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction    (title: "Cancel", style: .cancel))
        
        alertController.addAction(UIAlertAction    (title: "Save", style: .default)
        { _ in
            self.stopRace()
            self.saveRace()
            self.performSegue(withIdentifier: .details, sender: nil)
        })
        
        alertController.addAction(UIAlertAction    (title: "Discard", style: .destructive)
        { _ in
            self.stopRace()
            _ = self.navigationController?.popToRootViewController(animated: true)
        })
        
        present(alertController, animated: true)
    }
    
    private var race: Race?
    
    private let locationManager = LocationManager.shared
    private var seconds = 0
    private var timer: Timer?
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    private var locationList: [CLLocation] = []
    
    //Start Race
    private func startRace()
    {
        launchPromptStackView.isHidden = true
        dataStackView.isHidden = false
        startButton.isHidden = true
        stopButton.isHidden = false
        
        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.meters)
        locationList.removeAll()
        updateDisplay()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true)
            { _ in
                self.eachSecond()
            }
        startLocationUpdates()
    }
    
    //Stop Race
    private func stopRace()
    {
        launchPromptStackView.isHidden = false
        dataStackView.isHidden = true
        startButton.isHidden = false
        stopButton.isHidden = true
        locationManager.stopUpdatingLocation()
    }
    
    private func startLocationUpdates()
    {
        locationManager.delegate = self
        locationManager.activityType = .fitness // need to change
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
    }
    
    func eachSecond()
    {
        seconds += 1
        updateDisplay()
    }
    
    private func updateDisplay()
    {
        let formattedDistance = FormatDisplay.distance(distance)
        let formattedTime = FormatDisplay.time(seconds)
        let formattedSpeed = FormatDisplay.speed(distance: distance,
                                               seconds: seconds,
                                               outputUnit: UnitSpeed.nauticalMiles)
        
        distanceLabel.text = "Distance:  \(formattedDistance)"
        timeLabel.text = "Time:  \(formattedTime)"
        speedLabel.text = "Speed:  \(formattedSpeed)"
    }
    
    private func saveRace()
    {
        let newRace = Race(context: CoreDataStack.context)
        newRace.distance = distance.value
        newRace.duration = Int64(seconds)
        newRace.timestamp = Date()
        
        for location in locationList
        {
            let locationObject = Location(context: CoreDataStack.context)
            locationObject.timestamp = location.timestamp
            locationObject.latitude = location.coordinate.latitude
            locationObject.longitude = location.coordinate.longitude
            newRace.addToLocations(locationObject)
        }
        
        CoreDataStack.saveContext()
        race = newRace
    }
    
}

//Segue
extension NewRaceViewController: SegueHandlerType
{
    enum SegueIdentifier: String
    {
        case details = "RaceDetailsViewController"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        switch segueIdentifier(for: segue)
        {
        case .details:
            let destination = segue.destination as! RaceDetailsViewController
            destination.race = race
        }
    }
}

extension NewRaceViewController: CLLocationManagerDelegate
{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        for newLocation in locations
        {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
            
            if let lastLocation = locationList.last
            {
                let delta = newLocation.distance(from: lastLocation)
                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
            }
            
            locationList.append(newLocation)
        }
    }
}
