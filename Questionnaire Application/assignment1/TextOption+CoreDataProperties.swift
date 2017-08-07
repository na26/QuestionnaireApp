//
//  TextOption+CoreDataProperties.swift
//  assignment1
//
//  Created by Na'Eem Auckburally on 10/11/2016.
//  Copyright © 2016 Na'Eem Auckburally. All rights reserved.
//

import Foundation
import CoreData


extension TextOption {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TextOption> {
        return NSFetchRequest<TextOption>(entityName: "TextOption");
    }

    @NSManaged public var choice: String?
    @NSManaged public var questionNum: Int64

}
