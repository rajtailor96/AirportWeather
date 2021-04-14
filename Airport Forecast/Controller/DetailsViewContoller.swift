//
//  Details View Contoller.swift
//  Airport Forecast
//
//  Created by Raj Tailor on 4/10/21.
//  Copyright © 2021 Raj Tailor. All rights reserved.
//

import UIKit


class DetailsViewController: UITableViewController{
    var conditionsArray: [String]?
    var forecastArray: [String]?
    var arrayToDisplay: [String]?

    override func viewDidLoad() {
        arrayToDisplay = conditionsArray
    }
    
    @IBAction func segmentedControlUpdate(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            arrayToDisplay = conditionsArray
        case 1:
            arrayToDisplay = forecastArray
        default:
            arrayToDisplay = conditionsArray
        }
        
        tableView.reloadData()

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayToDisplay?.count ?? 16
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)

  
        cell.textLabel?.text = arrayToDisplay?[indexPath.row]
        //cell.textLabel?.text = "Hello1"

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
    

    
}

