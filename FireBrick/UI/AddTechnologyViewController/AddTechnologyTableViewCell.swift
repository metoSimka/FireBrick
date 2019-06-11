//
//  AddTechnologyTableViewCell.swift
//  FireBrick
//
//  Created by metoSimka on 11/06/2019.
//  Copyright © 2019 metoSimka. All rights reserved.
//

import UIKit
import SDWebImage

class AddTechnologyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var buttonState: UIButton!
    @IBOutlet weak var labelNameTechnology: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
    
    let colorCellIsSelected = "FBEAEC"
    let colorCellNotSelected = "FDF8F9"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func setupCell(withTechnology technology: Technology) {
        if let name = technology.name {
            labelNameTechnology.text = name
        }
        if let link = technology.icon {
            imageIcon.sd_setImage(with: URL(string: link), placeholderImage: UIImage(named: Constants.commonStrings.placeHolder))
        }
    }
    
    public func cellDidSelected() {
        updateCellState()
    }
    
    private func updateCellState() {
        if buttonState.isSelected {
            buttonState.isSelected = false
            subView.backgroundColor = UIColor.hexStringToUIColor(hex: colorCellNotSelected)
        } else {
            buttonState.isSelected = true
            subView.backgroundColor = UIColor.hexStringToUIColor(hex: colorCellIsSelected)
        }
    }
}
