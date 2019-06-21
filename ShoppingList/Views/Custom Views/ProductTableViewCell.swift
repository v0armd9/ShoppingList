//
//  ProductTableViewCell.swift
//  ShoppingList
//
//  Created by Darin Marcus Armstrong on 6/21/19.
//  Copyright © 2019 Darin Marcus Armstrong. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    var delegate: ButtonTableViewCellDelegate?
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var purchasedButton: UIButton!
    @IBAction func buttonTapped(_ sender: UIButton) {
        delegate?.ProductcellButtonTapped(self)
    }
    
    func updateButton(_ isPurchased: Bool) {
        if isPurchased {
            purchasedButton.setImage(#imageLiteral(resourceName: "complete"), for: .normal)
        } else {
            purchasedButton.setImage(#imageLiteral(resourceName: "incomplete"), for: .normal)
        }
    }
}

extension ProductTableViewCell {
    
    func update(withProduct product: Product) {
        productNameLabel.text = product.name
        updateButton(product.isPurchased)
    }
}

protocol ButtonTableViewCellDelegate {
    func ProductcellButtonTapped(_ sender: ProductTableViewCell)
}
