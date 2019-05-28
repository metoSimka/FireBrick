//
//  TeemTableViewCell.swift
//  FireBrick
//
//  Created by metoSimka on 28/05/2019.
//  Copyright © 2019 metoSimka. All rights reserved.
//

import UIKit

class TeamTableViewCell: UITableViewCell {

    
    @IBOutlet weak var arrowStateButton: UIButton!
    @IBOutlet weak var teamLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func addEmployee(_ sender: UIButton) {
    }
    
}
