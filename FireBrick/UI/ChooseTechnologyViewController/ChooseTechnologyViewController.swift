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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        fetchTechnologies()
    }
    
    @IBAction func makeNewSkill(_ sender: UIButton) {
        
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
            self.tableView.reloadData()
        })
    }
    
    func didChooseTechnologyAtIndex(indexPath: IndexPath) {
        let technology = availableTechnologies[indexPath.row]
    }
}

extension ChooseTechnologyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableTechnologies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.cellsID.chooseTableViewCell) as? ChooseTechnologyTableViewCell else {
            return UITableViewCell()
        }
        cell.technology = availableTechnologies[indexPath.row]
        cell.setTechnology()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didChooseTechnologyAtIndex(indexPath: indexPath)
        return
    }
    
}
