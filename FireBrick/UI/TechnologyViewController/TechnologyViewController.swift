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
    var availableTechnoloies: [String: String] = [:]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        db = Firestore.firestore()
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
                self.availableTechnoloies[name] = doc
            }
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
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "TechnologyCell") as? AddTechnologyTableViewCell else {
            return UITableViewCell()
        }
        let name = availableTechnoloies
        cell.setTechnology(name: <#T##String#>, documentation: <#T##String#>)
        return cell
    }
}
