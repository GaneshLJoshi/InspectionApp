//
//  SurveyDetailViewController.swift
//  InspectionApp
//
//  Created by Ganesh Joshi on 13/07/24.
//

import UIKit
import CoreData

class SurveyDetailViewController: UIViewController {
    var inspection: CDInspection?
    private var currentQuestionIndex = 0
    private var allQuestions: [CDQuestion] = []
    
    private let questionLabel = UILabel()
    private let tableView = UITableView()
    
    private let nextButton : UIButton = .createButton(withTitle: "Next", target: self, action: #selector(nextButtonTapped))
    private let previousButton : UIButton = .createButton(withTitle: "Previous", target: self, action: #selector(previousButtonTapped))
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchQuestions()
        showCurrentQuestion()
        updateUIForCurrentQuestion()
    }
    
    private func fetchQuestions() {
            guard let inspection = inspection,
                  let survey = inspection.cdSurvey,
                  let categories = survey.cdCategory as? Set<CDCategory> else { return }
            
            for category in categories {
                if let categoryQuestions = category.cdQuestions as? Set<CDQuestion> {
                    allQuestions.append(contentsOf: categoryQuestions)
                }
            }
        }
    
    private func showCurrentQuestion() {
        guard !allQuestions.isEmpty else { return }
        
        let currentQuestion = allQuestions[currentQuestionIndex]
        questionLabel.text = currentQuestion.name
        tableView.reloadData()
    }
    
    private func updateUIForCurrentQuestion() {
        let currentQuestion = allQuestions[currentQuestionIndex]
        questionLabel.text = currentQuestion.name
            
        previousButton.isEnabled = currentQuestionIndex > 0
        nextButton.isEnabled = currentQuestionIndex < allQuestions.count - 1
    }
    
    @objc private func nextButtonTapped() {
        if currentQuestionIndex < allQuestions.count - 1 {
            currentQuestionIndex += 1
            showCurrentQuestion()
        } else {
            calculateTotalScore()
        }
        updateUIForCurrentQuestion()
    }
    
    @objc private func previousButtonTapped() {
        if currentQuestionIndex > 0 {
            currentQuestionIndex -= 1
            showCurrentQuestion()
        }
        updateUIForCurrentQuestion()
    }
    
    @objc private func submitButtonTapped() {
        guard areAllQuestionsAnswered(inspection: inspection ?? CDInspection()) else {
            InspectionApp.showAlert(from: self, withTitle: "Incomplete", message: "Please answer all questions before submitting.")
            return
        }
        
        let score = calculateTotalScore()
        saveScoreToUser(score: score)
        print("Inspection submitted")
        
        let inspectionService = InspectionService()
        inspectionService.submitInspection(inspection: self.inspection!) { status in
            print("Submit status: \(status)")
            // Deleting Inspection from core data as it is submitted and can not be resumed
            PersistenceManager.shared.deleteInspection(forEmail: self.inspection?.cdUser ?? CDUser())
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Success", message: "Inspection submitted successfully with a score of \(score).", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func calculateTotalScore() -> Double {
            var totalScore: Double = 0.0
            
            for question in allQuestions {
                if case let selectedAnswerId = question.selectedAnswerChoiceId, let answerChoices = question.cdanswerChoices as? Set<CDAnswerChoice> {
                    if let selectedAnswer = answerChoices.first(where: { $0.id == selectedAnswerId }) {
                        totalScore += selectedAnswer.score
                    }
                }
            }
            
            print("Total Score: \(totalScore)")
        return totalScore
        }
    
    private func saveScoreToUser(score: Double) {
        
        let newPastScore = CDPastScores(context: PersistenceManager.shared.persistentContainer.viewContext)
        newPastScore.score = score
        
        inspection?.cdUser?.addToPastScores(newPastScore)
        PersistenceManager.shared.saveContext()
    }
}

extension SurveyDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentQuestion = allQuestions[currentQuestionIndex]
        return (currentQuestion.cdanswerChoices?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerChoiceCell", for: indexPath)
        let currentQuestion = allQuestions[currentQuestionIndex]
        let answerChoices = currentQuestion.cdanswerChoices?.allObjects as? [CDAnswerChoice]
        let answerChoice = answerChoices?[indexPath.row]
        
        cell.textLabel?.text = answerChoice?.name
        cell.accessoryType = (answerChoice?.id == currentQuestion.selectedAnswerChoiceId) ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentQuestion = allQuestions[currentQuestionIndex]
        let answerChoices = currentQuestion.cdanswerChoices?.allObjects as? [CDAnswerChoice]
        let selectedAnswerChoice = answerChoices?[indexPath.row]
        
        currentQuestion.selectedAnswerChoiceId = selectedAnswerChoice?.id ?? 0
        
        do {
            try currentQuestion.managedObjectContext?.save()
        } catch {
            print("Failed to save selected answer: \(error)")
        }
        
        tableView.reloadData()
    }
}

extension SurveyDetailViewController {
    
    private func setupUI() {
        view.backgroundColor = .white
        
        let submitButton = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(submitButtonTapped))
        navigationItem.rightBarButtonItem = submitButton
        
        questionLabel.textAlignment = .center
        questionLabel.numberOfLines = 0
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AnswerChoiceCell")
        
        let stackView = UIStackView(arrangedSubviews: [previousButton, nextButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        view.addSubview(questionLabel)
        view.addSubview(tableView)
        view.addSubview(stackView)
        
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -20),
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension SurveyDetailViewController {
    
    func areAllQuestionsAnswered(inspection: CDInspection) -> Bool {
        guard let survey = inspection.cdSurvey,
              let categories = survey.cdCategory?.allObjects as? [CDCategory] else {
            return false
        }
        
        for category in categories {
            guard let questions = category.cdQuestions?.allObjects as? [CDQuestion] else {
                continue
            }
            
            for question in questions {
                let selectedAnswerId = question.selectedAnswerChoiceId
                
                if selectedAnswerId > 0 {
                    return true
                }
                else {
                    return false
                }
            }
        }
        
        return true
    }
}
