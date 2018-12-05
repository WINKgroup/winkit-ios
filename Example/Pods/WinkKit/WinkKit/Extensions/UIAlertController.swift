//
//  UIAlertController.swift
//  Pods
//
//  Created by Rico Crescenzio on 05/05/17.
//
//

import UIKit

/// Add some useful method to create `UIAlertController`.
public extension UIAlertController {
    /**
     
     Show a custom `UIAlertController` that have the passed title, message, completion and buttons;
     You can specify as many button as you want; per each button you must specify a name and you
     can pass a closure that will be run when button is clicked.
     
         showCustomAlert(in: self,
            withTitle: "Title",
            andMessage: "A message",
            completion:  nil,
            buttons: (name: "First button", handler: { action in
                // do something after click
            }),
            (name: "Second button", handler: nil),
            (name: "Third button", handler: { action in
                // do something after click
            }))
     
     - Parameters:
        - viewController: The `UIViewController` in which the alert will be displayed
        - title: The title that will be showed in the alert
        - message: The message thatt will be shoed in the alert
        - completion: A closure that will be run when the alert has been full showed. Could be nil.
        - buttons: The buttons that will be showed; every tuple will be used to generate
                a `UIAlertAction` with the given name and handler.
     
     */
    @discardableResult
    public static func showCustomAlert(in viewController: UIViewController, withTitle title: String, andMessage message: String, completion: (()->Void)? = nil, buttons: (name: String, handler: ((UIAlertAction)->Void)?)...) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        buttons.forEach({ button in
            alert.addAction(UIAlertAction(title: button.name, style: .default, handler: button.handler))
        })
        viewController.present(alert, animated: true, completion: completion)
        
        return alert
    }


    /**
     Show a custom `UIAlertController` that have the passed title, message, completion and a single OK button.
     
     - Parameters:
        - viewController: The `UIViewController` in which the alert will be displayed
        - title: The title that will be showed in the alert
        - message: The message thatt will be shoed in the alert
        - completion: A closure that will be run when the alert has been full showed. Could be nil.
        - okButtonHandler: A closure that will be run when OK button is clicked. Could be nil.
     */
    @discardableResult
    public static func showOkAlert(in viewController: UIViewController, withTitle title: String, andMessage message: String, completion: (()-> Void)? = nil, okButtonHandler: ((UIAlertAction)->Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: okButtonHandler))
        viewController.present(alert, animated: true, completion: completion)
        
        return alert
    }

}
