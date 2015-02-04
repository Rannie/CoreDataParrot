//
//  ParrotDataAgent.swift
//  CoreDataParrotDemo
//
//  Created by Hanran Liu on 15/1/30.
//  Copyright (c) 2015年 ran. All rights reserved.
//

import Foundation
import CoreData

let ParrotDataDomain    = "ParrotDataDomain"
let ParrotQueryTempKey  = "ParrotQueryTempKey"

public class ParrotDataAgent: NSObject {
  var databaseStack: ParrotDataStack
  var mainContext: NSManagedObjectContext
  var backContext: NSManagedObjectContext
  
  var queryCache: [String: ParrotQuery] = [:]
  
  public class var sharedAgent: ParrotDataAgent {
    return sharedInstance!
  }
  
  class func setup(#momdURL: NSURL, storeURL: NSURL) {
    sharedInstance = ParrotDataAgent(momdURL: momdURL, storeURL: storeURL)
  }
  
  init(momdURL: NSURL, storeURL: NSURL) {
    self.databaseStack = ParrotDataStack(momdURL: momdURL, storeURL: storeURL)
    self.mainContext = databaseStack.mainManagedContext
    self.backContext = databaseStack.backManagedContext
  }
  
  func commit() {
    self.databaseStack.saveContext(self.mainContext, success: { () -> Void in
      println("ParrotAgent: Insert or update object success")
    }) { (error) -> Void in
      println("ParrotAgent: Insert or update object failed, error: \(error)")
    }
  }
  
  func backCommit() {
    self.databaseStack.saveContext(self.backContext, success: { () -> Void in}) { (error) -> Void in
      println("ParrotAgent: Background save failed, error: \(error)")
    }
  }
  
  func deleteObject(object: NSManagedObject) {
    self.deleteObjects([object], success: { () -> Void in
      println("ParrotAgent: Delete \(object) success!")
    }) { (error) -> Void in
      println("ParrotAgent: Delete \(object) failed, error: \(error)")
    }
  }
  
  func deleteObjects(objects: Array<NSManagedObject>) {
    self.deleteObjects(objects, success: { () -> Void in
      println("ParrotAgent: Delete objects success!")
    }) { (error) -> Void in
      println("ParrotAgent: Delete objects failed, error: \(error)")
    }
  }
  
  func excute(#query: ParrotQuery) -> AnyObject? {
    self.cacheQuery(query, key: ParrotQueryTempKey)
    
    var request = self.buildRequest(query)
    
    var ret: AnyObject? = nil
    var removeClosure = { () -> () in
      self.removeCacheQuery(ParrotQueryTempKey)
    }
    
    self.query(request: request, success: { (result) -> Void in
      if query.expressionDescription == nil {
        ret = result
      } else {
        var dict = result?.firstObject as NSDictionary
        ret = dict[query.expressionDescription!.name]
      }
      removeClosure()
    }) { (error) -> Void in
      println("ParrotAgent: Query(\(query)) excute failed, error: \(error)")
      removeClosure()
    }
    return ret
  }
  
  func excute(controller: ParrotResultController) {
    var error: NSError? = nil
    if controller.performFetch(&error) == false {
      println("ParrotAgent: ParrotResultController fetch failed, error: \(error)")
    }
  }
  
  func buildRequest(query: ParrotQuery) -> NSFetchRequest {
    var request = NSFetchRequest(entityName: query.entity)
    var entityDescription = NSEntityDescription.entityForName(query.entity, inManagedObjectContext: self.mainContext)
    
    request.entity = entityDescription
    request.sortDescriptors = query.sortDescriptors
    request.fetchBatchSize = query.batchSize
    request.fetchOffset = query.queryOffset
    request.fetchLimit = query.limitCount
    request.predicate = query.queryPredicate
    
    if query.expressionDescription != nil {
      request.propertiesToFetch = [query.expressionDescription!]
      request.resultType = .DictionaryResultType
    }
    
    return request
  }
  
  func cacheQuery(query: ParrotQuery, key: String) {
    self.queryCache[key] = query
  }
  
  func query(cacheKey: String) -> ParrotQuery? {
    return self.queryCache[cacheKey]
  }
  
  func removeCacheQuery(key: String) {
    self.queryCache.removeValueForKey(key)
  }
  
  func undo() {
    self.mainContext.undo()
  }
  
  func redo() {
    self.mainContext.redo()
  }
  
  func rollback() {
    self.mainContext.rollback()
  }
  
  func reset() {
    self.mainContext.reset()
  }
  
  func reduceMemory() {
    self.queryCache.removeAll(keepCapacity: false)
    self.mainContext.undoManager!.removeAllActions()
  }
  
  private func query(#request: NSFetchRequest, success: (result: AnyObject?) -> Void, failure: (error: NSError) -> Void) {
    var error: NSError? = nil
    var result = self.mainContext.executeFetchRequest(request, error: &error)
    if error != nil {
      failure(error: error!)
    } else {
      success(result: result!)
    }
  }
  
  private func deleteObjects(objects: Array<NSManagedObject>, success: () -> Void, failure: (error: NSError) -> Void) {
    for managedObject in objects {
      if managedObject.managedObjectContext != self.mainContext {
        var error = NSError(domain: ParrotDataDomain, code: 0, userInfo: nil)
        failure(error: error)
      } else {
        self.mainContext.deleteObject(managedObject)
      }
    }
    self.databaseStack.saveContext(self.mainContext, success: success, failure: failure)
  }
}

private var sharedInstance: ParrotDataAgent? = nil