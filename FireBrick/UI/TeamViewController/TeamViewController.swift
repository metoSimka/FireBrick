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
    
    //    struct teamViewModel {
    //        enum teamType {
    //            case name
    //        }
    //        enum userType {
    //            case name
    //            case imageLink
    //            case reference
    //        }
    //    }
    
    struct TeamViewModel {
        var userType: [UserType]?
        var teamType: [TeamType]?
    }
    
    enum TeamType {
        case name(_: String?)
    }
    
    enum UserType {
        case name(_: String?)
        case imageLink(_: String?)
        case reference
        case isHidden(_: Bool?)
    }
    
    var firebaseTeams: [Team] = []
    var teamModel: [TeamViewModel] = []
    var docRef: DocumentReference!
    var db: Firestore?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinnerView: UIView!
    
    override func viewDidLoad() {
        db = Firestore.firestore()
        super.viewDidLoad()
        setupTableView()
        fetchTeams()
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
            var teams:[Team] = []
            for data in snapShot.documents {
                var employee:[User] = []
                print(data.data())
                guard let name = data["name"] as? String,
                    let users = data["users"] as? [[String:String]] else  {
                        print("ERROREROEROr")
                        return
                }
                for item in users {
                    var user = User()
                    guard let name = item["name"]  else {
                        return
                    }
                    guard let icon = item["icon"] else {
                        return
                    }
                    user.name = name
                    user.imageLink = icon
                    employee.append(user)
                }
                let team = Team(name: name, users: employee)
                teams.append(team)
            }
            self.firebaseTeams = teams
            self.extractTeams(teams: self.firebaseTeams)
            self.tableView.reloadData()
            self.stopLoader()
        })
    }
    
    func extractTeams(teams: [Team]) {
        var extractedModel:[TeamViewModel] = []
        for team in teams {
            guard let teamName = team.name else {
                return
            }
            guard let teamUsers = team.users else {
                return
            }
            var teamModel = TeamViewModel()
            teamModel.teamType = []
            teamModel.teamType?.append(TeamType.name(teamName))
            extractedModel.append(teamModel)
            for user in teamUsers {
                var userModel = TeamViewModel()
                userModel.userType = []
                userModel.userType?.append(UserType.name(user.name))
                userModel.userType?.append(UserType.imageLink(user.imageLink))
                extractedModel.append(userModel)
            }
        }
        teamModel = extractedModel
    }
    
    func startLoader() {
        UIView.animate(withDuration: Constants.forAnimation.normal) {
            self.spinnerView.alpha = 1
        }
       
    }
    
    func stopLoader() {
        UIView.animate(withDuration: Constants.forAnimation.normal) {
            self.spinnerView.alpha = 0
        }
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TeamTableViewCell", bundle: nil), forCellReuseIdentifier: "TeamTableViewCell")
        tableView.register(UINib(nibName: "EmployeeTableViewCell", bundle: nil), forCellReuseIdentifier: "EmployeeTableViewCell")
        self.tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableView.automaticDimension
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
    
    func transferTeamFormat(teamModel: TeamViewModel) -> Team {
        var team = Team()
        guard let model = teamModel.teamType else {
            return team
        }
        for elem in model {
            
            switch elem {
            case .name(let name):
                team.name = name
            }
        }
        return team
    }
    
    func transferUserFormat(teamModel: TeamViewModel) -> User {
        var user = User()
        guard let model = teamModel.userType else {
            return user
        }
        for elem in model {
            switch elem {
            case .name(let name):
                user.name = name
            case .imageLink(let link):
                user.imageLink = link
            default:
                break
            }
        }
        return user
    }
}

    extension TeamViewController: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return teamModel.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let currentModel = teamModel[indexPath.row]
            if currentModel.teamType != nil {
                guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "TeamTableViewCell") as? TeamTableViewCell else {
                    return UITableViewCell()
                }
                let team = transferTeamFormat(teamModel: currentModel)
                cell.team = team
                cell.setCellView()
                return cell
                
            } else if currentModel.userType != nil  {
                guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "EmployeeTableViewCell") as? EmployeeTableViewCell else {
                    return UITableViewCell()
                }
                let user = transferUserFormat(teamModel: currentModel)
                cell.user = user
                cell.setCellView()
                return cell
                
            }
            return UITableViewCell()
        }
}


//    func uploadImageToFirestore(data: Data ) {
//        let storageRef = Storage.storage().reference(withPath: "pics/demo.jpg")
//        let uploadMetadata = StorageMetadata()
//        uploadMetadata.contentType = "pics/demo.jpg"
//      let uploadTask =  storageRef.putData(data, metadata: uploadMetadata) { (metaData, error) in
//            guard error == nil else {
//                return
//            }
//            print("done")
//        }
//        uploadTask.observe(.progress) {[weak self] (snapshot) in
//            guard let storageRef = self else {
//                return
//            }
//            guard let progress = snapshot.progress else {
//                return
//            }
////            storageRef.progressView.progess = Float(progress.fractionCompleted)
//        }
//    }

