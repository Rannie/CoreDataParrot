//
//  Person.swift
//  CoreDataParrotDemo
//
//  Created by Hanran Liu on 15/2/11.
//  Copyright (c) 2015年 ran. All rights reserved.
//

import Foundation
import CoreData

//http://stackoverflow.com/questions/26613971/swift-coredata-warning-unable-to-load-class-named
@objc(Person)
class Person: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var age: NSNumber
    @NSManaged var sex: String
    @NSManaged var marriage: NSNumber
    @NSManaged var birthday: NSDate

}