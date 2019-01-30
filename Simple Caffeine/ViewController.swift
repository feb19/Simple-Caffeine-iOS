//
//  ViewController.swift
//  Simple Caffeine
//
//  Created by TakahashiNobuhiro on 2019/01/29.
//  Copyright © 2019 feb19. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, ItemCellDelegate {
    

    @IBOutlet weak var myCaffeineTodayLabel: UILabel!
    @IBOutlet weak var myCaffeineYesterdayLabel: UILabel!
    @IBOutlet weak var newCaffeineValueLabel: UILabel!
    @IBOutlet weak var itemCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemCollectionView.delegate = self
        itemCollectionView.dataSource = self
        
        register()
        
        
    }
    
    private func register() {
        HealthKitManager.shared.register { (e) in
            if e != nil {
                self.showError(error: e!)
            } else {
                self.loadCaffeine()
            }
        }
    }
    
    func loadCaffeine() {
        HealthKitManager.shared.getCaffeines(completion: { (error) in
            if let e = error { self.showError(error: e) }
            DispatchQueue.main.async {
                self.myCaffeineTodayLabel.text = "\(HealthKitManager.shared.caffeinesOfToday) mg"
                self.myCaffeineYesterdayLabel.text = "\(HealthKitManager.shared.caffeinesOfYesterday) mg"
            }
        })
    }
    
    @IBAction func saveButtonWasTapped(_ sender: UIButton) {
        let value = NSNumber(value: ItemManager.shared.getValue()).doubleValue
        HealthKitManager.shared.writeCaffeine(value: value) { (error) in
            if let e = error { self.showError(error: e) }
            DispatchQueue.main.async {
                // saved
                ItemManager.shared.clear()
                self.reloadValueLabel()
                self.itemCollectionView.reloadData()
                self.loadCaffeine()
            }
        }
    }
    
    @IBAction func clearButtonWasTapped(_ sender: UIButton) {
        ItemManager.shared.clear()
        reloadValueLabel()
        self.itemCollectionView.reloadData()
    }
    
    func showError(error: Error) {
        if let e = error as? HKError, e.errorCode == HKError.Code.errorAuthorizationDenied.rawValue {
            let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = sb.instantiateViewController(withIdentifier: "HealthKitErrorViewController")
            DispatchQueue.main.async {
                self.navigationController?.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: -
    // MARK: UICollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ItemManager.shared.getCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
        cell.configure(item: ItemManager.shared.getData(index: indexPath.row))
        cell.delegate = self
        return cell
    }
    
    // MARK: -
    // MARK: ItemCellDelegate
    
    func itemValueWasChanged(cell: ItemCell) {
        itemCollectionView.reloadData()
        reloadValueLabel()
    }
    
    func reloadValueLabel() {
        let value = ItemManager.shared.getValue()
        newCaffeineValueLabel.text = "\(value)"
    }
    

}

