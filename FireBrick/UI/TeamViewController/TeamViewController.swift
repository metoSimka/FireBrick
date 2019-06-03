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
    
    // MARK: - Public variables
    
    enum TeamViewType{
        case team
        case user
    }
    
    struct TeamViewModel {
        var type: TeamViewType
        var user: User?
        var team: Team?
        var isTeamExpanded: Bool?
    }
    
    var teams: [Team] = []
    var teamViewModel: [TeamViewModel] = []
    var hiddenIDDocs: [String] = []
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinnerView: UIView!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchTeams()
    }
    
    // MARK: - IBActions
    
    @IBAction func openNavigation(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openFilter(_ sender: UIButton) {
    }
    
    // MARK: - Private methods
    
    private func fetchTeams() {
        self.startLoader()
        Firestore.firestore().collection(Constants.mainFireStoreCollections.teams).getDocuments(completion: { (snapShot, error) in
            guard error == nil else {
                print("error Here", error ?? "Unkown error")
                self.stopLoader()
                return
            }
            guard let snapShot = snapShot else {
                self.stopLoader()
                return 
            }
            guard let firebaseTeams = self.getTeams(from: snapShot) else {
                self.stopLoader()
                return
            }
            self.teams = firebaseTeams
            self.updateDataWithTeamViewModel(teams: self.teams, idHiddenDocs: nil)
            self.tableView.reloadData()
            self.stopLoader()
        })
    }
    
    private func getTeams(from snapShot: QuerySnapshot) -> [Team]? {
        var firebaseTeams: [Team] = []
        for data in snapShot.documents {
            guard let name = data[Constants.fireStoreFields.teams.name] as? String,
                let users = data[Constants.fireStoreFields.teams.users] as? [[String:AnyObject]],
                let employees = self.getUsers(from: users) else {
                    return nil
            }
            let team = Team(name: name, users: employees, documentID: data.documentID )
            firebaseTeams.append(team)
        }
        return firebaseTeams
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
    
    private func updateDataWithTeamViewModel(teams: [Team], idHiddenDocs: [String]?) {
        var extractedModel:[TeamViewModel] = []
        for team in teams {
            let teamModel = TeamViewModel(type: .team, user: nil, team: team, isTeamExpanded: false)
            guard let users = team.users else {
                continue
            }
            extractedModel.append(teamModel)
            for user in users {
                let userModel = TeamViewModel(type: .user, user: user, team: nil, isTeamExpanded: nil)
                extractedModel.append(userModel)
            }
        }
        teamViewModel = extractedModel
    }
    
    private func extractUsersFromTeam() {
        
    }
    
    private func startLoader() {
        UIView.animate(withDuration: Constants.forAnimation.normal) {
            self.spinnerView.alpha = 1
        }
    }
    
    private func stopLoader() {
        UIView.animate(withDuration: Constants.forAnimation.normal) {
            self.spinnerView.alpha = 0
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let teamTableViewNib = UINib(nibName: Constants.cellsID.teamTableViewCell, bundle: nil)
        let EmployeeTableViewNib = UINib(nibName: Constants.cellsID.employeeTableCell, bundle: nil)
        tableView.register(teamTableViewNib, forCellReuseIdentifier: Constants.cellsID.teamTableViewCell)
        tableView.register(EmployeeTableViewNib, forCellReuseIdentifier: Constants.cellsID.employeeTableCell)
        self.tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func showErrorAlert(error: Error?) {
        guard let error = error else {
            return
        }
        let storyboard = UIStoryboard(name: Constants.controllers.simpleAlertViewController, bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: Constants.controllers.simpleAlertViewController) as? SimpleAlertViewController else {
            return
        }
        vc.messageTitle = error.localizedDescription
        SwiftEntryKit.display(entry: vc, using: EKAttributes.default)
    }
    
    private  func transferTeamFormat(teamModel: TeamViewModel) -> Team {
        var team = Team()
        switch teamModel.type {
        case .user:
            print("Stop crushing the system!")
        case .team:
            team.name = teamModel.team?.name
        }
        return team
    }
    
    private  func transferUserFormat(teamModel: TeamViewModel) -> User {
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
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.cellsID.teamTableViewCell) as? TeamTableViewCell else {
                return UITableViewCell()
            }
            let team = transferTeamFormat(teamModel: currentModel)
            cell.team = team
            cell.delegate = self
            cell.setCellView()
            guard let isTeamExpanded = currentModel.isTeamExpanded else {
                return UITableViewCell()
            }
            cell.updateButtonState(isHidden: isTeamExpanded)
            return cell
        case .user:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.cellsID.employeeTableCell) as? EmployeeTableViewCell else {
                return UITableViewCell()
            }
            let user = transferUserFormat(teamModel: currentModel)
            cell.user = user
            cell.delegate = self
            cell.setCellView()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellModel = teamViewModel[indexPath.row]
        switch cellModel.type {
        case .team:
            guard let isTeamExpanded = cellModel.isTeamExpanded else {
                return
            }
            guard let cell = tableView.cellForRow(at: indexPath) as? TeamTableViewCell else {
                return
            }
            guard let countUsersInTeam = cellModel.team?.users?.count else {
                return
            }
            guard countUsersInTeam != 0 else {
                return
            }
            guard let team = cellModel.team else {
                return
            }
            if isTeamExpanded {
                teamViewModel[indexPath.row].isTeamExpanded = false
                cell.updateButtonState(isHidden: false)
                let indexesForInsert = findIndexes(countCells: countUsersInTeam, startingIndexPath: indexPath)
                insertTeamUsersToViewModel(from: team, inIndex: indexPath.row+1)
                tableView.insertRows(at: indexesForInsert, with: .fade)
            } else {
                teamViewModel[indexPath.row].isTeamExpanded = true
                cell.updateButtonState(isHidden: true)
                let indexesForRemove = findIndexes(countCells: countUsersInTeam, startingIndexPath: indexPath)
                removeTeamUsersFromViewModel(teamIndex: indexPath, indexesForRemove: indexesForRemove)
                tableView.deleteRows(at: indexesForRemove, with: .fade)
            }
        default:
            return
        }
    }
    
    private  func findIndexes(countCells countUsersInTeam: Int,	startingIndexPath indexPath: IndexPath) -> [IndexPath] {
        let range = 1...countUsersInTeam
        var indexes: [IndexPath] = []
        for count in range {
            var idxPath = indexPath
            idxPath.row += count
            indexes.append(idxPath)
        }
        return indexes
    }
    
    private func removeTeamUsersFromViewModel(teamIndex indexPath: IndexPath, indexesForRemove: [IndexPath] ) {
        let firstUserIndexRow = indexPath.row+1
        guard let lastUserIndexRow = indexesForRemove.last?.row else {
            return
        }
        teamViewModel.removeSubrange(firstUserIndexRow...lastUserIndexRow)
    }
    
    private  func insertTeamUsersToViewModel(from team: Team, inIndex index: Int ) {
        guard let users = team.users else {
            return
        }
        for user in users {
            let userModel = TeamViewModel(type: .user, user: user, team: nil, isTeamExpanded: nil)
            teamViewModel.insert(userModel, at: index)
        }
    }
}

extension TeamViewController: TeamTableViewCellDelegate {
    func didTapAddEmployee(cell: TeamTableViewCell) {
        
    }
    
    func didTapOnTeam(cell: TeamTableViewCell) {
        
    }
}

// MARK: - Protocol Conformance

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

