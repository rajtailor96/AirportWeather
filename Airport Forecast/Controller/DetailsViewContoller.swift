//
//  Details View Contoller.swift
//  Airport Forecast
//
//  Created by Raj Tailor on 4/12/21.
//  Copyright © 2021 Raj Tailor. All rights reserved.
//

import UIKit
import CoreData

class DetailsViewController: UITableViewController, NSFetchedResultsControllerDelegate{
    var conditionsArray: [String]?
    var forecastArray: [String]?
    var arrayToDisplay: [String]?
    var tableTitle = "Conditions"

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        tableView.reloadData()
    }
    
    var dataProvider: DataProvider!
    lazy var fetchedResultsController: NSFetchedResultsController<AirportCoreData> = {
        let fetchRequest = NSFetchRequest<AirportCoreData>(entityName:"Airport")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "airportName", ascending:true)]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: dataProvider.viewContext,
                                                    sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        
        do {
            try controller.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return controller
    }()
    
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
        
        tableTitle = sender.titleForSegment(at: sender.selectedSegmentIndex)!
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

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Airport Weather \(tableTitle)"
    }

}

