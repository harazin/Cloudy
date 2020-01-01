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
            // Update Labels Of Main Weather
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = weather.temperatureString
            
            // Update Same-Day Forecast
            self.forecast1Label.text = weather.forecasts[0].day
            self.forecast1Temp.text = weather.forecasts[0].temperatureString
            self.forecast1Image.image = UIImage(systemName: weather.forecasts[0].conditionName)
            // Update Day 2 Forecast
            self.forecast2Label.text = weather.forecasts[1].day
            self.forecast2Temp.text = weather.forecasts[1].temperatureString
            self.forecast2Image.image = UIImage(systemName: weather.forecasts[1].conditionName)
            // Update Day 3 Forecast
            self.forecast3Label.text = weather.forecasts[2].day
            self.forecast3Temp.text = weather.forecasts[2].temperatureString
            self.forecast3Image.image = UIImage(systemName: weather.forecasts[2].conditionName)
            // Update Day 4 Forecast
            self.forecast4Label.text = weather.forecasts[3].day
            self.forecast4Temp.text = weather.forecasts[3].temperatureString
            self.forecast4Image.image = UIImage(systemName: weather.forecasts[3].conditionName)
            // Update Day 5 Forecast
            self.forecast5Label.text = weather.forecasts[4].day
            self.forecast5Temp.text = weather.forecasts[4].temperatureString
            self.forecast5Image.image = UIImage(systemName: weather.forecasts[4].conditionName)
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
