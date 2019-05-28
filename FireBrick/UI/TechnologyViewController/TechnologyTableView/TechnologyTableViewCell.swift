//
//  TableViewCell.swift
//  FireBrick
//
//  Created by metoSimka on 27/05/2019.
//  Copyright © 2019 metoSimka. All rights reserved.
//

import UIKit

class TechnologyTableViewCell: UITableViewCell {
    
    var technology: Technology?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var docLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setTechnology() {
        nameLabel.text = "Name: " + (technology?.name ?? "")
        docLabel.text = "Documentation: " + (technology?.documentation ?? "")
    }
}
