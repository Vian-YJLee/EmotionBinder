//
//  FilterCollectionViewCell.swift
//  EmotionBinder
//
//  Created by LeeYongJin on 2019/08/20.
//  Copyright © 2019 vian. All rights reserved.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    
    
    
    
    @IBOutlet weak var filterTitle: UILabel!
    @IBOutlet weak var filterMaskingImage: UIImageView!
    
    override func awakeFromNib() {
        
        filterTitle.textColor = self.isSelected ? UIColor.black : UIColor.gray
        
    }
    
    override var isSelected: Bool {
        
        get {
            return super.isSelected
        }
        set {
            if newValue {
                super.isSelected = true
                self.filterTitle.textColor = UIColor.black
            } else if newValue == false {
                super.isSelected = false
                self.filterTitle.textColor = UIColor.gray
            }
        }
    }
    
}
