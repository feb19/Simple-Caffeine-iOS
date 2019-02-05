//
//  ItemManager.swift
//  Simple Caffeine
//
//  Created by Nobuhiro Takahashi on 2019/01/30.
//  Copyright © 2019年 feb19. All rights reserved.
//

import Foundation

class ItemManager {
    static let shared = ItemManager()
    var masterData = Array<ItemData>()
    var value = 0
    var items = Array<ItemData>()
    
    init () {
        let path = Bundle.main.path(forResource: "Item", ofType:"plist" )
        if let dictArray = NSArray(contentsOfFile: path!) {
            for item in dictArray {
                if let dict = item as? NSDictionary {
                    let title = dict["title"] as! String
                    let quantity = dict["quantity"] as! String
                    let imageName = dict["imageName"] as! String
                    let caffeine = dict["caffeine"] as! Int
                    let item = ItemData(title: title, quantity: quantity, imageName: imageName, caffeine: caffeine)
                    masterData.append(item)
                }
            }
        }
    }
    
    func getCount() -> Int {
        return masterData.count
    }
    
    func getData(index: Int) -> ItemData {
        return masterData[index]
    }
    
    func getAmount(item: ItemData) -> Int {
        var totalAmount = 0
        for i in 0..<items.count {
            if items[i].title == item.title {
                totalAmount += 1
            }
        }
        return totalAmount
    }
    
    func plus(item: ItemData) {
        items.append(item)
        updateValue()
    }
    
    func getValue() -> Int {
        return value
    }
    
    func updateValue() {
        var totalValue = 0
        for i in 0..<items.count {
            totalValue += items[i].caffeine
        }
        value = totalValue
    }
    
    func minus(item: ItemData) -> ItemData? {
        updateValue()
        for i in 0..<items.count {
            if items[i].title == item.title {
                let item = items.remove(at: i)
                updateValue()
                return item
            }
        }
        return nil
    }
    
    func clear() {
        items.removeAll()
        value = 0
    }
}
