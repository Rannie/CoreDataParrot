//
//  AppDelegate.swift
//  CoreDataParrotDemo
//
//  Created by Hanran Liu on 15/1/30.
//  Copyright (c) 2015年 ran. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  var dataAgent: ParrotDataAgent?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    println(path)
    
    self.setupDatabase()
//    self.generateDataAndCommit()
//    self.operatorQuery()
//    self.functionQuery()
//    self.sortQuery()
    self.compoundQuery()
    return true
  }
  
  func setupDatabase() {
    var momdURL = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd")
    var storeURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!.URLByAppendingPathComponent("ParrotData.sqlite")
    ParrotDataAgent.setup(momdURL: momdURL!, storeURL: storeURL)
    self.dataAgent = ParrotDataAgent.sharedAgent
  }
  
  func generateDataAndCommit() {
    var p1: Person = NSEntityDescription.insertNewObjectForEntityForName("Person", inManagedObjectContext: self.dataAgent!.mainContext) as Person
    p1.name = "Ronaldo"
    p1.age = 30
    p1.sex = "male"
    
    var p2: Person = NSEntityDescription.insertNewObjectForEntityForName("Person", inManagedObjectContext: self.dataAgent!.mainContext) as Person
    p2.name = "Kobe"
    p2.age = 33
    p2.birthday = NSDate()
    p2.marriage = 1
    
    self.dataAgent!.commit()
  }
  
  func operatorQuery() {
    var query = ParrotQuery(entity: "Person")
    query.query("name", op: PQOperator.PQEqual, "Kobe")
    var result: AnyObject? = query.execute()
    println(result)
  }
  
  func functionQuery() {
    var query = ParrotQuery(entity: "Person")
    query.query("age", function: .PQAverage)
    var result: AnyObject? = query.execute()
    println(result)
  }
  
  func sortQuery() {
    var query = ParrotQuery(entity: "Person")
    query.sort("age", ascending: true)
    var result: AnyObject? = query.execute()
    println(result)
  }
  
  func compoundQuery() {
    var queryAge = ParrotQuery(entity: "Person")
    queryAge.query("age", op: .PQGreaterOrEqual, 20)
    
    var queryName = ParrotQuery(entity: "Person")
    queryName.query("name", op: .PQEqual, "Kobe")
    
    var query = queryAge.and(queryName)
    var result: AnyObject? = query?.execute()
    println(result)
  }
}

