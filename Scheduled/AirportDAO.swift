//
//   AirportDAO.swift
//   Scheduled
//
//   Created by Gustavo F Oliveira on 3/14/16.
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

import Foundation
import CoreData

class AirportDAO {
    
    private static let CITY: String = "CITY"
    private static let CITY_NAME: String = "city_name"
    private static let STATE_NAME: String = "state_name"
    private static let AIRPORT_NAME: String = "airport_name"
    
    // insert new object
    static func insert(airport: Airport) -> Bool{
        DatabaseManager.sharedInstance.managedObjectContext.insertObject(airport)
        
        do {
            try DatabaseManager.sharedInstance.managedObjectContext.save()
            return true
            
        } catch let error as NSError {
            print("Erro ao inserir tarefa: ", error)
            return false
        }
    }
    
    static func insertAll() -> Bool {
        
        var airports = DatabaseManager.sharedInstance.managedObjectContext.insertedObjects as! Set<Airport>
        
        let path: NSString = NSBundle.mainBundle().pathForResource("airportsBrazil", ofType: "json")!
        let data: NSData = try! NSData(contentsOfFile: path as String, options: NSDataReadingOptions.DataReadingMapped)
        
        let dict: NSDictionary! = (try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
        
        for i in 0  ..< (dict.valueForKey(CITY) as! NSArray).count {
            
            let airportResult = (dict.valueForKey(CITY) as! NSArray).objectAtIndex(i)
            
            let cityName:String = airportResult.valueForKey(CITY_NAME) as! String
            let stateName:String = airportResult.valueForKey(STATE_NAME) as! String
            let airportName:String = airportResult.valueForKey(AIRPORT_NAME) as! String
            
            let airport: Airport = Airport()
            airport.cityName = cityName
            airport.stateName = stateName
            airport.airportName = airportName
            
            airports.insert(airport)
        }
        
        do {
            try DatabaseManager.sharedInstance.managedObjectContext.save()
            return true
            
        } catch let error as NSError {
            print("Erro ao inserir tarefa: ", error)
            return false
        }
    }
    
    // fetch all existing objects
    static func fetchAll() -> [Airport] {
        
        let request = NSFetchRequest(entityName: "Airport")
        let sortDescriptor = NSSortDescriptor(key: "cityName", ascending: true)
        
        // Set the list of sort descriptors in the fetch request,
        // so it includes the sort descriptor
        request.sortDescriptors = [sortDescriptor]
        
        var results = [Airport]()
        
        do {
            
            results = try DatabaseManager.sharedInstance.managedObjectContext.executeFetchRequest(request) as! [Airport]
            
        } catch let error as NSError {
            print("Erro ao buscar tarefas:", error)
        }
        
        return results
    }
    
    static func fecthAllInSection() -> [[Airport]]? {
        
        var airports: [[Airport]] = [[Airport]]()
        
        var previous = ""
        for anAirport in AirportDAO.fetchAll() {
            // get the first letter
            let c = String(anAirport.cityName!.characters.prefix(1))
            // only add a letter to sectionNames when it's a different letter
            if c != previous {
                previous = c
                //self.headers.append(c.uppercaseString)
                // and in that case also add new subarray to our array of subarrays
                airports.append( [Airport]() )
            }
            // add new State to our array of states values
            airports[airports.count-1].append(anAirport)
        }
        
        
        return airports
    }
    
}

