//
//  MainViewController.swift
//  InspectionApp
//
//  Created by Ganesh Joshi on 13/07/24.
//

import UIKit

class MainViewController: UIViewController {
    
    private let startInspectionButton = UIButton(type: .system)
    private let resumeInspectionButton = UIButton(type: .system)
    private let pastScoresButton = UIButton(type: .system)
    private let logoutButton = UIButton(type: .system)
        
    var userInspectionViewModel = UserInspectionViewModel(inspectionService: InspectionService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.setValue("", forKey: "email")
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshUI()
    }
    
    private func presentLoginViewController() {
            let loginViewModel = LoginViewModel(authService: AuthService())
            let loginViewController = LoginViewController(viewModel: loginViewModel)
            let navigationController = UINavigationController(rootViewController: loginViewController)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
        }
    
    @objc private func startInspectionTapped() {
        PersistenceManager.shared.deleteInspection(forEmail: self.userInspectionViewModel.user)
        self.userInspectionViewModel.startInspection(user: self.userInspectionViewModel.user) { result in
            print(result)
            if result {
                DispatchQueue.main.async {
                    let surveyDetailVC = SurveyDetailViewController()
                    surveyDetailVC.inspection = self.userInspectionViewModel.user.cdInspection
                    self.navigationController?.pushViewController(surveyDetailVC, animated: true)
                }
            }
        }
    }
    
    @objc private func resumeInspectionTapped() {
        DispatchQueue.main.async {
            let surveyDetailVC = SurveyDetailViewController()
            if let inspection = self.userInspectionViewModel.user.cdInspection {
                surveyDetailVC.inspection = inspection
                self.navigationController?.pushViewController(surveyDetailVC, animated: true)
            }
        }
    }
    
    @objc private func pastScoresTapped() {
        let pastScoresVC = PastScoresViewController()
        pastScoresVC.user = userInspectionViewModel.user
        navigationController?.pushViewController(pastScoresVC, animated: true)
    }
    
    @objc private func logoutButtonTapped() {
        UserDefaults.standard.setValue("", forKey: "email")
        refreshUI()
    }
}

extension MainViewController {
    
    private func setupUI() {
        view.backgroundColor = .white
        
        startInspectionButton.setTitle("Start Inspection", for: .normal)
        resumeInspectionButton.setTitle("Resume Inspection", for: .normal)
        pastScoresButton.setTitle("Past Scores", for: .normal)
        logoutButton.setTitle("Logout", for: .normal)
        
        startInspectionButton.addTarget(self, action: #selector(startInspectionTapped), for: .touchUpInside)
        resumeInspectionButton.addTarget(self, action: #selector(resumeInspectionTapped), for: .touchUpInside)
        pastScoresButton.addTarget(self, action: #selector(pastScoresTapped), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
        view.addSubview(startInspectionButton)
        view.addSubview(resumeInspectionButton)
        view.addSubview(pastScoresButton)
        view.addSubview(logoutButton)
        
        // Set translatesAutoresizingMaskIntoConstraints to false
        startInspectionButton.translatesAutoresizingMaskIntoConstraints = false
        resumeInspectionButton.translatesAutoresizingMaskIntoConstraints = false
        pastScoresButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Set up Auto Layout constraints
        NSLayoutConstraint.activate([
            startInspectionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startInspectionButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            
            resumeInspectionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resumeInspectionButton.topAnchor.constraint(equalTo: startInspectionButton.bottomAnchor, constant: 20),
            
            pastScoresButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pastScoresButton.topAnchor.constraint(equalTo: resumeInspectionButton.bottomAnchor, constant: 20),
            
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.topAnchor.constraint(equalTo: pastScoresButton.bottomAnchor, constant: 20)
        ])
    }
    
    private func refreshUI() {
        let userEmail = UserDefaults.standard.string(forKey: "email")
        if userEmail?.count != 0 {
            PersistenceManager.shared.fetchOrCreateUser(withEmail: userEmail!, completion: { user in
                self.userInspectionViewModel.user = user
            })
        }
        else{
            presentLoginViewController()
        }
        resumeInspectionButton.isEnabled = self.userInspectionViewModel.user?.cdInspection != nil
    }
}

