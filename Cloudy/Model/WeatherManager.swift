//
//  WeatherManager.swift
//  Cloudy
//
//  Created by Maximilián Harazin on 01/01/2020.
//  Copyright © 2020 Maximilián Harazin. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/forecast?appid=0c5cb9e0a953e56ac89b144a47ed1b4d&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(latitude lat: CLLocationDegrees, longitude lon: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
            
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let cityName = decodedData.city.name
            let localTemp = decodedData.list[0].main.temp
                    
            var forecasts = [Forecast]()
            
            for i in 0...4 {
                let day = decodedData.list[i*8]
                let dayOfWeek = getDayOfWeek(day.dtTxt.prefix(10)) ?? "Date Unavaliable"
                let conditionId = day.weather[0].id
                let temperature = day.main.temp
                
                let forcast = Forecast(day: dayOfWeek, conditionId: conditionId, temperature: temperature)
                forecasts.append(forcast)
            }
            
            
            let weather = WeatherModel(cityName: cityName, temperature: localTemp, forecasts: forecasts)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    func getDayOfWeek(_ today:String.SubSequence) -> String? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let todayDate = formatter.date(from: String(today)) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        switch weekDay {
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        case 7:
            return "Saturday"
        default:
            return("No Date!")
        }
    }
}
