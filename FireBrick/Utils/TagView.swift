//
//  TagView.swift
//  FireBrick
//
//  Created by metoSimka on 05/06/2019.
//  Copyright © 2019 metoSimka. All rights reserved.
//
//
//import UIKit
//
//class TagView: UIView {
//    
//    var tagOffset: CGFloat = 8
//    var maximumLines = 10
//    var tagHeight: CGFloat = 20
//    var verticalSpace: CGFloat = 3
//    
//    var tags: [String] = ["Technolohy of hell", "wait WHAT?","Realy?", "No, realy? This is work? lul", "Design", "Humor","Travel", "Music", "Writing", "Social Media", "Life", "Education"]// "Edtech", "Education Reform", "Photography", "Startup", "Poetry", "Women In Tech", "Female Founders", "Business", "Fiction", "Love", "Food", "Sports"]
//    
//    override func awakeFromNib() {
//        
//        tagInit()
//    }
//    
//    private func tagInit() {
//        var currentWidthOfTags:CGFloat = 0
//        var currentHeightOfTags: CGFloat = tagHeight
//        var xPosition: CGFloat = 0
//        var yPosition: CGFloat = 0
//        let spaceLine: CGFloat = 4
//
//        for tag in tags {
//            if isViewHeightLessThen(height: currentHeightOfTags ) {
//                self.bounds.size.height = currentHeightOfTags
//            }
//            let newView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
//            newView.cornerRadius = 4
//            newView.backgroundColor = UIColor.lightGray
//            
//            // MARK: - Label setup
//            let label = UILabel()
//            label.text = tag
//            label.textAlignment = .center
//            label.font = UIFont.systemFont(ofSize: 10)
//            
//            label.frame = CGRect(x: 0,
//                                 y: 0,
//                                 width:label.intrinsicContentSize.width,
//                                 height:label.intrinsicContentSize.width)
//            
//            label.translatesAutoresizingMaskIntoConstraints = false
//            let labelConstraintCenterX = NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: newView, attribute: .centerX, multiplier: 1, constant: 0)
//            let labelConstraintCenterY = NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: newView, attribute: .centerY, multiplier: 1, constant: 0)
//            newView.addConstraints([labelConstraintCenterX, labelConstraintCenterY])
//            newView.bounds.size.width = label.bounds.size.width + (tagOffset*2)
//            
//            
//            //MARK: - subView setup
//            currentWidthOfTags += newView.bounds.size.width+spaceLine
//            
//            if currentWidthOfTags > self.bounds.size.width {
//                currentWidthOfTags = newView.bounds.size.width + spaceLine
//                xPosition = 0
//                yPosition += tagHeight + verticalSpace
//                currentHeightOfTags += yPosition
//                if currentHeightOfTags > self.bounds.size.height {
//                    print("YEOHOHOHOHOHOOHOHOHOHOHOHOHOHOHOHOHOHOHO")
//                } else {
//                }
//                newView.translatesAutoresizingMaskIntoConstraints = false
//                let horizontalConstraint = NSLayoutConstraint(item: newView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: xPosition)
//                
//                let verticalConstraint = NSLayoutConstraint(item: newView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: yPosition)
//                //
//                let widthConstraint = NSLayoutConstraint(item: newView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: newView.bounds.size.width)
//                
//                let heightConstraint = NSLayoutConstraint(item: newView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20)
//                
//                self.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
//            } else {
//                
//                newView.translatesAutoresizingMaskIntoConstraints = false
//                let horizontalConstraint = NSLayoutConstraint(item: newView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: xPosition)
//                
//                let verticalConstraint = NSLayoutConstraint(item: newView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: yPosition)
//                //
//                let widthConstraint = NSLayoutConstraint(item: newView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: newView.bounds.size.width)
//                
//                let heightConstraint = NSLayoutConstraint(item: newView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20)
//                
//                self.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
//            }
//            newView.addSubview(label)
//            self.addSubview(newView)
//            
//            
//            xPosition += newView.bounds.size.width + spaceLine
//        }
//    }
//    
//    
//    func isViewHeightLessThen(height: CGFloat) -> Bool {
//        if self.bounds.size.height < height {
//            return true
//        }
//        return false
//    }
//}
