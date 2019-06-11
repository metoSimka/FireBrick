//
//  ChooseTechnologyForProjectTableViewCell.swift
//  FireBrick
//
//  Created by metoSimka on 11/06/2019.
//  Copyright © 2019 metoSimka. All rights reserved.
//

import UIKit
import SDWebImage

class ChooseTechnologyForProjectTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var labelNameTechnology: UILabel!
    @IBOutlet weak var labelHours: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func setupCell(withProject project: Project) {
        if let name = project.name {
            labelNameTechnology.text = name
        }
        
        if let hours = project.hours {
            labelHours.text = String(hours)
        }
        
        if
            let startDate = project.startDate,
            let endDate = project.endDate {
            labelDate.text = "\(startDate) - \(endDate)"
        }
        if let link = project.imageLink {
            imageIcon.sd_setImage(with: URL(string: link), placeholderImage: UIImage(named: Constants.commonStrings.placeHolder))
        }
    }
    
    @IBAction func openOptions(_ sender: UIButton) {
        
    }
}
