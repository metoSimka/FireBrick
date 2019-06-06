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
    
    static let minInteritemSpacing:CGFloat = 4
    var user: User?
    
    @IBOutlet weak var constraintCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var labelBussyLevel: UILabel!
    @IBOutlet weak var labelBusy: UILabel!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTagCollectionView()
    }
    
    func updateHeightCollectionView() {
        let height = collectionView.collectionViewLayout.collectionViewContentSize.height
        constraintCollectionViewHeight.constant = height
        self.layoutIfNeeded(); collectionView.layoutIfNeeded()
    }
    
    func setupTagCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let cellNib = UINib(nibName: "TagCollectionViewCell", bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: "TagCollectionViewCell")
        var flowLayout = UICollectionViewFlowLayout()
        flowLayout = LeftAlignedCollectionViewFlowLayout()
        flowLayout.estimatedItemSize = CGSize(width: 40, height: 20)
        collectionView.collectionViewLayout = flowLayout
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

extension EmployeesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let userSkills = user?.skills else {
            return 0
        }
        return userSkills.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell", for: indexPath) as! TagCollectionViewCell
        guard let userSkill = user?.skills else {
            return UICollectionViewCell()
        }
        cell.data = userSkill[indexPath.row]
        cell.configueCell()
        return cell
    }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell", for: indexPath) as! TagCollectionViewCell
            return cell.systemLayoutSizeFitting(cell.tagLabel!.bounds.size)
        }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return EmployeesTableViewCell.minInteritemSpacing
    }
}
