//
//  Airport.swift
//  Scheduled
//
//  Created by Gustavo F Oliveira on 4/22/16.
//  Copyright © 2016 Gustavo F Oliveira. All rights reserved.
//

import Foundation
import CoreData


class Airport: NSManagedObject {

    convenience init()
    {
        // get context
        let context: NSManagedObjectContext = DatabaseManager.sharedInstance.managedObjectContext
        
        // create entity description
        let entityDescription: NSEntityDescription? = NSEntityDescription.entityForName("Airport", inManagedObjectContext: context)
        
        // call super using
        self.init(entity: entityDescription!, insertIntoManagedObjectContext: context)
    }

}

extension Airport {
    
    @NSManaged var airportName: String?
    @NSManaged var cityName: String?
    @NSManaged var stateName: String?
    
}
