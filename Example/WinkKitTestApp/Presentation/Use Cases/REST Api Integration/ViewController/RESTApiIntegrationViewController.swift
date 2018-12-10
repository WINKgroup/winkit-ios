//
//  RESTApiIntegrationViewController.swift
//  WinkKitTestApp
//
//  Created by Rico Crescenzio on 03/12/2018.
//  Copyright © 2018 Wink srl. All rights reserved.
//

import WinkKit

class RESTApiIntegrationViewController: CoreViewController<RESTApiIntegrationPresenter>, UITextFieldDelegate {
    
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var loginButton: UIButton!
    @IBOutlet private var activityIndicatorView: UIActivityIndicatorView!
    
    override class var storyboardName: String {
        return Storyboard.main.name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction private func loginButtonDidTap(_ sender: Any) {
        loginDidTap()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            loginDidTap()
        }
        return true
    }
    
    private func loginDidTap() {
        view.endEditing(true)
        presenter.loginDidTap()
    }
}

extension RESTApiIntegrationViewController: RESTApiIntegrationView {
    func showLoading(_ loading: Bool) {
        loginButton.isHidden = loading
        if loading {
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
        }
    }
    
    func show(user: User) {
        let a = UIAlertController(title: "Success", message: user.description, preferredStyle: .alert)
        a.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(a, animated: true, completion: nil)
    }
    
    func show(error: String) {
        let a = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        a.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(a, animated: true, completion: nil)
    }
}
