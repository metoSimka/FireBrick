//
//  AddTechnologyViewController.swift
//  FireBrick
//
//  Created by metoSimka on 11/06/2019.
//  Copyright © 2019 metoSimka. All rights reserved.
//

import UIKit
import SwiftEntryKit
import Firebase

class AddTechnologyViewController: UIViewController {
    
    var availableTechnologies: [Technology] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constraintTableViewHeight: NSLayoutConstraint!
    
    let cellHeight: CGFloat = 46

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTechnologies()
        setupTableView()
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func makeNewTechnology(_ sender: UIButton) {
        let vc = NewTechnologyViewController(nibName: Constants.controllers.newTechnologyViewController, bundle: nil)
        SwiftEntryKit.display(entry: vc, using: EKAttributes.default)
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
                if  let name = data[Constants.fireStoreFields.technology.name] as? String,
                    let doc = data[Constants.fireStoreFields.technology.documentation] as? String {
                    var tech = Technology()
                    tech.name = name
                    tech.documentation = doc
                    techs.append(tech)
                } else {
                    var tech = Technology()
                    tech.name = "error"
                    tech.documentation = "error"
                    techs.append(tech)
                }
            }
            self.availableTechnologies = techs
            self.updateTableViewHeight()
            self.tableView.reloadData()
        })
    }
    
    private func updateTableViewHeight() {
        let height = cellHeight * CGFloat(availableTechnologies.count)
        constraintTableViewHeight.constant = height
    }
    
    
    private func setupTableView() {
        tableView.register(UINib(nibName: Constants.cellsID.addTechnologyTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.cellsID.addTechnologyTableViewCell)
        self.tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension AddTechnologyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableTechnologies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.cellsID.addTechnologyTableViewCell) as? AddTechnologyTableViewCell else {
            return UITableViewCell()
        }
        cell.setupCell(withTechnology: availableTechnologies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = self.tableView.cellForRow(at: indexPath) as? AddTechnologyTableViewCell else {
            return
        }
        
        let storyboard = UIStoryboard(name: Constants.controllers.configueAddedTechnologyViewController, bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: Constants.controllers.configueAddedTechnologyViewController  ) as? ConfigueAddedTechnologyViewController else {
            return
        }
        vc.labelNameTechnology = cell.labelNameTechnology
        vc.imageIcon = cell.imageIcon
        self.present(vc, animated: true, completion: nil)
    }
}

extension AddTechnologyViewController: NewTechnologyViewControllerProtocol {
    func didTapAddButton(newTechnology: Technology) {
        availableTechnologies.append(newTechnology)
        tableView.reloadData()
    }
}
