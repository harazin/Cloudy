//
//  WeatherModel.swift
//  Cloudy
//
//  Created by Maximilián Harazin on 01/01/2020.
//  Copyright © 2020 Maximilián Harazin. All rights reserved.
//

import Foundation

struct WeatherModel {
    let cityName: String
    let temperature: Double
    var temperatureString: String {
        return String(format: "%.0f", temperature)
    }
    let forecasts: [Forecast]
}
