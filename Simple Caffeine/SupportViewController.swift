//
//  SupportViewController.swift
//  Simple Caffeine
//
//  Created by Nobuhiro Takahashi on 2019/01/29.
//  Copyright © 2019年 feb19. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

class SupportViewController: UITableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1, indexPath.row == 0 {
            goPrivacyPolicy()
        }
    }
    
    @IBAction func doneButtonWasTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func goPrivacyPolicy() {
        let url = URL(string: "http://feb19.jp/simplecaffeine/")!
        let safari = SFSafariViewController(url: url)
        self.present(safari, animated: true, completion: nil)
    }
    
    func goReview() {
        
    }
}
