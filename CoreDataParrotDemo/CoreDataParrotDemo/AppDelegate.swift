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
    self.generateDataAndCommit()
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
}

