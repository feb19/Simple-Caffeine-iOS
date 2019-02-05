//
//  ItemCell.swift
//  Simple Caffeine
//
//  Created by Nobuhiro Takahashi on 2019/01/30.
//  Copyright © 2019年 feb19. All rights reserved.
//

import Foundation
import UIKit

protocol ItemCellDelegate {
    func itemValueWasChanged(cell: ItemCell)
}

class ItemCell: UICollectionViewCell {
    
    var delegate: ItemCellDelegate!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var badge: UILabel!
    var item: ItemData!
    
    func configure(item: ItemData) {
        self.item = item
        imageView.image = UIImage(named: item.imageName)
        titleLabel.text = item.title
        descriptionLabel.text = item.quantity
        
        let amount = ItemManager.shared.getAmount(item: item)
        if amount == 0 {
            badge.isHidden = true
        } else {
            badge.isHidden = false
            badge.text = "\(amount)"
        }
    }
    @IBAction func plusButtonWasTapped(_ sender: UIButton) {
        ItemManager.shared.plus(item: self.item)
        
        delegate.itemValueWasChanged(cell: self)
    }
    @IBAction func minusButtonWasTapped(_ sender: UIButton) {
        let _ = ItemManager.shared.minus(item: self.item)
        
        delegate.itemValueWasChanged(cell: self)
    }
}
