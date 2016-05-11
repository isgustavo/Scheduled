//
//   Flight.swift
//   Traveling
//
//   Created by Gustavo F Oliveira on 1/5/16.
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


class Flight: NSManagedObject  {
    
    // The designated initializer
    convenience init()
    {
        // get context
        let context: NSManagedObjectContext = DatabaseManager.sharedInstance.managedObjectContext
        
        // create entity description
        let entityDescription: NSEntityDescription? = NSEntityDescription.entityForName("Flight", inManagedObjectContext: context)
        
        // call super using
        self.init(entity: entityDescription!, insertIntoManagedObjectContext: context)
    }

}

extension Flight {
    
    @NSManaged var airline: String?
    @NSManaged var dateHour: NSDate?
    @NSManaged var reservationCode: String?
    @NSManaged var arrivalAirport: Airport?
    @NSManaged var departureAirport: Airport?
    @NSManaged var hotel: Hotel?

}