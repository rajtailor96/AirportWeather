//
//  ViewController.swift
//  Airport Forecast
//
//  Created by Raj Tailor on 4/10/21.
//  Copyright © 2021 Raj Tailor. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchField: ShakingTextField!
    
    var weatherManager = WeatherManager()
    var weatherReport: AirportWeather?
    let vc = DetailsViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchField.delegate = self
        weatherManager.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailView"{
            let destinationVC = segue.destination as! DetailsViewController
            print("hello")
            
            destinationVC.conditionsArray = weatherReport?.conditionsReport.getConditions()
            destinationVC.forecastArray = weatherReport?.forecastReport.getConditions()
            
        }
    }
    
}


//MARK: - UITextFieldDelegate

extension ViewController: UITextFieldDelegate{
    @IBAction func searchPressed(_ sender: UIButton) {
        if let search = searchField.text{
            weatherManager.fetchWeather(airportName: search.lowercased())
            
        } else {
            print("Empty")
        }
        print("search Pressed")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Please Enter a Valid Airport"
            //searchField.shake()
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let airport = searchField.text {
            weatherManager.fetchWeather(airportName: airport.lowercased())
            self.performSegue(withIdentifier: "detailView", sender: self)
        }
        
        searchField.text = ""
    }
}

//MARK: - WeatherManagerDelegate

extension ViewController: WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: AirportWeather){
       DispatchQueue.main.sync{
            weatherReport = weather
            self.performSegue(withIdentifier: "detailView", sender: self)
            //print(weatherReport!)
       }
    }
    
    func didFailWithError(error: Error) {
        if error.localizedDescription.contains("data couldn’t be read"){
            searchField.shake()
            print("ERROR FOUND NOT AN ACTUAL AIRPORT")
        }
    }
}

