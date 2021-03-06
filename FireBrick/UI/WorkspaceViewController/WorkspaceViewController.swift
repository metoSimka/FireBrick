//
//  EnteredViewController.swift
//  FireBrick
//
//  Created by metoSimka on 20/05/2019.
//  Copyright © 2019 metoSimka. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase
import FirebaseAuth
import GoogleSignIn

class WorkspaceViewController: UIViewController {
    
    var docRef: DocumentReference!
    var listener: ListenerRegistration!
    
    @IBOutlet weak var teamLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        docRef = Firestore.firestore().document("Technology/Name")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addListeners()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        listener?.remove()
    }

    @IBAction func openTeam(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: Constants.controllers.teamViewController, bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: Constants.controllers.teamViewController  ) as? TeamViewController else {
            return
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func showEmployees(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: Constants.controllers.employeesViewController, bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: Constants.controllers.employeesViewController  ) as? EmployeesViewController else {
            return
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func getDocumentBy(collectionName: String, fieldName: String, value: AnyObject) {
        Firestore.firestore().collection(collectionName).whereField(fieldName, isEqualTo: value).getDocuments(completion: { (snapShot, error) in
            guard let QsnapShot = self.getterQueryData(snapShot: snapShot, error: error) else {
                return
            }
            print("number of docs. with entered data is: \(QsnapShot.count)")
            for doc in QsnapShot.documents {
                guard let name = doc.data()["Documentation"] else {
                    return
                }
                self.docRef = doc.reference
                self.writeData(dataToSave: ["documentation": "can be Swift or Objective-C"])
                print(name)
            }
        })
    }

    func addListeners() {
        listener = docRef.addSnapshotListener { (docSnapshot, error) in
            guard let data = self.getterSnapshotData(docSnapshot: docSnapshot, error: error) else {
                return
            }
            print("Data has been changed", data)
        }
    }
    
    func writeData(dataToSave: [String: Any]) {
        docRef.updateData(dataToSave) { (error) in
            guard error == nil else {
                print("It's A TRAP!", error?.localizedDescription ?? "Unknown error")
                return
            }
            print("DONE")
        }
    }
    
    func fetchFromDocument() {
        docRef.getDocument { (docSnapshot, error) in
            guard let data = self.getterSnapshotData(docSnapshot: docSnapshot, error: error) else {
                return
            }
            let name = data["Name"] as? String
            self.teamLabel?.text = name
        }
    }
    
    @IBAction func researchTechnology(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: Constants.controllers.technologyViewController, bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: Constants.controllers.technologyViewController  ) as? TechnologyViewController else {
            return
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func Fetch(_ sender: UIButton) {
      fetchFromDocument()
    }
    
    @IBAction func signOut(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signOut()
        
        let storyboard = UIStoryboard(name: Constants.controllers.authViewController, bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: Constants.controllers.authViewController  ) as? AuthViewController else {
            return
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func createUser(_ sender: UIButton) {
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
    
    func getterSnapshotData(docSnapshot: DocumentSnapshot?, error: Error?) -> [String : Any]? {
        guard error == nil else {
            print("error Here", error ?? "Unkown error")
            return nil
        }
        guard let snapShot = docSnapshot else {
            return nil
        }
        guard let data = snapShot.data() else {
            return nil
        }
        return data
    }
}
