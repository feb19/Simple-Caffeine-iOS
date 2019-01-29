//
//  HealthKitManager.swift
//  Daily Health Missions
//
//  Created by Nobuhiro Takahashi on 2018/10/23.
//  Copyright © 2018年 feb19. All rights reserved.
//

import Foundation
import HealthKit
import HealthKitUI

class HealthKitManager {
    static let shared = HealthKitManager()
    private let store = HKHealthStore()
    private var workouts = [HKWorkout]()
    
    func register(completion: ((_ error:Error?) -> Void)!) {
        let readToType = Set(arrayLiteral:
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCaffeine) // カフェイン 🥕
        )
        let shareToType = Set(arrayLiteral:
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCaffeine) // カフェイン 🥕
        )
        store.requestAuthorization(toShare: shareToType as? Set<HKSampleType>, read: readToType as? Set<HKObjectType>) { (s, e) in
            print("requestAuthorization: \(s)")
            if e != nil {
                completion(e)
            } else {
                completion(nil)
            }
        }
    }
    
    func getCaffeines() {
        
    }
    
    func writeCaffeine(value: Double){
        let count = HKUnit.gramUnit(with: HKMetricPrefix.milli)
        let type = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCaffeine)
        let quantity = HKQuantity(unit: count, doubleValue: value)
        let sample = HKQuantitySample(type: type!, quantity: quantity, start: Date(), end: Date())
        store.save(sample, withCompletion: {success, error in
            if let e = error {
                print("Error: \(e.localizedDescription)")
                return
            }
            print(success ? "Success" : "Failure")
            
            // UI でフィードバックを与えるために処理をメインスレッドに戻す
        })
    }}
