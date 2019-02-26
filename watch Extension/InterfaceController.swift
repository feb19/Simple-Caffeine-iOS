//
//  InterfaceController.swift
//  watch Extension
//
//  Created by TakahashiNobuhiro on 2019/02/12.
//  Copyright © 2019 feb19. All rights reserved.
//

import WatchKit
import Foundation
import HealthKit

class InterfaceController: WKInterfaceController {
    @IBOutlet weak var table: WKInterfaceTable!
    
    var items = [
        "hoge",
        "hoge2",
        "hoge3",
        "hoge4",
        "hoge5"
    ]
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
//        print(items[rowIndex])
        let item = ItemManager.shared.getData(index: rowIndex)
        
//        presentAlert(withTitle: "OK", message: "登録しました。", preferredStyle: WKAlertControllerStyle.alert, actions: [WKAlertAction.])
        
        save(item: item)
    }
    
    func save(item: ItemData) {
//        let value = NSNumber(value: ItemManager.shared.getValue()).doubleValue
//        guard let data = ItemManager.shared.getData(title: "Drip Coffee") else { return }
        HealthKitManager.shared.writeCaffeine(value: Double(item.caffeine)) { (error) in
//            if let e = error { self.showError(error: e) }
            print(error ?? "no error")
//            DispatchQueue.main.async {
                // saved
//                ItemManager.shared.clear()
//                self.reloadValueLabel()
//                self.itemCollectionView.reloadData()
//                self.loadCaffeine()
//            }
            
            let buttonAction = WKAlertAction(title:"OK", style: .default) { () -> Void in
            }
            
            self.presentAlert(withTitle: "\(item.caffeine)mg", message: "登録しました", preferredStyle: WKAlertControllerStyle.alert, actions: [buttonAction])
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        let items = ItemManager.shared.masterData
        table.setNumberOfRows(items.count, withRowType: "TableRowController")
        
//        print(ItemManager.shared.getData(index: rowIndex))
        
        for (index, val) in items.enumerated() {
            let row = table.rowController(at: index) as! TableRowController
            row.label.setText(val.title)
            row.descriptionLabel.setText(val.quantity)
            row.image.setImageNamed(val.imageName)
        }
        HealthKitManager.shared.register { (error) in
            print(error)
            print("register")
            if error != nil {
                
            }
        }
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
