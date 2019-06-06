//
//  TagCollectionViewCell.swift
//  FireBrick
//
//  Created by metoSimka on 05/06/2019.
//  Copyright © 2019 metoSimka. All rights reserved.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var constraintMaximumWidthTag: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        self.tagLabel.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        self.layer.cornerRadius = 4
         self.constraintMaximumWidthTag.constant = UIScreen.main.bounds.width - 8 * 2 - 8 * 2
    }
}
