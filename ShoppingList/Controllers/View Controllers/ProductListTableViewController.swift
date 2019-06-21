//
//  ProductListTableViewController.swift
//  ShoppingList
//
//  Created by Darin Marcus Armstrong on 6/21/19.
//  Copyright © 2019 Darin Marcus Armstrong. All rights reserved.
//

import UIKit
import CoreData

class ProductListTableViewController: UITableViewController, ProductTableViewCellDelegate {
    
    func ProductcellButtonTapped(_ sender: ProductTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else {return}
        let product = ProductController.sharedInstance.fetchedResultsController.object(at: indexPath)
        ProductController.sharedInstance.toggleIsPurchasedFor(product: product)
        sender.update(withProduct: product)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProductController.sharedInstance.fetchedResultsController.delegate = self

    }

    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        addAlertPopUp()
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ProductController.sharedInstance.fetchedResultsController.fetchedObjects?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as? ProductTableViewCell else {return UITableViewCell()}
        let product = ProductController.sharedInstance.fetchedResultsController.object(at: indexPath)
        
        cell.update(withProduct: product)
        cell.delegate = self

        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let product = ProductController.sharedInstance.fetchedResultsController.object(at: indexPath)
            
            ProductController.sharedInstance.remove(product: product)
        }
    }
}

extension ProductListTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            
        case .delete:
            guard let indexPath = indexPath else {return}
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        case .insert:
            guard let newIndexPath = newIndexPath else {return}
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else {return}
            tableView.moveRow(at: oldIndexPath, to: newIndexPath)
            
        case .update:
            guard let indexPath = indexPath else {return}
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

extension ProductListTableViewController{
    func addAlertPopUp(){
        let addAlert = UIAlertController(title: "Add New Item", message: "Type below to add an item name to your shopping list.", preferredStyle: .alert)
        addAlert.addTextField{ (textfield) in
            textfield.placeholder = "Enter item name here..."
        }
        
        addAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        addAlert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak addAlert] (_) in
            guard let textField = addAlert?.textFields?[0], let userText = textField.text else {return}
            ProductController.sharedInstance.add(productWithName: userText)
        }))

    self.present(addAlert, animated: true, completion: nil)
        tableView.reloadData()
    }
}
