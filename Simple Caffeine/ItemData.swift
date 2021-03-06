//
//  ItemData.swift
//  Simple Caffeine
//
//  Created by Nobuhiro Takahashi on 2019/01/30.
//  Copyright © 2019年 feb19. All rights reserved.
//

import Foundation

struct ItemData {
    var title: String = "Coffee"
    var quantity: String = "0 ml"
    var imageName: String = "item_coffee"
    var caffeine = 120
    
    init() {
        
    }
    
    init(title: String, quantity: String, imageName: String, caffeine: Int) {
        self.title = title
        self.quantity = quantity
        self.imageName = imageName
        self.caffeine = caffeine
    }
}

