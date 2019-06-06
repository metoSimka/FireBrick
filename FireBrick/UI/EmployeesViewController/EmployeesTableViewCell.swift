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
    
    // MARK: - Public constants
    static let minInteritemSpacing:CGFloat = 4
    
    // MARK: - Public variables
    var user: User?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var constraintCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var labelBussyLevel: UILabel!
    @IBOutlet weak var labelBusy: UILabel!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTagCollectionView()
    }
    
    // MARK: - Public methods
    
    func setupCell() {
        labelUserName.text = user?.name
        labelBusy.text = ("\(user?.busy ?? 0) hr / week")
        if let link = user?.imageLink {
            imageAvatar.sd_setImage(with: URL(string: link), placeholderImage: UIImage(named: Constants.commonStrings.placeHolder))
        }
        updateProgressBar()
    }
    
    
    // MARK: - Private methods
    
    private func updateHeightCollectionView() {
        let height = collectionView.collectionViewLayout.collectionViewContentSize.height
        constraintCollectionViewHeight.constant = height
        collectionView.layoutIfNeeded()
    }
    
    private func setupTagCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let cellNib = UINib(nibName: Constants.cellsID.tagCollectionViewCell, bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: Constants.cellsID.tagCollectionViewCell)
        var flowLayout = UICollectionViewFlowLayout()
        flowLayout = LeftAlignedCollectionViewFlowLayout()
        flowLayout.estimatedItemSize = CGSize(width: 40, height: 20)
        collectionView.collectionViewLayout = flowLayout
    }
    
    private  func updateProgressBar() {
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

// MARK: - Protocol Conformance

extension EmployeesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let userSkills = user?.skills else {
            return 0
        }
        return userSkills.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellsID.tagCollectionViewCell, for: indexPath) as? TagCollectionViewCell else {
           return UICollectionViewCell()
        }
        guard let userSkill = user?.skills else {
            return UICollectionViewCell()
        }
        cell.setupCell(withSkill: userSkill[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellsID.tagCollectionViewCell, for: indexPath) as? TagCollectionViewCell else {
            return CGSize()
        }
        guard let label = cell.tagLabel else {
            return CGSize()
        }
        return cell.systemLayoutSizeFitting(label.bounds.size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return EmployeesTableViewCell.minInteritemSpacing
    }
}
