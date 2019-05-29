//
//  TeamTableViewCell.swift
//  FireBrick
//
//  Created by metoSimka on 29/05/2019.
//  Copyright © 2019 metoSimka. All rights reserved.
//

import UIKit

protocol TeamTableViewCellDelegate {
    func didTapAddEmployee()
    func didTapOnTeam()
}

class TeamTableViewCell: UITableViewCell {

    var delegate: TeamTableViewCellDelegate?
    var team: Team?
    
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var arrowStateButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addGestureForLabel()
    }
    
    func setCellView() {
        guard let name = team?.name else {
            return
        }
        teamLabel.text = name
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func addEmployee(_ sender: UIButton) {
        self.delegate?.didTapAddEmployee()
    }
    
    func addGestureForLabel() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        teamLabel.addGestureRecognizer(tap)
    }
    
    @objc
    func handleTap(_ sender: UITapGestureRecognizer) {
        self.delegate?.didTapOnTeam()
    }
}
