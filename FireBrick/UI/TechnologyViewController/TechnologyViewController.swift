//
//  AddTechnologyViewController.swift
//  FireBrick
//
//  Created by metoSimka on 27/05/2019.
//  Copyright © 2019 metoSimka. All rights reserved.
//

import UIKit
import SwiftEntryKit
import Firebase
import FirebaseFirestore

class TechnologyViewController: UIViewController {

    var availableTechnoloies: [Technology] = []
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addListeners()
    }
    
    private func addListeners() {
        Firestore.firestore().collection("Technology").addSnapshotListener({ (snapShot, error) in
            guard let _ = self.getterQueryData(snapShot: snapShot, error: error) else {
                return
            }
            self.fetchTechnologies()
        })
    }
    
    func getterQueryData(snapShot: QuerySnapshot? , error: Error? ) -> QuerySnapshot? {
        guard error == nil else {
            print("error Here", error ?? "Unkown error")
            return nil
        }
        guard let snapShot = snapShot else {
            return nil
        }
        return snapShot
    }
    
    // MARK: IBAction
    
    @IBAction func Back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addTechnology(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "AddTechnologyViewController", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "AddTechnologyViewController") as? AddTechnologyViewController else {
            return
        }
        SwiftEntryKit.display(entry: vc, using: EKAttributes.default)
    }
    
    // Private
    
    private func fetchTechnologies() {
        Firestore.firestore().collection("Technology").getDocuments(completion: { (snapShot, error) in
            guard let snapShot = self.getterQueryData(snapShot: snapShot, error: error) else {
                self.showErrorAlert(error: error)
                return
            }
            var techs:[Technology] = []
            for data in snapShot.documents {
                if  let name = data["Name"] as? String,
                    let doc = data["Documentation"] as? String {
                    let tech = Technology(name: name, documentation: doc)
                    techs.append(tech)
                } else {
                    let tech = Technology(name: "error", documentation: "error")
                    techs.append(tech)
                }
            }
            self.availableTechnoloies = techs
            self.tableView.reloadData()
            self.spinner.stopAnimating()
        })
    }
    
    private func showErrorAlert(error: Error?) {
        guard let error = error else {
            return
        }
        let storyboard = UIStoryboard(name: "SimpleAlertViewController", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "SimpleAlertViewController") as? SimpleAlertViewController else {
            return
        }
        vc.messageTitle = error.localizedDescription
        SwiftEntryKit.display(entry: vc, using: EKAttributes.default)
    }
    
    //It may use in feature.
    
    //    private func showAlertIfNeeded(array idFailedDocs: [String]) {
    //        if idFailedDocs.count > 0 {
    //            self.showFormattAlert(ids: idFailedDocs)
    //        }
    //    }
    //
    //    private func showFormattAlert(ids: [String]) {
    //        let storyboard = UIStoryboard(name: "SimpleAlertViewController", bundle: nil)
    //        guard let vc = storyboard.instantiateViewController(withIdentifier: "SimpleAlertViewController") as? SimpleAlertViewController else {
    //            return
    //        }
    //        vc.messageTitle = "One or more technologies came in the wrong format and will not be displayed. \nID-list failed documents: \(ids.map { "\($0)" }.joined(separator:"\n"))"
    //        SwiftEntryKit.display(entry: vc, using: EKAttributes.default)
    //    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "TechnologyTableViewCell", bundle: nil), forCellReuseIdentifier: "TechnologyCell")
        self.tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension TechnologyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableTechnoloies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "TechnologyCell") as? TechnologyTableViewCell else {
            return UITableViewCell()
        }
        cell.technology = availableTechnoloies[indexPath.row]
        cell.setTechnology()
        return cell
    }
}
