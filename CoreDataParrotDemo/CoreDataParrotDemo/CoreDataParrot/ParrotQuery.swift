//
//  ParrotQuery.swift
//  CoreDataParrotDemo
//
//  Created by Hanran Liu on 15/1/30.
//  Copyright (c) 2015年 ran. All rights reserved.
//

import Foundation
import CoreData

enum PQOperator: String {
  case PQEqual = "=="
  case PQGreaterThan = ">"
  case PQLessThan = "<"
  case PQGreaterOrEqual = ">="
  case PQLessOrEqual = "<="
  case PQNot = "!="
  case PQBetween = "BETWEEN"
  case PQBeginsWith = "BEGINSWITH"
  case PQEndsWith = "ENDSWITH"
  case PQContains = "CONTAINS"
  case PQLike = "LIKE[cd]"
  case PQMathes = "MATCHES"
  case PQIn = "IN"
}

enum PQFunction: String {
  case PQMax = "max:"
  case PQMin = "min:"
  case PQCount = "count:"
  case PQSum = "sum:"
  case PQAverage = "average:"
}

class ParrotQuery: NSObject, NSCopying {
  var entity: String
  
  var compound: Bool
  var limitCount: UInt
  var batchSize: UInt
  var queryOffset: UInt
  
  var queryPredicate: NSPredicate?
  var sortDescriptors: Array<NSSortDescriptor>
  var expressionDescription: NSExpressionDescription?
  
  init(entity: String) {
    self.compound = false
    self.limitCount = 0
    self.batchSize = 0
    self.queryOffset = 0
    self.entity = entity
    self.sortDescriptors = []
  }

  class func query(entity: String) -> ParrotQuery {
    return ParrotQuery(entity: entity)
  }
  
  func copyWithZone(zone: NSZone) -> AnyObject {
    var query = ParrotQuery.allocWithZone(zone)
    query.entity = self.entity
    query.queryPredicate = self.queryPredicate
    query.expressionDescription = self.expressionDescription;
    query.sortDescriptors = self.sortDescriptors;
    query.limitCount = self.limitCount;
    query.batchSize = self.batchSize;
    query.queryOffset = self.queryOffset;
    return query
  }

  func same() -> ParrotQuery {
    return ParrotQuery(entity: self.entity)
  }

  func query(key: String, op: PQOperator, value: AnyObject) {
    if (self.compound == true) {
      println("ParrotQuery: Query is compound. If want to add a condition, can use 'AND:' method!")
      return
    }
    
    var operatorStr = op.rawValue
    var predicate = NSPredicate(format: "%@ %@ \"%@\"", argumentArray: [key, operatorStr, value])
    self.queryPredicate = predicate
  }
  
  func query(key: String, function: PQFunction) {
    var keypathExpression = NSExpression(forKeyPath: key)
    var expression = NSExpression(forFunction: function.rawValue, arguments:[keypathExpression])
    
    var expDescription = NSExpressionDescription()
    expDescription.name = key
    expDescription.expression = expression
    expDescription.expressionResultType = .UndefinedAttributeType
    
    self.expressionDescription = expDescription
  }
  
  func or(query: ParrotQuery) -> ParrotQuery? {
    if (self.queryPredicate == nil || query.queryPredicate == nil) {
      println("ParrotQuery: Warning! Compound queries must have predicate!")
      return nil
    }
    var newQuery = self.copy() as ParrotQuery
    newQuery.queryPredicate = NSCompoundPredicate.orPredicateWithSubpredicates([query.queryPredicate!, self.queryPredicate!])
    newQuery.compound = true
    return newQuery;
  }
  
  func and(query: ParrotQuery) -> ParrotQuery? {
    if (self.queryPredicate == nil || query.queryPredicate == nil) {
      println("ParrotQuery: Warning! Compound queries must have predicate!")
      return nil
    }
    var newQuery = self.copy() as ParrotQuery
    newQuery.queryPredicate = NSCompoundPredicate.andPredicateWithSubpredicates([query.queryPredicate!, self.queryPredicate!])
    newQuery.compound = true
    return newQuery
  }
  
  func not() {
    if (self.queryPredicate == nil) {
      println("ParrotQuery: Warning! Compound query must have predicate!")
      return
    }
    self.queryPredicate = NSCompoundPredicate.notPredicateWithSubpredicate(self.queryPredicate!)
    self.compound = true
  }
  
  func sort(key: String, ascending: Bool) {
    var sortDescriptor = NSSortDescriptor(key: key, ascending: ascending)
    self.sortDescriptors.append(sortDescriptor)
  }
  
  func sort(key: String, ascending: Bool, comparator: NSComparator) {
    var sortDescriptor = NSSortDescriptor(key: key, ascending: ascending, comparator: comparator)
    self.sortDescriptors.append(sortDescriptor)
  }
}