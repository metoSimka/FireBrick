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
    
    var docRef: DocumentReference!
    var db: Firestore?
    var availableTechnoloies: [Technology] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "TechnologyTableViewCell", bundle: nil), forCellReuseIdentifier: "TechnologyCell")
        self.tableView.frame = self.view.bounds
        self.tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.delegate = self
        tableView.dataSource = self
        db = Firestore.firestore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTechnologies()
    }
    
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
    
    func fetchTechnologies() {
        db?.collection("Technology").getDocuments(completion: { (snapShot, error) in
            guard let snapShot = self.getterQueryData(snapShot: snapShot, error: error) else {
                return
            }
            for data in snapShot.documents {
                guard
                    let name = data["Name"] as? String,
                    let doc = data["Documentation"] as? String?
                    else {
                        return
                }
                let tech = Technology(name: name, documentation: doc)
                self.availableTechnoloies.append(tech)

            }
            self.tableView.reloadData()
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
}


extension TechnologyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableTechnoloies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "TechnologyCell") as? TechnologyTableViewCell else {
            return UITableViewCell()
        }
        cell.technology = availableTechnoloies[indexPath.row]
        cell.setTechnology()
        return cell
    }
}
