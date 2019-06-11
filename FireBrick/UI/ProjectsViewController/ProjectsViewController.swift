//
//  ProjectsViewController.swift
//  FireBrick
//
//  Created by metoSimka on 07/06/2019.
//  Copyright © 2019 metoSimka. All rights reserved.
//

class ExampleClass {
    // MARK: - Public constants
   
   
    // MARK: - Private constants
    // MARK: - Private variables
    

    // MARK: - Custom Accessors

    // MARK: - Public methods

}



import UIKit
import SwiftEntryKit
import Firebase

class ProjectsViewController: UIViewController {
    
     // MARK: - Public variables
    
    var projects:[Project] = []

     // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
        // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchProjects()
    }
    
        // MARK: - IBActions
    
    @IBAction func addProject(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: Constants.controllers.addProjectViewController, bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: Constants.controllers.addProjectViewController  ) as? AddProjectViewController else {
            return
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func openNavigation(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
        // MARK: - Private methods
    
    private func fetchProjects() {
        Firestore.firestore().collection(Constants.mainFireStoreCollections.projects).getDocuments(completion: { (snapShot, error) in
            guard error == nil else {
                print("error Here", error ?? "Unkown error")
                return
            }
            guard let snapShot = snapShot else {
                return
            }
            guard let firebaseProjects = self.getProjects(from: snapShot) else {
                return
            }
            self.projects = firebaseProjects
            self.tableView.reloadData()
        })
    }
    
    private func getProjects(from snapShot: QuerySnapshot) -> [Project]? {
        var firebaseProjects: [Project] = []
        for data in snapShot.documents {
            var project = Project()
            if let name = data[Constants.fireStoreFields.projects.name] as? String {
                project.name = name
            }
            if let users = data[Constants.fireStoreFields.projects.users] as? [[String:AnyObject]] {
                project.users = self.getUsers(from: users)
            }
            if let technologies = data[Constants.fireStoreFields.projects.technologies] as? [[String:AnyObject]] {
                project.technologies = getTechnologies(from: technologies)
            }
            if let totalHours = data[Constants.fireStoreFields.projects.hours] as? Int {
                    project.hours = Int(totalHours)
            }
            if let icon = data[Constants.fireStoreFields.projects.imageLink] as? String {
                project.imageLink = icon
            }
            firebaseProjects.append(project)
        }
        return firebaseProjects
    }
    
    private func getTechnologies(from firebaseTechnologies: [[String:AnyObject]]) -> [Technology]? {
        var technologies: [Technology] = []
        for tech in firebaseTechnologies {
            var technology = Technology()
            if let name = tech[Constants.fireStoreFields.technology.name] as? String {
                technology.name = name
            }
            if let color = tech[Constants.fireStoreFields.technology.color] as? String {
                technology.colorHex = color
            }
            if let icon = tech[Constants.fireStoreFields.technology.icon] as? String {
                technology.icon = icon
            }
            if let hrs_in_week = tech[Constants.fireStoreFields.technology.hrs_in_week] as? Int {
                technology.hrs_in_week = hrs_in_week
            }
            technologies.append(technology)
        }
        return technologies
    }
    
    private func getUsers(from users: [[String : AnyObject]]) -> [User]? {
        var employees: [User] = []
        for item in users {
            var user = User()
            print(item)
            guard let name = item[Constants.fireStoreFields.users.name] as? String,
                let icon = item[Constants.fireStoreFields.users.icon] as? String else {
                    return nil
            }
            user.name = name
            user.imageLink = icon
            employees.append(user)
        }
        return employees
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: Constants.cellsID.projectTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.cellsID.projectTableViewCell)
        self.tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - Protocol Conformance

extension ProjectsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.cellsID.projectTableViewCell) as? ProjectTableViewCell else {
            return UITableViewCell()
        }
        cell.setupCell(withProject: projects[indexPath.row])
        return cell
    }
}
