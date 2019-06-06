//
//  ChooseTechnologyViewController.swift
//  FireBrick
//
//  Created by metoSimka on 03/06/2019.
//  Copyright © 2019 metoSimka. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class ChooseTechnologyViewController: UIViewController {
    
    var availableTechnologies: [Technology] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constraintTableViewLimitHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintTableHeight: NSLayoutConstraint!
    
    let heightCell:CGFloat = 40
    let cellsLimit = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchTechnologies()
    }
    
    @IBAction func makeNewSkill(_ sender: UIButton) {
        
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = false
        let techCell = UINib(nibName: Constants.cellsID.chooseTechnologyTableViewCell, bundle: nil)
        tableView.register(techCell, forCellReuseIdentifier: Constants.cellsID.chooseTechnologyTableViewCell)
        self.tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableView.automaticDimension
        constraintTableViewLimitHeight.constant = CGFloat(cellsLimit) * heightCell
    }
    
    private func fetchTechnologies() {
        Firestore.firestore().collection(Constants.mainFireStoreCollections.technology).getDocuments(completion: { (snapShot, error) in
            guard error == nil else {
                print("error Here", error ?? "Unkown error")
                return
            }
            guard let snapShot = snapShot else {
                return
            }
            var techs:[Technology] = []
            for data in snapShot.documents {
                if let name = data[Constants.fireStoreFields.technology.name] as? String,
                    let icon = data[Constants.fireStoreFields.technology.icon] as? String {
                    var tech = Technology()
                    tech.name = name
                    tech.icon = icon
                    techs.append(tech)
                } else {
                    var tech = Technology()
                    tech.name = "error"
                    techs.append(tech)
                }
            }
            self.availableTechnologies = techs
            self.updateTableHeight()
            self.tableView.reloadData()
        })
    }
    
    func didChooseTechnologyAtIndex(indexPath: IndexPath) {
        _ = availableTechnologies[indexPath.row]
    }
    
    func updateTableHeight() {
        let height = heightCell * CGFloat(availableTechnologies.count)
        constraintTableHeight.constant = height
        self.view.layoutIfNeeded()
    }
}

extension ChooseTechnologyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableTechnologies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.cellsID.chooseTechnologyTableViewCell) as? ChooseTechnologyTableViewCell else {
            return UITableViewCell()
        }
        cell.setupCell(withTechnology: availableTechnologies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didChooseTechnologyAtIndex(indexPath: indexPath)
        return
    }
}
