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
    
    // MARK: - Public variables
    
    var delegate: EmployeeTableViewCellDelegate?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - IBActions
    
    @IBAction func openOptions(_ sender: UIButton) {
        self.delegate?.didTapOptionButton()
    }
    
    // MARK: - Public methods
    
    public func setupCell(withUser user: User) {
        nameLabel.text = user.name
        guard let link = user.imageLink else {
            return
        }
        imageIcon.sd_setImage(with: URL(string: link), placeholderImage: UIImage(named: Constants.commonStrings.placeHolder))
    }
    
    // MARK: - Private methods
    
    private func addGestureForLabel() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        imageIcon.addGestureRecognizer(tap)
    }
    
    @objc
    private func handleTap(_ sender: UITapGestureRecognizer) {
        self.delegate?.didTapOnUser()
    }
}
