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
        airportFavorites = [AirportData(airportName: "KAUS"), AirportData(airportName: "KPWM")]

        searchField.delegate = self
        weatherManager.delegate = self
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
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
        if searchField.text == ""{
            print("Hello")
        } else if let search = searchField.text{
            weatherManager.fetchWeather(airportName: search.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))
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
            if(searchField.text! != ""){
                airportFavorites?.append(AirportData(airportName: searchField.text!.uppercased()))
                airportFavorites?.removeDuplicates()
                favoriteTableView.reloadData()
            }
            
            self.performSegue(withIdentifier: "detailView", sender: self)
       }
    }
    
    func didFailWithError(error: Error) {
        if error.localizedDescription.contains("data couldn’t be read"){
            searchField.shake()
            
            let alert = UIAlertController(title: "The Airport does not Exist", message: "Please input an Airport that exists", preferredStyle: .actionSheet)

            alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))

            DispatchQueue.main.async {
                self.present(alert, animated: true)
            }
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

//MARK: - Duplicates


extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
