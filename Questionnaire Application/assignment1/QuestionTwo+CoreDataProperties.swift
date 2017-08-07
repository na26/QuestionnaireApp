//
//  QuestionTwo+CoreDataProperties.swift
//  assignment1
//
//  Created by Na'Eem Auckburally on 07/11/2016.
//  Copyright © 2016 Na'Eem Auckburally. All rights reserved.
//

import Foundation
import CoreData


extension QuestionTwo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuestionTwo> {
        return NSFetchRequest<QuestionTwo>(entityName: "QuestionTwo");
    }

    @NSManaged public var option1: NSObject?
    @NSManaged public var option2: Int64
    @NSManaged public var option3: Int64
    @NSManaged public var option4: Int64

}
