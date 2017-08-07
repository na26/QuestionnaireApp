//
//  NumericOption+CoreDataProperties.swift
//  assignment1
//
//  Created by Na'Eem Auckburally on 10/11/2016.
//  Copyright © 2016 Na'Eem Auckburally. All rights reserved.
//

import Foundation
import CoreData


extension NumericOption {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NumericOption> {
        return NSFetchRequest<NumericOption>(entityName: "NumericOption");
    }

    @NSManaged public var choice: Int64
    @NSManaged public var questionNum: Int64

}
