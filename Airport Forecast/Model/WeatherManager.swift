//
//  WeatherManager.swift
//  Airport Forecast
//
//  Created by Raj Tailor on 4/12/21.
//  Copyright © 2021 Raj Tailor. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: AirportWeather)
    func  didFailWithError(error: Error)
}

struct WeatherManager{
    let airportURL = "https://qa.foreflight.com/weather/report/"
    var delegate: WeatherManagerDelegate?
    
    
    func fetchWeather(airportName: String){
        let urlString = "\(airportURL)\(airportName)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){

        if let url = URL(string: urlString){
            var request = URLRequest(url: url)
            request = URLRequest(url: url)
            request.addValue("ff-coding-exercise", forHTTPHeaderField: "1")
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request) { (data, response, error) in
                if error != nil {
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
    
    func parseJSON(_ weatherData: Data) -> AirportWeather?{
            
            let decoder = JSONDecoder()
            do{
                let conditions = try decoder.decode(Page.self, from: weatherData)
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                let conditionsReport = ConditionModel(
                    ident: conditions.report.conditions.ident,
                    tempC: conditions.report.conditions.tempC,
                    dewpoint: conditions.report.conditions.dewpointC,
                    pressure: conditions.report.conditions.pressureHg,
                    relativeHumidity: conditions.report.conditions.relativeHumidity,
                    cloudLayers: conditions.report.conditions.cloudLayers,
                    cloudLayersV2: conditions.report.conditions.cloudLayersV2,
                    visibility: conditions.report.conditions.visibility,
                    wind: conditions.report.conditions.wind)
                let forecastReport = ForecastModel(relativeHumidity: conditions.report.forecast.conditions[0].relativeHumidity, cloudLayers: conditions.report.forecast.conditions[0].cloudLayers, cloudLayersV2: conditions.report.forecast.conditions[0].cloudLayersV2, visibility: conditions.report.forecast.conditions[0].visibility, wind: conditions.report.forecast.conditions[0].wind)
                
                let finalReport = AirportWeather(conditionsReport: conditionsReport, forecastReport: forecastReport)
                return finalReport
            } catch {
                self.delegate?.didFailWithError(error: error)
                return nil
            }

        
        
    }
    
}
