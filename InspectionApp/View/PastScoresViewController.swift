//
//  PastScoresViewController.swift
//  InspectionApp
//
//  Created by Ganesh Joshi on 14/07/24.
//

import UIKit
import CoreData

class PastScoresViewController: UIViewController {
    private let tableView = UITableView()
    var user: CDUser!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchPastScores()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        self.title = "Past Scores"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ScoreCell")
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func fetchPastScores() {
        tableView.reloadData()
    }
}

extension PastScoresViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.pastScores?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath)
        let pastScore = user.pastScores?.allObjects[indexPath.row] as! CDPastScores
        cell.textLabel?.text = "Score: \(pastScore.score)"
        
        return cell
    }
}

