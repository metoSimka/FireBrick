//
//  TeamTableViewCell.swift
//  FireBrick
//
//  Created by metoSimka on 29/05/2019.
//  Copyright © 2019 metoSimka. All rights reserved.
//

import UIKit

protocol TeamTableViewCellDelegate {
    func didTapAddEmployee(inCell: TeamTableViewCell)
    func didTapOnTeam(inCell: TeamTableViewCell)
}

class TeamTableViewCell: UITableViewCell {
    
    // MARK: - Public variables
    
    var delegate: TeamTableViewCellDelegate?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var arrowStateButton: UIButton!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addGestureForLabel()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - IBActions
    
    @IBAction func addEmployee(_ sender: UIButton) {
        self.delegate?.didTapAddEmployee(inCell: self)
        self.delegate?.didTapOnTeam(inCell: self)
    }
    
    // MARK: - Public methods
    
    public func setupCell(with team: Team) {
        teamLabel.text = team.name
    }
    
    public func updateButtonState(isHidden: Bool) {
        if isHidden {
            arrowStateButton.isSelected = true
        } else {
            arrowStateButton.isSelected = false
        }
    }
    
    // MARK: - Private methods
    
    
    private func addGestureForLabel() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        teamLabel.addGestureRecognizer(tap)
    }
    
    @objc
    private func handleTap(_ sender: UITapGestureRecognizer) {
        self.delegate?.didTapOnTeam(inCell: self)
    }
}
