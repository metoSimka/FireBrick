//
//  TableViewCell.swift
//  FireBrick
//
//  Created by metoSimka on 27/05/2019.
//  Copyright © 2019 metoSimka. All rights reserved.
//

import UIKit

class TechnologyTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var docLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Public methods
    
    public func setupCell(withTechnology technology: Technology) {
        guard let technologyName = technology.name else {
            return
        }
        guard let technologyDoc = technology.documentation else {
            return
        }
        nameLabel.text = "Name: " + (technologyName)
        docLabel.text = "Documentation: " + (technologyDoc)
    }
}
