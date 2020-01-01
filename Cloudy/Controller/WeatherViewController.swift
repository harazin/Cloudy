//
//  ViewController.swift
//  Cloudy
//
//  Created by Maximilián Harazin on 01/01/2020.
//  Copyright © 2020 Maximilián Harazin. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    // Temperature View
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    // Forecast View
    @IBOutlet weak var forecast1Label: UILabel!
    @IBOutlet weak var forecast1Temp: UILabel!
    @IBOutlet weak var forecast1Image: UIImageView!
    
    @IBOutlet weak var forecast2Label: UILabel!
    @IBOutlet weak var forecast2Temp: UILabel!
    @IBOutlet weak var forecast2Image: UIImageView!
    
    @IBOutlet weak var forecast3Label: UILabel!
    @IBOutlet weak var forecast3Temp: UILabel!
    @IBOutlet weak var forecast3Image: UIImageView!
    
    @IBOutlet weak var forecast4Label: UILabel!
    @IBOutlet weak var forecast4Temp: UILabel!
    @IBOutlet weak var forecast4Image: UIImageView!
    
    @IBOutlet weak var forecast5Label: UILabel!
    @IBOutlet weak var forecast5Temp: UILabel!
    @IBOutlet weak var forecast5Image: UIImageView!
    
    //Models
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        weatherManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        
        // Do any additional setup after loading the view.
    }


}

// MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

// MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
