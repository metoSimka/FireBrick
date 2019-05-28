//
//  TeamViewController.swift
//  FireBrick
//
//  Created by metoSimka on 28/05/2019.
//  Copyright © 2019 metoSimka. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import SwiftEntryKit

class TeamViewController: UIViewController {
    
    var docRef: DocumentReference!
    var db: Firestore?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        db = Firestore.firestore()
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    @IBAction func openNavigation(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openFilter(_ sender: UIButton) {
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
    
    func fetchTeams() {
        db?.collection("Teams").getDocuments(completion: { (snapShot, error) in
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
            self.tableView.reloadData()
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
}

extension TeamViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      return  UITableViewCell()
    } 
}
