//
//  DataProvider.swift
//  Airport Forecast
//
//  Created by Raj Tailor on 4/14/21.
//  Copyright © 2021 Raj Tailor. All rights reserved.
//
import Foundation
import CoreData

class DataProvider {
    
    private let persistentContainer: NSPersistentContainer
    private let repository: APIRepository
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(persistentContainer: NSPersistentContainer, repository: APIRepository) {
        self.persistentContainer = persistentContainer
        self.repository = repository
    }
    
    func fetchFilms(completion: @escaping(Error?) -> Void) {
        repository.getAirportNames() { jsonDictionary, error in
            if let error = error {
                completion(error)
                return
            }
            
            guard let jsonDictionary = jsonDictionary else {
                //let error = NSError(domain: dataErrorDomain, code: DataErrorCode.wrongDataFormat.rawValue, userInfo: nil)
                completion(error)
                return
            }
            
            let taskContext = self.persistentContainer.newBackgroundContext()
            taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            taskContext.undoManager = nil
            
            _ = self.finalize(jsonDictionary: jsonDictionary, taskContext: taskContext)
            
            completion(nil)
        }
    }
    
    private func finalize(jsonDictionary: [[String: Any]], taskContext: NSManagedObjectContext) -> Bool {
        var successfull = false
        taskContext.performAndWait {
            let matches = NSFetchRequest<NSFetchRequestResult>(entityName: "Airport")
            let airportNames = jsonDictionary.map { $0["airportName"] as? Int }.compactMap { $0 }
            matches.predicate = NSPredicate(format: "airportName in %@", argumentArray: [airportNames])
            
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: matches)
            batchDeleteRequest.resultType = .resultTypeObjectIDs
            
            // Execute the request to de batch delete and merge the changes to viewContext, which triggers the UI update
            do {
                let batchDeleteResult = try taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult
                
                if let deletedObjectIDs = batchDeleteResult?.result as? [NSManagedObjectID] {
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: deletedObjectIDs],
                                                        into: [self.persistentContainer.viewContext])
                }
            } catch {
                print("Error: \(error)\n.Unable to delete existing records.")
                return
            }
            
            // Create new records.
            for airportEntities in jsonDictionary {
                
                guard let film = NSEntityDescription.insertNewObject(forEntityName: "Airport", into: taskContext) as? AirportCoreData else {
                    print("Error: Failed to create a new Film object!")
                    return
                }
                
                do {
                    try film.updateStack(with: airportEntities)
                } catch {
                    print("Error: \(error)\nThe  object will be deleted.")
                    taskContext.delete(film)
                }
            }
            
            // Save all the changes just made and reset the taskContext to free the cache.
            if taskContext.hasChanges {
                do {
                    try taskContext.save()
                } catch {
                    print("Error: \(error)\nCould not save Core Data context.")
                }
                taskContext.reset() // Reset the context to clean up the cache and low the memory footprint.
            }
            successfull = true
        }
        return successfull
    }
}
