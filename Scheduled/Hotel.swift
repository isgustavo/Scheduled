//
//  Hotel.swift
//  Scheduled
//
//  Created by Gustavo F Oliveira on 5/9/16.
//  Copyright © 2016 Gustavo F Oliveira. All rights reserved.
//

import Foundation
import CoreData


class Hotel: NSManagedObject {

    // The designated initializer
    convenience init()
    {
        // get context
        let context: NSManagedObjectContext = DatabaseManager.sharedInstance.managedObjectContext
        
        // create entity description
        let entityDescription: NSEntityDescription? = NSEntityDescription.entityForName("Hotel", inManagedObjectContext: context)
        
        // call super using
        self.init(entity: entityDescription!, insertIntoManagedObjectContext: context)
    }

}

extension Hotel {
    
    @NSManaged var name: String?
    @NSManaged var phone: String?
    @NSManaged var address: String?
    
    
    
}