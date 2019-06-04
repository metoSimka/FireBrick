//
//  EmployeesTableViewCell.swift
//  FireBrick
//
//  Created by metoSimka on 03/06/2019.
//  Copyright © 2019 metoSimka. All rights reserved.
//

import UIKit
import SDWebImage

class EmployeesTableViewCell: UITableViewCell {
    
    var user: User?
    
    @IBOutlet weak var labelBussyLevel: UILabel!
    @IBOutlet weak var labelBusy: UILabel!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var progressBar: UIProgressView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUserProfile() {
        labelUserName.text = user?.name
        labelBusy.text = ("\(user?.busy ?? 0) hr / week")
        if let link = user?.imageLink {
            imageAvatar.sd_setImage(with: URL(string: link), placeholderImage: UIImage(named: Constants.commonStrings.placeHolder))
        }
        updateProgressBar()
    }

    func updateProgressBar() {
        guard let busyInt = user?.busy else {
            return
        }
        let busy = CGFloat(busyInt)
        let userBusy = Float(busy / Constants.fireStoreFields.users.standardWeeklyEmploymentValue)
        labelBussyLevel.text = "\(Int(userBusy*100))%"
        progressBar.progress = userBusy
        progressBar.setProgress(userBusy, animated: true)
        if progressBar.progress < 0.3 {
            progressBar.tintColor = UIColor.green
        } else if (progressBar.progress > 0.3) && (progressBar.progress < 0.7) {
            progressBar.tintColor = UIColor.blue
        } else if progressBar.progress > 0.7 {
            progressBar.tintColor = UIColor.red
        }
    }
}
