//
//  ParrotDataManager.swift
//  CoreDataParrotDemo
//
//  Created by Hanran Liu on 15/1/30.
//  Copyright (c) 2015年 ran. All rights reserved.
//

import Foundation
import CoreData

class ParrotDataStack: NSObject {
  var momdURL: NSURL
  var storeURL: NSURL
  
  let mainManagedContext: NSManagedObjectContext
  let backManagedContext: NSManagedObjectContext
  let managedObjectModel: NSManagedObjectModel
  let persistentCoordinator: NSPersistentStoreCoordinator
  
  init(momdURL: NSURL, storeURL: NSURL) {
    self.momdURL = momdURL
    self.storeURL = storeURL
    
    self.managedObjectModel = NSManagedObjectModel(contentsOfURL: self.momdURL)!
    self.persistentCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    self.mainManagedContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    self.backManagedContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
    
    var options = [NSMigratePersistentStoresAutomaticallyOption: true,
                        NSInferMappingModelAutomaticallyOption: true]
    var error: NSError? = nil
    var store = self.persistentCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: self.storeURL, options: options, error: &error)
    if store == nil {
      println("DBManager: Error adding persistent store: \(error)")
    }
    
    self.mainManagedContext.persistentStoreCoordinator = self.persistentCoordinator
    self.backManagedContext.persistentStoreCoordinator = self.persistentCoordinator
    
    self.mainManagedContext.undoManager = NSUndoManager()
    self.backManagedContext.undoManager = nil
    
    super.init()
    
    self.observeContextDidSavingNotification()
  }
  
  func observeContextDidSavingNotification() {
    NSNotificationCenter.defaultCenter().addObserverForName(NSManagedObjectContextDidSaveNotification, object: nil, queue: nil) { (notification: NSNotification?) -> Void in
      if (notification?.object as NSManagedObjectContext != self.mainManagedContext) {
        self.mainManagedContext.performBlock({ () -> Void in
          self.mainManagedContext.mergeChangesFromContextDidSaveNotification(notification!)
        })
      }
    }
  }
  
  func saveContext(managedObjectContext: NSManagedObjectContext, success: () -> Void, failure: (error: NSError) -> Void) {
    var error: NSError? = nil
    if managedObjectContext.hasChanges && !managedObjectContext.save(&error) {
      failure(error: error!)
    } else {
      success()
    }
  }
}