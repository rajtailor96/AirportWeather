//
//  WeatherData.swift
//  Airport Forecast
//
//  Created by Raj Tailor on 4/10/21.
//  Copyright © 2021 Raj Tailor. All rights reserved.
//

import Foundation

import Foundation

struct Page: Codable{
    let report: Report
}

struct Report: Codable{
    let conditions: Conditions
    let forecast: ForeCast
}

struct CloudLayers: Codable{
    let coverage: String
    let altitudeFt: Double
    let ceiling: Bool
    let numOfSections = 3
}
struct CloudLayersV2: Codable{
    let coverage: String
    let altitudeFt: Double
    let ceiling: Bool
    let numOfSections = 3
}

struct Visibility: Codable {
    let distanceSm: Double
    let prevailingVisSm: Double
    let numOfSections = 2
}
struct Wind: Codable {
    let speedKts: Double
    let variable: Bool
    let numOfSections = 2
}
struct Period: Codable {
    let dateStart: String
    let dateEnd: String
    let numOfSections = 2
}

struct ForeCast: Codable{
    let text: String
    let ident: String
    let dateIssued: String
    let lat: Float
    let lon: Float
    let elevationFt: Double
    let conditions: [ForeCastConditions]
    let numOfSections = 7
}
struct Conditions: Codable{
    let text: String
    let ident: String
    let dateIssued: String
    let lat: Float
    let lon: Float
    let tempC: Double
    let dewpointC: Double
    let elevationFt: Double
    let pressureHg: Double
    let relativeHumidity: Int
    let flightRules: String
    let cloudLayers: [CloudLayers]
    let cloudLayersV2: [CloudLayersV2]
    let weather: [String]
    let visibility: Visibility
    let wind: Wind
    let numOfSections = 16
}

struct ForeCastConditions: Codable{
    let text: String
    let dateIssued: String
    let lat: Float
    let lon: Float
    let elevationFt: Double
    let relativeHumidity: Int
    let flightRules: String
    let cloudLayers: [CloudLayers]
    let cloudLayersV2: [CloudLayersV2]
    let weather: [String]
    let visibility: Visibility
    let wind: Wind
    let period: Period
    let numOfSections = 13
}




