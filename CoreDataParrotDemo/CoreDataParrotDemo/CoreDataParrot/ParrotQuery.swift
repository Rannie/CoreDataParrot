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

class ParrotQuery: NSObject {
  var entity: String?
  
  var compound: Bool
  var limitCount: UInt
  var batchSize: UInt
  var queryOffset: UInt
  
  var queryPerdicate: NSPredicate?
  var sortDescriptors: Array<NSSortDescriptor>?
  var expressionDescription: NSExpressionDescription?
  
  init(entity: String) {
    self.compound = false
    self.limitCount = 0
    self.batchSize = 0
    self.queryOffset = 0
    self.entity = entity
  }

  class func query(entity: String) -> ParrotQuery {
    return ParrotQuery(entity: entity)
  }

  func same() -> ParrotQuery {
    return ParrotQuery(entity: self.entity!)
  }

  func query(key: String, op: PQOperator, value: AnyObject) {
    if (self.compound == true) {
      println("ParrotQuery: Query is compound. If want to add a condition, can use 'AND:' method!")
      return
    }
    
    var operatorStr = op.rawValue
    var predicate = NSPredicate(format: "%@ %@ \"%@\"", argumentArray: [key, operatorStr, value])
    self.queryPerdicate = predicate
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
  
  
  
  
  
  
  
  
  
  
  
  
  
}