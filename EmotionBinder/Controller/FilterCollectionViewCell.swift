//
//  FilterCollectionViewCell.swift
//  EmotionBinder
//
//  Created by LeeYongJin on 2019/08/20.
//  Copyright © 2019 vian. All rights reserved.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var filterTitleLabel: UILabel!
    @IBOutlet weak var filterMaskingImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        filterTitleLabel.textColor = self.isSelected ? UIColor.black : UIColor.gray
        
    }
    
    override var isSelected: Bool {
       
        /*
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
                    */
        didSet {
            //if로 하는 것이 컴파일 속도는 더 빠르지만.. 토글방식 변경
            self.filterTitleLabel.textColor = isSelected ? UIColor.black : UIColor.gray
        }
    }
}
