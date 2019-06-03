//
//  TableViewCell.swift
//  FireBrick
//
//  Created by metoSimka on 03/06/2019.
//  Copyright © 2019 metoSimka. All rights reserved.
//

import UIKit
import SDWebImage

class ChooseTechnologyTableViewCell: UITableViewCell {
    
    var technology: Technology?

    
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var labelTechnology: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setTechnology() {
        labelTechnology.text = technology?.name
        guard let link = technology?.icon else {
            return
        }
        imageIcon.sd_setImage(with: URL(string: link), placeholderImage: UIImage(named: Constants.commonStrings.placeHolder))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
