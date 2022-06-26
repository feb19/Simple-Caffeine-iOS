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
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        let item = ItemManager.shared.getData(index: rowIndex)
        save(item: item)
    }
    
    func save(item: ItemData) {
        HealthKitManager.shared.writeCaffeine(value: Double(item.caffeine)) { (error) in
            if let e = error { self.showError(error: e) }
            print(error ?? "no error")
            
            let buttonAction = WKAlertAction(title:"OK", style: .default) { () -> Void in
            }
            
            self.presentAlert(withTitle: "\(item.caffeine)mg", message: "登録しました", preferredStyle: WKAlertControllerStyle.alert, actions: [buttonAction])
        }
    }
    
    func showError(error: Error) {
        let buttonAction = WKAlertAction(title:"OK", style: .default) { () -> Void in
        }
        
        self.presentAlert(withTitle: "Error", message: "\(error.localizedDescription)", preferredStyle: WKAlertControllerStyle.alert, actions: [buttonAction])
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        let items = ItemManager.shared.masterData
        table.setNumberOfRows(items.count, withRowType: "TableRowController")
        
        for (index, val) in items.enumerated() {
            let row = table.rowController(at: index) as! TableRowController
            row.label.setText(val.title)
            row.descriptionLabel.setText(val.quantity)
            row.image.setImageNamed(val.imageName)
        }
        HealthKitManager.shared.register { (error) in
            print(error ?? "no errored")
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
