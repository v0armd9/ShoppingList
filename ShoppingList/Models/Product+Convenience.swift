//
//  Product+Convenience.swift
//  ShoppingList
//
//  Created by Darin Marcus Armstrong on 6/21/19.
//  Copyright © 2019 Darin Marcus Armstrong. All rights reserved.
//

import Foundation
import CoreData

extension Product {
    @discardableResult
    convenience init(name: String, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        
        self.name = name
    }
}
