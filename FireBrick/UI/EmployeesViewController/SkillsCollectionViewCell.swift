//
//  SkillsCollectionViewCell.swift
//  FireBrick
//
//  Created by metoSimka on 04/06/2019.
//  Copyright © 2019 metoSimka. All rights reserved.
//

import UIKit

class SkillsCollectionViewCell: UICollectionViewCell {
    
    var data: [String:AnyObject]?
    
    @IBOutlet weak var labelSkillName: UILabel!
    @IBOutlet weak var subView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        //Exhibit A - We need to cache our calculation to prevent a crash.
            setNeedsLayout()
            layoutIfNeeded()
            let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
            var newFrame = layoutAttributes.frame
            newFrame.size.width = CGFloat(ceilf(Float(size.width)))
            layoutAttributes.frame = newFrame
        return layoutAttributes
    }
    
    func setSkill() {
        guard let skill = data else {
            return
        }
        guard let skillName = skill[Constants.fireStoreFields.teams.skillName] as? String,
        let skillColor = skill[Constants.fireStoreFields.teams.skillColor] as? String,
        let skillAge = skill[Constants.fireStoreFields.teams.skillAge] as? Int else {
            return
        }
        let color = UIColor.hexStringToUIColor(hex: skillColor)
        subView.backgroundColor = color
        let skillAgeString = " \(skillAge)+"
        labelSkillName.text = skillName + skillAgeString
    }
}

