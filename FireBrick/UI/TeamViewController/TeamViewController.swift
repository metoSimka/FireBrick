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
    
    // Public vars
    
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
        var documentID: String?
    }
    
    struct UserType {
        var name: String?
        var imageLink: String?
        var reference: String?
        var teamDocumentID: String?
    }
    
    var teams: [Team] = []
    var teamViewModel: [TeamViewModel] = []
    var hiddenIDDocs: [String] = []
    
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinnerView: UIView!
    
    // Private vars
    
    var docRef: DocumentReference!
    var db: Firestore?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        db = Firestore.firestore()
        super.viewDidLoad()
        setupTableView()
        fetchTeams()
    }
    
    // MARK: IBActions
    
    @IBAction func openNavigation(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openFilter(_ sender: UIButton) {
    }
    
    // MARK: Private funcs
    
    private func getterQueryData(snapShot: QuerySnapshot? , error: Error? ) -> QuerySnapshot? {
        guard error == nil else {
            print("error Here", error ?? "Unkown error")
            return nil
        }
        guard let snapShot = snapShot else {
            return nil
        }
        return snapShot
    }
    
    private func fetchTeams() {
        db?.collection("Teams").getDocuments(completion: { (snapShot, error) in
            guard let snapShot = self.getterQueryData(snapShot: snapShot, error: error) else {
                self.showErrorAlert(error: error)
                return
            }
            guard let firebaseTeams = self.extractTeams(from: snapShot) else {
                return
            }
            self.startLoader()
            self.teams = firebaseTeams
            self.updateDataWithTeamViewModel(teams: self.teams, idHiddenDocs: nil)
            self.tableView.reloadData()
            self.stopLoader()
        })
    }
    
    func extractTeams(from snapShot: QuerySnapshot) -> [Team]? {
        var firebaseTeams: [Team] = []
        for data in snapShot.documents {
            guard let name = data["name"] as? String,
                let users = data["users"] as? [[String:AnyObject]],
                let employee = self.extractUsers(from: users) else {
                    return nil
            }
            let team = Team(name: name, users: employee, documentID: data.documentID )
            firebaseTeams.append(team)
        }
        return firebaseTeams
    }
    
    func extractUsers(from users: [[String : AnyObject]]) -> [User]? {
        var employees: [User] = []
        for item in users {
            var user = User()
            print(item)
            guard let name = item["name"] as? String,
                let icon = item["icon"] as? String,
                let docRef = item["team_path"] as? DocumentReference else {
                    return nil
            }
            let documentID = docRef.documentID
            user.teamDocumentID = documentID
            user.name = name
            user.imageLink = icon
            employees.append(user)
        }
        return employees
    }
    
    private func updateDataWithTeamViewModel(teams: [Team], idHiddenDocs: [String]?) {
        var extractedModel:[TeamViewModel] = []
        for team in teams {
            guard let teamName = team.name,
                let teamIdDoc = team.documentID,
                let teamUsers = team.users else {
                    return
            }
            let teamType = TeamType(name: teamName, documentID: teamIdDoc)
            var teamModel = TeamViewModel(type: .team, user: nil, team: teamType, isHidden: false)
            if !isUserHidden(team: team, idHiddenDocs: idHiddenDocs) {
                teamModel.isHidden = true
                extractedModel.append(teamModel)
                continue
            }
            extractedModel.append(teamModel)
            for user in teamUsers {
                let userType = UserType(name: user.name, imageLink: user.imageLink, reference: nil, teamDocumentID: user.teamDocumentID)
                let userModel = TeamViewModel(type: .user, user: userType, team: nil, isHidden: false)
                extractedModel.append(userModel)
            }
        }
        teamViewModel = extractedModel
    }
    
    private func isUserHidden (team: Team, idHiddenDocs: [String]? ) -> Bool {
        if idHiddenDocs != nil {
            guard let hiddenDocs = idHiddenDocs else {
                return false
            }
            for idDoc in hiddenDocs {
                guard idDoc != team.documentID else {
                    return false
                }
            }
        }
        return true
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
    
    private  func transferTeamFormat(teamModel: TeamViewModel) -> Team {
        var team = Team()
        switch teamModel.type {
        case .user:
            print("Stop crushing the system!")
        case .team:
            team.name = teamModel.team?.name
            team.documentID = teamModel.team?.documentID
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
        //        var count = 0
        //        for model in teamViewModel {
        //            if !model.isHidden {
        //                count += 1
        //            }
        //        }
        //        return count
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
            cell.updateButtonState(isHidden: teamViewModel[indexPath.row].isHidden)
            return cell
        case .user:
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "EmployeeTableViewCell") as? EmployeeTableViewCell else {
                return UITableViewCell()
            }
            let user = transferUserFormat(teamModel: currentModel)
            cell.user = user
            cell.delegate = self
            cell.setCellView()
            return cell
        }
    }
    
    func deleteRowsWithAnimation(indexPath: IndexPath, teamViewModel: [TeamViewModel]) {
        var idxPath = indexPath
        idxPath.row += 1
        let lastIndex = teamViewModel.count
        var indexesForDelete: [IndexPath] = []
        while idxPath.row > lastIndex {
            guard teamViewModel[idxPath.row].type == TeamViewType.user else {
                return
            }
            indexesForDelete.append(idxPath)
            idxPath.row += 1
        }
        tableView.deleteRows(at: indexesForDelete, with: .fade)
    }
    
    private func hideUsers(idDocument: String, modelBeforUpdate: [TeamViewModel], indexPath: IndexPath) {
        
        if !hiddenIDDocs.contains(idDocument) {
            hiddenIDDocs.append(idDocument)
        }
        updateDataWithTeamViewModel(teams: teams, idHiddenDocs: hiddenIDDocs)
        deleteRowsWithAnimation(indexPath: indexPath, teamViewModel: modelBeforUpdate)
    }
    
    private func showUpUsers(idDocument: String) {
        if hiddenIDDocs.contains(idDocument) {
            hiddenIDDocs = hiddenIDDocs.filter {
                $0 != idDocument
            }
        }
        updateDataWithTeamViewModel(teams: teams, idHiddenDocs: hiddenIDDocs)
    }
}

extension TeamViewController: TeamTableViewCellDelegate {
    func didTapAddEmployee(cell: TeamTableViewCell) {
        
    }
    
    func didTapOnTeam(cell: TeamTableViewCell) {
        guard let idDoc = cell.team?.documentID else {
            return
        }
        guard var indexPath = tableView.indexPath(for: cell) else {
            return
        }
        if teamViewModel[indexPath.row].isHidden {
            showUpUsers(idDocument: idDoc)
        } else {
            hideUsers(idDocument: idDoc, modelBeforUpdate: teamViewModel, indexPath: indexPath)
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

