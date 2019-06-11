//
//  AddTechnologyTableViewCell.swift
//  FireBrick
//
//  Created by metoSimka on 07/06/2019.
//  Copyright © 2019 metoSimka. All rights reserved.
//

import UIKit
import SDWebImage

class ChooseTechnologyForUserTableViewCell: UITableViewCell {

      // MARK: - IBOutlets
    
    @IBOutlet weak var labelTechnology: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var labelAge: UILabel!
    
        // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
        // MARK: - Public methods
    
    public func setupCell(withTechnology technology: Technology) {
        if let name = technology.name  {
              labelTechnology.text = name
        }
        if let hrs_in_week = technology.hrs_in_week {
              labelAge.text = String(hrs_in_week)
        }
        if let icon = technology.icon  {
            imageIcon.sd_setImage(with: URL(string: icon), placeholderImage: UIImage(named: Constants.commonStrings.placeHolder))
        }
    }
}
