//
//  Question4+CoreDataProperties.swift
//  assignment1
//
//  Created by Na'Eem Auckburally on 01/11/2016.
//  Copyright © 2016 Na'Eem Auckburally. All rights reserved.
//

import Foundation
import CoreData


extension Question4 {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Question4> {
        return NSFetchRequest<Question4>(entityName: "Question4");
    }

    @NSManaged public var response: String?

}
