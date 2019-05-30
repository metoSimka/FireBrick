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
    
    enum TeamViewType{
        case team
        case user
    }
    
    struct TeamViewModel {
        var type: TeamViewType
        var user: UserType?
        var team: TeamType?
        var isHidden = false
    }
    
    struct TeamType {
        var name: String?
    }
    
    struct UserType {
        var name: String?
        var imageLink: String?
        var reference: String?
    }
    
    var teams: [Team] = []
    var teamViewModel: [TeamViewModel] = []
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
            self.teams = teams
            self.extractTeams(teams: self.teams)
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
            let teamType = TeamType(name: teamName)
            let teamModel = TeamViewModel(type: .team, user: nil, team: teamType, isHidden: false)
            extractedModel.append(teamModel)
            for user in teamUsers {
                let userType = UserType(name: user.name, imageLink: user.imageLink, reference: nil)
                let userModel = TeamViewModel(type: .user, user: userType, team: nil, isHidden: false)
                extractedModel.append(userModel)
            }
        }
        teamViewModel = extractedModel
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
        switch teamModel.type {
        case .user:
            print("Stop crushing the system!")
        case .team:
            team.name = teamModel.team?.name
        }
        return team
    }
    
    func transferUserFormat(teamModel: TeamViewModel) -> User {
        var user = User()
        switch teamModel.type {
        case .user:
            user.name = teamModel.user?.name
            user.imageLink = teamModel.user?.imageLink
        case .team:
            print("Stop crushing the system!")
        }
        return user
    }
}

extension TeamViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentModel = teamViewModel[indexPath.row]
        switch currentModel.type {
        case .team:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "TeamTableViewCell") as? TeamTableViewCell else {
                return UITableViewCell()
            }
            let team = transferTeamFormat(teamModel: currentModel)
            cell.team = team
            cell.delegate = self
            cell.setCellView()
            return cell
        case .user:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "EmployeeTableViewCell") as? EmployeeTableViewCell else {
                return UITableViewCell()
            }
            if teamViewModel[indexPath.row].isHidden {
                cell.isHidden = true
            }
            let user = transferUserFormat(teamModel: currentModel)
            cell.user = user
            cell.delegate = self
            cell.setCellView()
            return cell
        }
    }
}

extension TeamViewController: TeamTableViewCellDelegate {
    func didTapAddEmployee(cell: TeamTableViewCell) {
        
    }
    
    func didTapOnTeam(cell: TeamTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        var indexRow =  indexPath.row + 1
        let lastIndex = teamViewModel.count
        while indexRow < lastIndex {
            guard self.teamViewModel[indexRow].type == .user else {
                return
            }
            UIView.animate(withDuration: Constants.forAnimation.normal) {
                
                if self.teamViewModel[indexRow].isHidden {
                    self.teamViewModel[indexRow].isHidden = false
                    cell.arrowStateButton.isSelected = false
                    self.tableView.reloadData()
                } else {
                    self.teamViewModel[indexRow].isHidden = true
                    cell.arrowStateButton.isSelected = true
                    self.tableView.reloadData()
                }
            }
            indexRow += 1
        }
    }
}

extension TeamViewController: EmployeeTableViewCellDelegate {
    func didTapOptionButton() {
        
    }
    
    func didTapOnUser() {
        
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

