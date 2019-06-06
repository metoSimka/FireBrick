//
//  EmployeesViewController.swift
//  FireBrick
//
//  Created by metoSimka on 03/06/2019.
//  Copyright © 2019 metoSimka. All rights reserved.
//

import UIKit
import Firebase

class EmployeesViewController: UIViewController {
    
    var users: [User] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchUsers()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = false
        let techCell = UINib(nibName: Constants.cellsID.employeesTableViewCell, bundle: nil)
        tableView.register(techCell, forCellReuseIdentifier: Constants.cellsID.employeesTableViewCell)
        self.tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func fetchUsers() {
        self.startLoader()
        Firestore.firestore().collection(Constants.mainFireStoreCollections.users).getDocuments(completion: { (snapShot, error) in
            guard error == nil else {
                print("error Here", error ?? "Unkown error")
                self.stopLoader()
                return
            }
            guard let snapShot = snapShot else {
                self.stopLoader()
                return
            }
            guard let firebaseUsers = self.getUsers(from: snapShot) else {
                self.stopLoader()
                return
            }
            self.users = firebaseUsers
            self.tableView.reloadData()
            self.stopLoader()
        })
    }
    
    private func getUsers(from snapShot: QuerySnapshot) -> [User]? {
        var firebaseUsers: [User] = []
        for data in snapShot.documents {
            guard let name = data[Constants.fireStoreFields.users.name] as? String,
                let iconLink = data[Constants.fireStoreFields.users.icon] as? String,
                let busy = data[Constants.fireStoreFields.users.busy] as? Int,
                let skills = data[Constants.fireStoreFields.users.skills] as? [[String:AnyObject]] else {
                    return nil
            }
            var user = User()
            user.name = name
            user.busy = busy
            user.imageLink = iconLink
            user.skills = skills
            firebaseUsers.append(user)
        }
        return firebaseUsers
    }
    
    func startLoader() {
    }
    
    func stopLoader() {
        
    }
}

extension EmployeesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.cellsID.employeesTableViewCell) as? EmployeesTableViewCell else {
            return UITableViewCell()
        }
        cell.user = users[indexPath.row]
        cell.setUserProfile()
        return cell
    }
}
