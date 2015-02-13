//
//  ParrotDataImporter.swift
//  CoreDataParrotDemo
//
//  Created by Hanran Liu on 15/1/30.
//  Copyright (c) 2015年 ran. All rights reserved.
//

import Foundation
import CoreData

class ParrotDataImporter: NSObject {
  var batchCount: Int
  
  override init() {
    self.batchCount = 10
  }
  
  func doImport(entity: String, primaryKey: String?, data: Array<AnyObject>, insertHandler: ((oriObj: AnyObject, dataObj: NSManagedObject) -> ())?, updateHandler: ((oriObj: AnyObject, dataObj: NSManagedObject) -> ())?) {
    var count = 0
    var moc = ParrotDataAgent.sharedAgent.backContext
    moc.performBlock { () -> Void in
      for object in data {
        var managedObj: NSManagedObject? = nil
        if primaryKey != nil {
          if var primaryValue: AnyObject? = object.valueForKey(primaryKey!) {
            var query = ParrotQuery(entity: entity)
            query.query(primaryKey!, op: .PQEqual, primaryValue!)
            var result: AnyObject? = query.execute()
            managedObj = result?.firstObject as? NSManagedObject
          } else {
            println("ParrotDataImporter: data object should have primary value!")
          }
        }
        
        if managedObj != nil {
          if updateHandler != nil {
            updateHandler!(oriObj: object, dataObj: managedObj!)
          }
        } else {
          managedObj = NSEntityDescription.insertNewObjectForEntityForName(entity, inManagedObjectContext: moc) as? NSManagedObject
          if insertHandler != nil {
            insertHandler!(oriObj: object, dataObj: managedObj!)
          }
        }
        
        count++
        if (count % self.batchCount == 0 || count == data.count) {
          ParrotDataAgent.sharedAgent.backCommit()
        }
      }
    }
  }
}