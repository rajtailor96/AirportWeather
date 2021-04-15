//
//  APIRepository.swift
//  Airport Forecast
//
//  Created by Raj Tailor on 4/14/21.
//  Copyright © 2021 Raj Tailor. All rights reserved.
//


import Foundation

class APIRepository {
    
    private init() {}
    static let shared = APIRepository()
    
    private let urlSession = URLSession.shared
    private let baseURL = URL(string: "https://qa.foreflight.com/weather/report/kaus")!
    
    func getAirportNames(completion: @escaping(_ filmsDict: [[String: Any]]?, _ error: Error?) -> ()) {
        let filmURL = baseURL.appendingPathComponent("films")
        urlSession.dataTask(with: filmURL) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                guard let jsonDictionary = jsonObject as? [String: Any], let result = jsonDictionary["results"] as? [[String: Any]] else {
                    return
                }
                completion(result, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
}
