//
//  NewTechnologyViewController.swift
//  FireBrick
//
//  Created by metoSimka on 11/06/2019.
//  Copyright © 2019 metoSimka. All rights reserved.
//

import UIKit
import Firebase
import SwiftEntryKit

protocol NewTechnologyViewControllerProtocol {
    func didTapAddButton(newTechnology: Technology)
}

class NewTechnologyViewController: UIViewController {
    
    var delegate: NewTechnologyViewControllerProtocol?
    var selectedColor: UIColor?
    var urls:[String] = []
    
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet var colorButtons: [UIButton]!
    @IBOutlet weak var textFieldNameTechnology: UITextField!
    @IBOutlet weak var imageIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTechnologies()
        setButtonBehavior()
        textFieldNameTechnology.delegate = self
        updateButtonState()
    }

    @IBAction func actionColorButton(_ sender: UIButton) {
        tapColorButtonAction(sender)
        updateButtonState()
    }
    
    @IBAction func addTechnology(_ sender: UIButton) {
        let technology = createTechnology()
        writeDataToFirestore(with: technology)
    }
    private func writeDataToFirestore(with technology: Technology) {
        guard
            let name = technology.name,
            let colorHex = technology.colorHex,
            let icon = technology.icon else {
                return
        }
        Firestore.firestore().collection(Constants.mainFireStoreCollections.technology).addDocument(data:
            [
                Constants.fireStoreFields.technology.name: name,
                Constants.fireStoreFields.technology.color: colorHex,
                Constants.fireStoreFields.technology.documentation: "",
                Constants.fireStoreFields.technology.icon: icon
        ]) { error in
            guard error == nil else {
                print(error?.localizedDescription)
                return
            }
            print("Successful data")
            self.delegate?.didTapAddButton(newTechnology: technology)
            SwiftEntryKit.dismiss()
        }
    }
    private func tapColorButtonAction(_ sender: UIButton) {
        setAllColorButtonToUnselectedState()
        setPickedStateButton(for: sender)
    }
    
    private func setButtonBehavior() {
        for button in colorButtons {
            defineTintDoneImage(for: button)
            setDefaultStateButton(for: button)
        }
    }
    
   private func defineTintDoneImage(for button: UIButton) {
        let imageDone = UIImage(named: "ic_readable_icon_check")
        button.setImage(imageDone, for: .selected)
        button.contentMode = .scaleAspectFit
    }
    
    private func isValidData() -> Bool {
        guard selectedColor != nil else {
            return false
        }
        guard let text = textFieldNameTechnology.text else {
            return false
        }
        guard text.count > 0 else {
            return false
        }
        guard imageIcon.image != nil else {
            return false
        }
        return true
    }
    
    private func updateButtonState() {
        if isValidData() {
            enableButton()
        } else {
            disableButton()
        }
    }
    
    private func enableButton() {
        addButton.isEnabled = true
        addButton.alpha = 1
    }
    
    private func disableButton() {
        addButton.isEnabled = false
        addButton.alpha = 0.5
    }
    
    private func setPickedStateButton(for button: UIButton) {
        button.isSelected = true
    }
    
    private func setAllColorButtonToUnselectedState() {
        for button in colorButtons {
            setDefaultStateButton(for: button)
        }
    }
    
    private func setDefaultStateButton(for button: UIButton) {
        button.isSelected = false
    }
    
    private func fetchTechnologies() {
        Firestore.firestore().collection(Constants.mainFireStoreCollections.storage).getDocuments(completion: { (snapShot, error) in
            guard error == nil else {
                print("error Here", error ?? "Unkown error")
                return
            }
            guard let snapShot = snapShot else {
                return
            }
            var storageURLs:[String] = []
            for data in snapShot.documents {
                guard let urlLink = data[Constants.fireStoreFields.storage.URL] as? String else {
                    return
                }
                storageURLs.append(urlLink)
            }
            self.urls = storageURLs
        })
    }
    
    func createTechnology() -> Technology {
        var newTech = Technology()
        newTech.name = textFieldNameTechnology.text
        newTech.colorHex = selectedColor?.toHexString()
        newTech.icon = "somePNG"
        return newTech
    }
}

extension NewTechnologyViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateButtonState()
    }
}
