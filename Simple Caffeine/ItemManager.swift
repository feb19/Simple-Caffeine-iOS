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
        var item = ItemData()
        item.title = "Coffee"
        item.quantity = "160 ml"
        item.imageName = "item_coffee"
        item.caffeine = 120
        masterData.append(item)
        
        var item2 = ItemData()
        item2.title = "Energy Drink"
        item2.quantity = "160 ml"
        item2.imageName = "item_energydrink"
        item2.caffeine = 120
        masterData.append(item2)
        
        var item3 = ItemData()
        item3.title = "Coke"
        item3.quantity = "160 ml"
        item3.imageName = "item_coke"
        item3.caffeine = 120
        masterData.append(item3)
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
