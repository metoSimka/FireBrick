//
//  AddProjectViewController.swift
//  FireBrick
//
//  Created by metoSimka on 07/06/2019.
//  Copyright © 2019 metoSimka. All rights reserved.
//

import UIKit

class AddProjectViewController: UIViewController {
    
    var selectedTechnologies: [Technology] = []

    @IBOutlet weak var textViewDescription: UITextView!
    @IBOutlet weak var textFieldProjectName: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var constraintTableViewHeight: NSLayoutConstraint!
    
    let cellHeight: CGFloat = 75
    
    private func updateTableViewHeight() {
        let height = cellHeight * CGFloat(selectedTechnologies.count)
        constraintTableViewHeight.constant = height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textViewDescription.delegate = self
        textFieldProjectName.delegate = self
        textViewDescription.textContainer.lineFragmentPadding = 12
        updateTableViewHeight()
    }
    
    @IBAction func back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func check(_ sender: UIButton) {
    }
    
    @IBAction func makeNewTechnology(_ sender: Any) {
        let storyboard = UIStoryboard(name: Constants.controllers.addTechnologyViewController, bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: Constants.controllers.addTechnologyViewController  ) as? AddTechnologyViewController else {
            return
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBDesignable class UITextViewFixed: UITextView {
        override func layoutSubviews() {
            super.layoutSubviews()
            setup()
        }
        func setup() {
            textContainerInset = UIEdgeInsets.zero
            textContainer.lineFragmentPadding = 0
        }
    }
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let InvaiteUserTableViewNib = UINib(nibName: Constants.cellsID.chooseTechnologyForProjectTableViewCell, bundle: nil)
        tableView.register(InvaiteUserTableViewNib, forCellReuseIdentifier: Constants.cellsID.chooseTechnologyForProjectTableViewCell)
        self.tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableView.automaticDimension
    }
}

extension AddProjectViewController: UITextViewDelegate, UITextFieldDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textViewDescription.textColor == UIColor.lightGray {
            textView.text = nil
            textViewDescription.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textViewDescription.text.isEmpty {
            textViewDescription.text = "About this project"
            textViewDescription.textColor = UIColor.lightGray
        }
    }
}

extension AddProjectViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedTechnologies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.cellsID.chooseTechnologyForProjectTableViewCell) as? ChooseTechnologyForProjectTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
}
