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
    var entity: String
    
    class func query(entity: String) -> ParrotQuery {
        return ParrotQuery(entity: entity)
    }
    
    init(entity: String) {
        self.entity = entity
    }
}