//
//  Question2+CoreDataProperties.swift
//  assignment1
//
//  Created by Na'Eem Auckburally on 07/11/2016.
//  Copyright © 2016 Na'Eem Auckburally. All rights reserved.
//

import Foundation
import CoreData


extension Question2 {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Question2> {
        return NSFetchRequest<Question2>(entityName: "Question2");
    }

    @NSManaged public var option1: Int64
    @NSManaged public var option2: Int64
    @NSManaged public var option3: Int64
    @NSManaged public var option4: Int64

}
