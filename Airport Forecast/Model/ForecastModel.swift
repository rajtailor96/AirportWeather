//
//  ForecastModel.swift
//  Airport Forecast
//
//  Created by Raj Tailor on 4/12/21.
//  Copyright © 2021 Raj Tailor. All rights reserved.
//

import Foundation

struct ForecastModel{
    let relativeHumidity: Int
    let cloudLayers: [CloudLayers]
    let cloudLayersV2: [CloudLayersV2]
    let visibility: Visibility
    let wind: Wind
    
    let numOfSections = 5
    
    func getConditions()->[String]{
        return [ "Relative Humidity: \(String(relativeHumidity))", "Coverage: \(cloudLayers[0].coverage)", "Altitude: \(cloudLayers[0].altitudeFt)", "Ceiling: \(cloudLayers[0].ceiling)", "Coverage: \(cloudLayersV2[0].coverage)", "Altitude: \(cloudLayersV2[0].altitudeFt)", "Ceiling: \(cloudLayersV2[0].ceiling)", "Distance: \(visibility.distanceSm)", "Prevailing: \(visibility.prevailingVisSm)", "Speed Knots: \(wind.speedKts)", "Variables: \(wind.variable)"]
    }
}
