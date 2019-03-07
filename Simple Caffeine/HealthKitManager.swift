//
//  HealthKitManager.swift
//  Daily Health Missions
//
//  Created by Nobuhiro Takahashi on 2018/10/23.
//  Copyright © 2018年 feb19. All rights reserved.
//

import Foundation
import HealthKit

protocol HealthKitManagerDelegate {
    func databaseWasUpdate(healthKitManager: HealthKitManager)
}

class HealthKitManager {
    static let shared = HealthKitManager()
    private let store = HKHealthStore()
    private var workouts = [HKWorkout]()
    
    var caffeinesOfYesterday = 0
    var caffeinesOfToday = 0
    var delegates: [HealthKitManagerDelegate?] = []
    
    func add(delegate: HealthKitManagerDelegate) {
        delegates.append(delegate)
    }
    
    func updateDelegate() {
        for delegate in delegates {
            delegate?.databaseWasUpdate(healthKitManager: self)
        }
    }
    
    func register(completion: ((_ error:Error?) -> Void)!) {
        let readToType = Set(arrayLiteral:
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCaffeine) // カフェイン 🥕
        )
        let shareToType = Set(arrayLiteral:
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCaffeine) // カフェイン 🥕
        )
        store.requestAuthorization(toShare: shareToType as? Set<HKSampleType>, read: readToType as? Set<HKObjectType>) { (success, error) in
            print("requestAuthorization: \(success)")
            if error != nil {
                print("Error: \(error!.localizedDescription)")
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func setObserver() {
        print("execute observerQuery")
        let type = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCaffeine)!
        let observerQuery: HKObserverQuery = HKObserverQuery(sampleType: type, predicate: nil) { (query: HKObserverQuery, completion: HKObserverQueryCompletionHandler, error: Error?) in
            print("database was updated")
            self.updateDelegate()
        }
        
        store.execute(observerQuery)
    }
    
    func getCaffeines(completion: ((_ error:Error?) -> Void)!) {
        print("getCaffeines")
        let count = HKUnit.gramUnit(with: HKMetricPrefix.milli)
        let type = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCaffeine)
        let now = Date()
        let startOfToday = Calendar.current.startOfDay(for: now)
        let yesterday = Calendar.current.date(byAdding: DateComponents(day: -1),
                                                 to: now)!
        let startOfYesterday = Calendar.current.startOfDay(for: yesterday)
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfYesterday,
                                                     end: now,
                                                     options: .strictStartDate)
        var interval = DateComponents()
        interval.day = 1
        let query = HKStatisticsCollectionQuery(quantityType: type!,
                                                 quantitySamplePredicate: predicate,
                                                 options: [.cumulativeSum],
                                                 anchorDate: startOfYesterday as Date,
                                                 intervalComponents:interval)
        
        query.initialResultsHandler = { query, results, error in
            if error != nil {
                print("Error: \(error!.localizedDescription)")
                completion(error)
                return
            }
            
            if let myResults = results {
                let f = DateFormatter()
                f.dateStyle = .medium
                f.timeStyle = .medium
                f.locale = Locale(identifier: "ja_JP")
                print("\t\(f.string(from: startOfYesterday)) - \(f.string(from: now))")
                
                myResults.enumerateStatistics(from: startOfYesterday, to: now) {
                    statistics, stop in
                    let dateString = f.string(from: statistics.startDate)
                    
                    if let quantity = statistics.sumQuantity() {
                        let value = floor(quantity.doubleValue(for: count))
                        print("\t\t\(dateString): \(NSNumber(value: value).intValue) mg")
                        if (statistics.startDate == startOfYesterday) {
                            print("yesterday!")
                            self.caffeinesOfYesterday = NSNumber(value: value).intValue
                        }
                        if (statistics.startDate == startOfToday) {
                            print("today!")
                            self.caffeinesOfToday = NSNumber(value: value).intValue
                        }
                    }
                }
                completion(nil)
            }
        }
        store.execute(query)
    }
    
    func writeCaffeine(value: Double, completion: ((_ error:Error?) -> Void)!) {
        let count = HKUnit.gramUnit(with: HKMetricPrefix.milli)
        let type = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCaffeine)
        let quantity = HKQuantity(unit: count, doubleValue: value)
        let sample = HKQuantitySample(type: type!, quantity: quantity, start: Date(), end: Date())
        store.save(sample, withCompletion: {success, error in
            print(success ? "Success" : "Failure")
            if let e = error {
                print("Error: \(e.localizedDescription)")
                completion(e)
                return
            } else {
                completion(nil)
            }
        })
    }}
