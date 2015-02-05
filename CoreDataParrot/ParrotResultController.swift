//
//  ParrotResultController.swift
//  CoreDataParrotDemo
//
//  Created by Hanran Liu on 15/1/30.
//  Copyright (c) 2015年 ran. All rights reserved.
//

import Foundation
import CoreData

class ParrotResultController: NSFetchedResultsController {
  class func parrotResultController(query: ParrotQuery, sectionNameKeyPath: String?, cacheName: String?) -> ParrotResultController {
    var dataAgent = ParrotDataAgent.sharedAgent
    var fetchRequest = dataAgent.buildRequest(query)
    var frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataAgent.mainContext, sectionNameKeyPath: sectionNameKeyPath, cacheName: cacheName) as ParrotResultController
    return frc
  }
  
  class func parrotResultController(query: ParrotQuery) -> ParrotResultController {
    return ParrotResultController.parrotResultController(query, sectionNameKeyPath: nil, cacheName: nil)
  }
  
  func performQuery() {
    ParrotDataAgent.sharedAgent.excute(self)
  }
}