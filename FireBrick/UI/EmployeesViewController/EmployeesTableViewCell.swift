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
    let TAGS = ["Tech", "Design", "Humor", "Travel", "Music", "Writing", "Social Media", "Life", "Education", "Edtech", "Education Reform", "Photography", "Startup", "Poetry", "Women In Tech", "Female Founders", "Business", "Fiction", "Love", "Food", "Sports"]
    
    var sizingCell: TagCollectionViewCell?
    var ss: [CGFloat] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var labelBussyLevel: UILabel!
    @IBOutlet weak var labelBusy: UILabel!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTagCollectionView()
       
        ss = getSizes(massive: TAGS)
    }
    
    func setupTagCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let cellNib = UINib(nibName: "TagCollectionViewCell", bundle: nil)
        self.sizingCell = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! TagCollectionViewCell?
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: "TagCollectionViewCell")
        self.collectionView.backgroundColor = UIColor.gray
        collectionView.collectionViewLayout = LeftAlignedCollectionViewFlowLayout()
    }
    
    func setupCollectionView() {
        let skillsCell = UINib(nibName: Constants.cellsID.skillsCollectionViewCell, bundle: nil)
        collectionView.register(skillsCell, forCellWithReuseIdentifier: Constants.cellsID.skillsCollectionViewCell)
        collectionView.delegate = self
        collectionView.dataSource = self
        let flowLayout = UICollectionViewFlowLayout()
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
    
    func koko() -> [String]? {
        var list:[String] = []
        guard let skills = user?.skills else {
            return nil
        }
        for skill in skills {
            guard let skillName = skill[Constants.fireStoreFields.teams.skillName] as? String else {
                return nil
            }
            list.append(skillName)
        }
        return list
    }
    
    func getget() {
        guard let list = koko() else {
            return
        }
        let sizees = getSizes(massive: list)
        ss = sizees
        collectionView.layoutIfNeeded()
        collectionView.reloadData()
                collectionView.layoutIfNeeded()
    }
    
    func getSizes(massive: [String]) -> [CGFloat] {
        var s: [CGFloat] = []
        for tag in massive {
            
            
            let label = UILabel()
            label.text = tag
            label.font = UIFont(name:"SFProText-Medium", size: 10.0)
            
            label.frame = CGRect(x: 0,
                                 y: 0,
                                 width:label.intrinsicContentSize.width,
                                 height:label.intrinsicContentSize.width)
            s.append(label.bounds.size.width)
        }
        return s
    }
}

extension EmployeesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TAGS.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell", for: indexPath) as! TagCollectionViewCell
        self.configureCell(cell: cell, forIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: TagCollectionViewCell, forIndexPath indexPath: IndexPath) {
        let tag = TAGS[indexPath.row]
        cell.tagLabel.text = tag
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        guard user != nil else {
//            return CGSize(width: 20, height: 20)
//        }
        return CGSize(width: ss[indexPath.row]+16, height: 20)
    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //        if sizingCell != nil {
    //            self.configureCell(cell: self.sizingCell!, forIndexPath: indexPath)
    //            return self.sizingCell!.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    //        }
    //        print("error")
    //        return CGSize()
    //    }
    //    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //        guard let count = user?.skills?.count else {
    //            return 0
    //        }
    //        return count
    //    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }
        
        return attributes
    }
}
