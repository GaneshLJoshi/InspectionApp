//
//  UIUtility.swift
//  InspectionApp
//
//  Created by Ganesh Joshi on 16/07/24.
//

import UIKit

extension UIButton {
    static func createButton(withTitle title: String, target: Any?, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(target, action: action, for: .touchUpInside)
        return button
    }
}

extension UITextField {
    static func createTextField(placeholder: String, isSecure: Bool = false, capitalization: UITextAutocapitalizationType = .none) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = isSecure
        textField.autocapitalizationType = capitalization
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
}

extension UIView {
    func addConstraints(_ constraints: [NSLayoutConstraint]) {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
    }
}

func showAlert(from viewController: UIViewController, withTitle title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    viewController.present(alert, animated: true, completion: nil)
}
