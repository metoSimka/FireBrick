//
//  ProjectsTableViewCell.swift
//  FireBrick
//
//  Created by metoSimka on 07/06/2019.
//  Copyright © 2019 metoSimka. All rights reserved.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {
    
    var project: Project?
    
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var labelNameProject: UILabel!
    @IBOutlet weak var labelTotalHours: UILabel!
    @IBOutlet weak var labelReleaseLevel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var labelRelease: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func openOptions(_ sender: UIButton) {
    }
    
    public func setupCell(withProject project: Project) {
        self.project = project
        if let name = project.name {
            labelNameProject.text = name
        }
        if let hours = project.hours {
            labelTotalHours.text = String(hours)
        }
        if let link = project.imageLink {
            imageIcon.sd_setImage(with: URL(string: link), placeholderImage: UIImage(named: Constants.commonStrings.placeHolder))
        }
    }
}
