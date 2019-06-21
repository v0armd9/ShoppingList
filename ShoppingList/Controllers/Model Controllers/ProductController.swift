//
//  ProductController.swift
//  ShoppingList
//
//  Created by Darin Marcus Armstrong on 6/21/19.
//  Copyright © 2019 Darin Marcus Armstrong. All rights reserved.
//

import Foundation
import CoreData

class ProductController {
    static let sharedInstance = ProductController()
    
    let fetchedResultsController: NSFetchedResultsController<Product>
    
    init() {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "isPurchased", ascending: true)]
        
        let resultsController: NSFetchedResultsController<Product> = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController = resultsController
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error fetching Data: \(error.localizedDescription)")
        }
    }
    
    //create
    func add(productWithName name: String){
        Product(name: name)
        saveToPersistentStore()
    }
    
    //update
    func update(product: Product, name: String) {
        product.name = name
        saveToPersistentStore()
    }
    
    //delete
    func remove(product: Product) {
        product.managedObjectContext?.delete(product)
        saveToPersistentStore()
    }
    
    func toggleIsPurchasedFor(product: Product) {
        product.isPurchased = !product.isPurchased
    }
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.context
        do {
            try moc.save()
        } catch {
            print("Error saving to persistent storage: \(error.localizedDescription)")
        }
    }
}
