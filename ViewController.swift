//
//  ViewController.swift
//  MultiAlert
//
//  Created by Naresh on 24/07/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /// Use case for first alert function
        for i in 1...5 {
            let message = "This is alert number \(i)."
            nonActionAlert(withTitle: "Alert \(i)", message: message, alertTypeOptions: .okAlert)
        }
        
        /// Use case for second alert function
        for i in 1...5 {
            let actions: [MyAlertType] = [.okAlert, .retryAlert]
            let message = "This is alert number \(i)."
            actionAlert(withTitle: "Alert \(i)", message: message, actions: actions) { selectedAction in
                debugPrint("Selected action: \(selectedAction)")
            }
        }


    }
}
