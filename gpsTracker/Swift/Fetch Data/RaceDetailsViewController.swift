import UIKit
import MapKit

class RaceDetailsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
    
    @IBOutlet weak var bar: UINavigationItem!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var name : String = ""
    
    var race: Race_Struct!
    
    //Race Replay
    override func viewDidLoad()
    {
        super.viewDidLoad()
        configureView()
        
        bar.title = name
        
        let screenSize: CGRect = UIScreen.main.bounds
        mapView.heightAnchor.constraint(equalToConstant: screenSize.width - 81 - 31)
        
        
//        toolBar.clipsToBounds = true
        //Initialise map
        //centerMapOnLocation(location: initialLocation)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    private func configureView()
    {
        let distance = Measurement(value: race.distance, unit: UnitLength.meters)
        let seconds = Int(race.duration)
        let formattedDistance = FormatDisplay.distance(distance)
        let formattedDate = FormatDisplay.date(race.timestamp)
        let formattedTime = FormatDisplay.time(seconds)
        let formattedSpeed = FormatDisplay.speed(distance: distance,
                                                 seconds: seconds,
                                                 outputUnit: UnitSpeed.nauticalMiles)
        
        distanceLabel.text = "Distance:  \(formattedDistance)"
        dateLabel.text = formattedDate
        timeLabel.text = "Time:  \(formattedTime)"
        speedLabel.text = "Speed:  \(formattedSpeed)"
        
        loadMap()
    }
    
    private func mapRegion() -> MKCoordinateRegion?
    {
        guard
            let locations = race.locations,
            locations.count > 0
            else {
                return nil
        }
        
        let latitudes = locations.map { location -> Double in
            let location = location as! Location_Struct
            return location.latitude
        }
        
        let longitudes = locations.map { location -> Double in
            let location = location as! Location_Struct
            return location.longitude
        }
        
        let maxLat = latitudes.max()!
        let minLat = latitudes.min()!
        let maxLong = longitudes.max()!
        let minLong = longitudes.min()!
        
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                                            longitude: (minLong + maxLong) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.3,
                                    longitudeDelta: (maxLong - minLong) * 1.3)
        return MKCoordinateRegion(center: center, span: span)
    }
    
    private func polyLine() -> [MulticolorPolyline]
    {
        
        // Polyline segments -> coordinate pairs (describe each segment and speed)
        let locations = race.locations?.array as! [Location_Struct]
        var coordinates: [(CLLocation, CLLocation)] = []
        var speeds: [Double] = []
        var minSpeed = Double.greatestFiniteMagnitude
        var maxSpeed = 0.0
        
        // Endpoint -> CLLocation object and save as pairs
        for (first, second) in zip(locations, locations.dropFirst())
        {
            let start = CLLocation(latitude: first.latitude, longitude: first.longitude)
            let end = CLLocation(latitude: second.latitude, longitude: second.longitude)
            coordinates.append((start, end))
            
            // Calculate Speed
            let distance = end.distance(from: start)
            let time = second.timestamp!.timeIntervalSince(first.timestamp! as Date)
            let speed = time > 0 ? distance / time : 0
            speeds.append(speed)
            minSpeed = min(minSpeed, speed)
            maxSpeed = max(maxSpeed, speed)
        }
        
        // Average speed for recording
        let midSpeed = speeds.reduce(0, +) / Double(speeds.count)
        
        // Create new MulticolorPolyline and set color
        var segments: [MulticolorPolyline] = []
        for ((start, end), speed) in zip(coordinates, speeds)
        {
            let coords = [start.coordinate, end.coordinate]
            let segment = MulticolorPolyline(coordinates: coords, count: 2)
            segment.color = segmentColor(speed: speed,
                                         midSpeed: midSpeed,
                                         slowestSpeed: minSpeed,
                                         fastestSpeed: maxSpeed)
            segments.append(segment)
        }
        return segments
    }
    
    private func segmentColor(speed: Double, midSpeed: Double, slowestSpeed: Double, fastestSpeed: Double) -> UIColor
    {
        enum BaseColors
        {
            static let r_red: CGFloat = 1
            static let r_green: CGFloat = 20 / 255
            static let r_blue: CGFloat = 44 / 255
            
            static let y_red: CGFloat = 1
            static let y_green: CGFloat = 215 / 255
            static let y_blue: CGFloat = 0
            
            static let g_red: CGFloat = 0
            static let g_green: CGFloat = 146 / 255
            static let g_blue: CGFloat = 78 / 255
        }
        
        let red, green, blue: CGFloat
        
        if speed < midSpeed
        {
            let ratio = CGFloat((speed - slowestSpeed) / (midSpeed - slowestSpeed))
            red = BaseColors.r_red + ratio * (BaseColors.y_red - BaseColors.r_red)
            green = BaseColors.r_green + ratio * (BaseColors.y_green - BaseColors.r_green)
            blue = BaseColors.r_blue + ratio * (BaseColors.y_blue - BaseColors.r_blue)
        }
        else
        {
            let ratio = CGFloat((speed - midSpeed) / (fastestSpeed - midSpeed))
            red = BaseColors.y_red + ratio * (BaseColors.g_red - BaseColors.y_red)
            green = BaseColors.y_green + ratio * (BaseColors.g_green - BaseColors.y_green)
            blue = BaseColors.y_blue + ratio * (BaseColors.g_blue - BaseColors.y_blue)
        }
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    private func loadMap()
    {
        guard
            let locations = race.locations,
            locations.count > 0,
            let region = mapRegion()
            else
        {
            let alert = UIAlertController(title: "Error",
                                          message: "Sorry, this race has no locations saved",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(alert, animated: true)
            return
        }
        
        mapView.setRegion(region, animated: true)
        mapView.addOverlays(polyLine())
        //mapView.mapType = MKMapType.satellite
        //mapView.add(polyLine())
    }
    
    //Collection View
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //LeaderboardImageArray
    var LeaderboardImageArray = [UIImage(named: "sailboat-1"), UIImage(named: "sailboat-2"), UIImage(named: "sailboat-3"), UIImage(named: "sailboat-4"), UIImage(named: "sailboat-5"), UIImage(named: "sailboat-6")]
    
    //DataImageArray -- NOT USED
    var DataImageArray = [UIImage(named: "sailboat-1"), UIImage(named: "sailboat-2"), UIImage(named: "sailboat-3"), UIImage(named: "sailboat-4"), UIImage(named: "sailboat-5"), UIImage(named: "sailboat-6")]
    
    //Leaderboard
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return LeaderboardImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LeaderboardCollectionViewCell", for: indexPath)
            as! LeaderboardCollectionViewCell
        
        cell.LeaderboardImage.image = LeaderboardImageArray[indexPath.row]
        
        return cell
    }
}

extension RaceDetailsViewController: MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        guard let polyline = overlay as? MulticolorPolyline else
        {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = polyline.color
        renderer.lineWidth = 3
        return renderer
    }
    
}

