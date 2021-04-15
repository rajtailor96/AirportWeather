//
//  ViewController.swift
//  Airport Forecast
//
//  Created by Raj Tailor on 4/12/21.
//  Copyright © 2021 Raj Tailor. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var favoriteTableView: UITableView!

    var weatherManager = WeatherManager()
    var weatherReport: AirportWeather?
    var airportFavorites: [AirportData]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let kpwm = AirportData(airportName: "KPWM")
        let kaus = AirportData(airportName: "KAUS")
        airportFavorites = [kaus, kpwm]
        
        print(airportFavorites!)
        
        searchField.delegate = self
        weatherManager.delegate = self
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
    }
    
    func getTime() -> String{
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short

        let datetime = formatter.string(from: now)
        return datetime
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailView"{
            let destinationVC = segue.destination as! DetailsViewController
            
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
            airportFavorites?.append(AirportData(airportName: search.uppercased()))
            favoriteTableView.reloadData()
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
       }
    }
    
    func didFailWithError(error: Error) {
        if error.localizedDescription.contains("data couldn’t be read"){
            searchField.shake()
            print("ERROR FOUND NOT AN ACTUAL AIRPORT")
        }
    }
}

//MARK: - UITextField

extension UITextField{
    func shake() {
         let animate = CABasicAnimation(keyPath: "positions")
         animate.duration = 0.05
         animate.repeatCount = 5
         animate.autoreverses = true
         
        DispatchQueue.main.sync {
            animate.fromValue = CGPoint(x: self.center.x - 4.0, y: self.center.y)
            animate.toValue = CGPoint(x: self.center.x + 4.0, y: self.center.y)
             layer.add(animate, forKey: "positions")
        }
    }
}


//MARK: - FavoritesTableView

extension ViewController: UITableViewDataSource, UITableViewDelegate, TableCellViewDelegate{
    func onClickCell(name: String) {
        weatherManager.fetchWeather(airportName: name.lowercased())
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return airportFavorites?.count ?? 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AirportCell", for: indexPath) as? TableCellViewModel
        cell?.labelName.text = "\( airportFavorites?[indexPath.row].airportName ?? "N/A")"
        cell?.cellDelegate = self
        return cell!
        
    }

}
