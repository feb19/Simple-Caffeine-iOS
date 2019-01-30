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
        item.title = "Drip Coffee"
        item.quantity = "250 ml"
        item.imageName = "item_coffee"
        item.caffeine = 90
        masterData.append(item)
        
        var item3 = ItemData()
        item3.title = "Coke"
        item3.quantity = "355 ml"
        item3.imageName = "item_coke"
        item3.caffeine = 40
        masterData.append(item3)
        
        var item4 = ItemData()
        item4.title = "Redbull Short"
        item4.quantity = "185 ml"
        item4.imageName = "item_redbull"
        item4.caffeine = 80
        masterData.append(item4)
        
        var item5 = ItemData()
        item5.title = "Redbull Long"
        item5.quantity = "250 ml"
        item5.imageName = "item_redbull"
        item5.caffeine = 80
        masterData.append(item5)
        
        var item2 = ItemData()
        item2.title = "MonsterEnergy"
        item2.quantity = "355 ml"
        item2.imageName = "item_monsterenergy"
        item2.caffeine = 142
        masterData.append(item2)
        
        
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
