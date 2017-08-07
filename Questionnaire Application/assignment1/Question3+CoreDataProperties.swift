//
//  Question3+CoreDataProperties.swift
//  assignment1
//
//  Created by Na'Eem Auckburally on 01/11/2016.
//  Copyright © 2016 Na'Eem Auckburally. All rights reserved.
//

import Foundation
import CoreData


extension Question3 {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Question3> {
        return NSFetchRequest<Question3>(entityName: "Question3");
    }

    @NSManaged public var response: Float

}
