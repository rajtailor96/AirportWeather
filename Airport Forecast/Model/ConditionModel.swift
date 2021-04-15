//
//  WeatherModel.swift
//  Airport Forecast
//
//  Created by Raj Tailor on 4/12/21.
//  Copyright © 2021 Raj Tailor. All rights reserved.
//

import Foundation


struct AirportWeather{
    var conditionsReport: ConditionModel
    var forecastReport: ForecastModel
}


struct ConditionModel{
    let ident: String
    let tempC: Double
    let dewpoint: Double
    let pressure: Double
    let relativeHumidity: Int
    let cloudLayers: [CloudLayers]
    let cloudLayersV2: [CloudLayersV2]
    let visibility: Visibility
    let wind: Wind
    
    func getConditions()->[String]{
        return ["Identity: \(ident)", "Temp C: \(String(tempC))", "Dew Point: \(String(dewpoint))", "Pressure HG: \(String(pressure))", "Relative Humidity: \(String(relativeHumidity))", "Coverage: \(cloudLayers[0].coverage)", "Altitude: \(cloudLayers[0].altitudeFt)", "Ceiling: \(cloudLayers[0].ceiling)", "Coverage: \(cloudLayersV2[0].coverage)", "Altitude: \(cloudLayersV2[0].altitudeFt)", "Ceiling: \(cloudLayersV2[0].ceiling)", "Distance: \(visibility.distanceSm)", "Prevailing: \(visibility.prevailingVisSm)", "Speed Knots: \(wind.speedKts)", "Variables: \(wind.variable)"]
    }
    
    
    let numOfSections = 9
    
   /* var temparatureString: String {
        return String(format:"%.01f", temp)
    }*/
    
    
}

