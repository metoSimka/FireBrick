//
//  EmployeeTableViewCell.swift
//  FireBrick
//
//  Created by metoSimka on 28/05/2019.
//  Copyright © 2019 metoSimka. All rights reserved.
//

import UIKit
import SDWebImage

protocol EmployeeTableViewCellDelegate {
    func didTapOptionButton()
    func didTapOnUser()
}

class TeamMemberTableViewCell: UITableViewCell {
    
    var delegate: EmployeeTableViewCellDelegate?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func openOptions(_ sender: UIButton) {
        self.delegate?.didTapOptionButton()
    }
    
    func addGestureForLabel() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        imageIcon.addGestureRecognizer(tap)
    }
    
    func setupCell(withUser user: User) {
        nameLabel.text = user.name
        guard let link = user.imageLink else {
            return
        }
        imageIcon.sd_setImage(with: URL(string: link), placeholderImage: UIImage(named: Constants.commonStrings.placeHolder))
    }
    
    @objc
    func handleTap(_ sender: UITapGestureRecognizer) {
        self.delegate?.didTapOnUser()
    }
}