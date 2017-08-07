//
//  MultiOption+CoreDataProperties.swift
//  assignment1
//
//  Created by Na'Eem Auckburally on 10/11/2016.
//  Copyright © 2016 Na'Eem Auckburally. All rights reserved.
//

import Foundation
import CoreData


extension MultiOption {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MultiOption> {
        return NSFetchRequest<MultiOption>(entityName: "MultiOption");
    }

    @NSManaged public var option1: Int64
    @NSManaged public var option2: Int64
    @NSManaged public var option3: Int64
    @NSManaged public var option4: Int64
    @NSManaged public var questionNum: Int64

}
