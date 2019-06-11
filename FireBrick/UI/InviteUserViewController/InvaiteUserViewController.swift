//
//  InvaiteUserViewController.swift
//  FireBrick
//
//  Created by metoSimka on 31/05/2019.
//  Copyright © 2019 metoSimka. All rights reserved.
//

import UIKit
import SwiftEntryKit
import Firebase

class InvaiteUserViewController: UIViewController {
    
    var availableTechnologies: [Technology] = []
    
    // MARK: - IBOutlets

    @IBOutlet weak var inviteButton: UIButton!
    @IBOutlet weak var constraintTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var hoursTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Private constants
    let maxTechnologyLines = 3
    let cellHeight: CGFloat = 40
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        setupTableView()
        updateTableHeight()
        updateButtonState()
    }
    
    private func updateButtonState() {
        if isValidEmail() {
            inviteButton.alpha = 1
            inviteButton.isEnabled = true
        } else {
            inviteButton.alpha = 0.5
            inviteButton.isEnabled = false
        }
    }
    
    private func updateTableHeight() {
    let newHeight = cellHeight * CGFloat(availableTechnologies.count)
        constraintTableViewHeight.constant = newHeight
    }
    
    // MARK: - IBActions
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openOptions(_ sender: UIButton) {
    }
    
    @IBAction func addNewTechnology (_ sender: UIButton) {
        let storyboard = UIStoryboard(name: Constants.controllers.makeTechnologyViewController, bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: Constants.controllers.makeTechnologyViewController) as? MakeTechnologyViewController else {
            return
        }
        SwiftEntryKit.display(entry: vc, using: EKAttributes.default)
    }
    
    @IBAction func inviteUser(_ sender: UIButton) {
    }
    
    
    // MARK: - Private methods
    
    private  func isValidEmail() -> Bool {
        guard let txt = emailTextField.text else {
            return false
        }
        let emailTest = NSPredicate(format:"SELF MATCHES %@", Constants.commonStrings.eMailFormat)
        return emailTest.evaluate(with: txt)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let InvaiteUserTableViewNib = UINib(nibName: Constants.cellsID.chooseTechnologyForUserTableViewCell, bundle: nil)
        tableView.register(InvaiteUserTableViewNib, forCellReuseIdentifier: Constants.cellsID.chooseTechnologyForUserTableViewCell)
        self.tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableView.automaticDimension
    }
}

extension InvaiteUserViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            hoursTextField.becomeFirstResponder()
        } else if textField == hoursTextField {
            hoursTextField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateButtonState()
    }
}

extension InvaiteUserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableTechnologies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellsID.chooseTechnologyForUserTableViewCell) as? ChooseTechnologyForUserTableViewCell else {
            return UITableViewCell()
        }
        cell.setupCell(withTechnology: availableTechnologies[indexPath.row])
        return cell
    }
}

