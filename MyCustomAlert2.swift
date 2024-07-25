//
//  MyCustomAlert2.swift
//  MultiAlert
//
//  Created by Naresh on 25/07/24.
//


import Foundation
import UIKit

/// Define your required alert action texts here - (with String Localization **if required)
enum MyAlertType : String {
    
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    static func getTitleFor(title:MyAlertType) -> String {
        return title.localizedString()
    }
    case doneAlert = "Done"
    case okAlert = "Ok"
    case cancelAlert = "Cancel"
    case closeAlert = "Close"
    case retryAlert = "Retry"
}

/// Alert class
class MyAlertManager {
    static let shared = MyAlertManager()
    private var alertQueue: [UIAlertController] = []
    private var isPresenting = false

    private init() {}

    func showAlert(_ alert: UIAlertController, in viewController: UIViewController) {
        alertQueue.append(alert)
        presentNextAlert(in: viewController)
    }

    private func presentNextAlert(in viewController: UIViewController) {
        guard !isPresenting, !alertQueue.isEmpty else { return }

        isPresenting = true
        let alert = alertQueue.removeFirst()

        // Present the alert
        DispatchQueue.main.async {
            viewController.present(alert, animated: true, completion: nil)
        }
    }

    func alertDismissed() {
        isPresenting = false
        
        if let topController = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?
            .windows
            .first(where: \.isKeyWindow)?
            .rootViewController {
            
            // Dismiss all presented view controllers
            while topController.presentedViewController != nil {
                topController.presentedViewController?.dismiss(animated: false, completion: nil)
            }
            
            // Present the next alert in the queue
            presentNextAlert(in: topController)
        }
    }

}

extension UIViewController {

    func getAlertLocalize2(_ title: MyAlertType) -> String {
        switch title {
        case .doneAlert:
            return "Done"
        case .okAlert:
            return "Ok"
        case .cancelAlert:
            return "Cancel"
        case .closeAlert:
            return "Close"
        case .retryAlert:
            return "Retry"
        }
    }

    func nonActionAlert(withTitle title: String = "Alert", message: String, alertTypeOptions: MyAlertType) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

            // Accessing alert view backgroundColor:
            alertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.lightGray

            let okAction = UIAlertAction(title: self.getAlertLocalize2(alertTypeOptions), style: .default) { _ in
                MyAlertManager.shared.alertDismissed()
            }
            if alertTypeOptions == .okAlert || alertTypeOptions == .doneAlert {
                okAction.setValue(UIColor.green, forKey: "yourTextColor")
            } else {
                okAction.setValue(UIColor.red, forKey: "yourTextColor")
            }

            alertController.addAction(okAction)

            if let topController = self.topMostViewController() {
                MyAlertManager.shared.showAlert(alertController, in: topController)
            }
        }
    }

    func actionAlert(withTitle title: String, message: String, actions: [MyAlertType], handler: @escaping (MyAlertType) -> Void) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

            for action in actions {
                let actionButton = UIAlertAction(title: self.getAlertLocalize2(action), style: .default) { _ in
                    handler(action)
                    MyAlertManager.shared.alertDismissed()
                }
                switch action {
                case .okAlert, .doneAlert:
                    actionButton.setValue(UIColor.green, forKey: "yourTextColor")
                case .retryAlert:
                    actionButton.setValue(UIColor.red, forKey: "yourTextColor")
                default:
                    actionButton.setValue(UIColor.blue, forKey: "yourTextColor")
                }
                alertController.addAction(actionButton)
            }

            if let topController = self.topMostViewController() {
                MyAlertManager.shared.showAlert(alertController, in: topController)
            }
        }
    }

    private func topMostViewController() -> UIViewController? {
        var topController = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?
            .windows
            .first(where: \.isKeyWindow)?
            .rootViewController

        while let presentedViewController = topController?.presentedViewController {
            topController = presentedViewController
        }

        return topController
    }
    
}


