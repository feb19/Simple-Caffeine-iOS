//
//  ViewController.swift
//  Simple Caffeine
//
//  Created by TakahashiNobuhiro on 2019/01/29.
//  Copyright © 2019 feb19. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        register()
    }
    
    private func register() {
        HealthKitManager.shared.register { (e) in
            if e != nil {
                // display error
            } else {
            }
        }
    }
    
    @IBAction func addCaffeineButtonWasTapped(_ sender: UIButton) {
        HealthKitManager.shared.writeCaffeine(value: 60.0)
    }

}

