//
//  TagCollectionViewCell.swift
//  FireBrick
//
//  Created by metoSimka on 05/06/2019.
//  Copyright © 2019 metoSimka. All rights reserved.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tagLabel: UILabel!
    
    // MARK: - Private constants
    
    let cellInset:CGFloat = 4
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        self.tagLabel.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        self.layer.cornerRadius = 4
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        var newFrame = layoutAttributes.frame
        newFrame.size.width = tagLabel.intrinsicContentSize.width + cellInset*2
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }
    
    // MARK: - Public methods
    
    public func setupCell(withSkill skill: [String: AnyObject]) {
        guard let skillName = skill[Constants.fireStoreFields.teams.skillName] as? String,
            let skillColor = skill[Constants.fireStoreFields.teams.skillColor] as? String,
            let skillAge = skill[Constants.fireStoreFields.teams.skillAge] as? Int else {
                return
        }
        let color = UIColor.hexStringToUIColor(hex: skillColor)
        self.backgroundColor = color
        let skillAgeString = " \(skillAge)+"
        tagLabel.text = skillName + skillAgeString
    }
}
