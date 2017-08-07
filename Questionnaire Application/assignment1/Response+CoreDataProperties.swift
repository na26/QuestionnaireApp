//
//  Response+CoreDataProperties.swift
//  assignment1
//
//  Created by Na'Eem Auckburally on 31/10/2016.
//  Copyright © 2016 Na'Eem Auckburally. All rights reserved.
//

import Foundation
import CoreData


extension Response {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Response> {
        return NSFetchRequest<Response>(entityName: "Response");
    }

    @NSManaged public var choice: String?

}
