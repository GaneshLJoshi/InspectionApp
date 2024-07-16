//
//  LoginViewController.swift
//  InspectionApp
//
//  Created by Ganesh Joshi on 13/07/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emailTextField: UITextField = .createTextField(placeholder: "Email")

    private let passwordTextField: UITextField = .createTextField(placeholder: "Password", isSecure: true)
    
    private let loginButton: UIButton = .createButton(withTitle: "Login", target: self, action: #selector(loginButtonTapped))
    
    private let registerButton: UIButton = .createButton(withTitle: "Register", target: self, action: #selector(registerButtonTapped))


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupKeyboardObservers()
    }
    
    @objc private func loginButtonTapped() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        validateInputs(email: email, password: password)
        
        viewModel.login { [weak self] success, errorMessage in
            
            guard let self = self else { return }
            
            if success {
                print("Login successful")
                UserDefaults.standard.setValue(email, forKey: "email")
                self.dismiss(animated: true, completion: nil)
            } else {
                self.showAlert(message: errorMessage ?? "")
            }
        }
        
        // Dismiss the keyboard
        view.endEditing(true)
    }
    
    private func validateInputs(email: String, password: String) {
        
        if !viewModel.isValidEmail(email) {
            showAlert(message: "Please enter a valid email address.")
            return
        }
        
        if !viewModel.isValidPassword(password) {
            showAlert(message: "Password must be at least 4 characters long.")
            return
        }
        
        viewModel.email = email
        viewModel.password = password
    }
    
    @objc private func registerButtonTapped() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        validateInputs(email: email, password: password)
        
        viewModel.register { [weak self] success, errorMessage in
            
            guard let self = self else { return }
            
            if success {
                print("Registration successful")
                let alert = UIAlertController(title: "", message: "Registration successful. Please proceed for login.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        // Dismiss the keyboard
        view.endEditing(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension LoginViewController {
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardHeight = keyboardFrame.height
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
}

extension LoginViewController {
    
    private func setupUI() {
        view.addSubview(scrollView)
        self.title = "Login"
        scrollView.addSubview(containerView)
        containerView.addSubview(emailTextField)
        containerView.addSubview(passwordTextField)
        containerView.addSubview(loginButton)
        containerView.addSubview(registerButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 500),
            
            emailTextField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            emailTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -30),
            emailTextField.widthAnchor.constraint(equalToConstant: 250),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordTextField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.widthAnchor.constraint(equalToConstant: 250),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            loginButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: -70),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.widthAnchor.constraint(equalToConstant: 100),
            loginButton.heightAnchor.constraint(equalToConstant: 40),
            
            registerButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 70),
            registerButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            registerButton.widthAnchor.constraint(equalToConstant: 100),
            registerButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func showAlert(message: String) {
        
        InspectionApp.showAlert(from: self, withTitle: "Error", message: message)
    }
}

