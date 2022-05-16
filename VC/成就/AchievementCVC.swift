//
//  AchievementCVC.swift
//  DotSystem
//
//  Created by ccc on 2022/1/22.
//

import UIKit

class AchievementCVC: UICollectionViewCell {

    @IBOutlet weak var panelView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var describeLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.decoratePanel()
    }
    
    private func decoratePanel() {
        
        self.panelView.layer.borderColor = UIColor.blue.cgColor
        self.panelView.layer.borderWidth = 1
        
        self.panelView.layer.cornerRadius = CommonUtils.commonRadius
        
    }

}
