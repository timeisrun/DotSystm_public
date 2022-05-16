//
//  AchievementVC.swift
//  DotSystem
//
//  Created by ccc on 2022/1/22.
//

import UIKit

class AchievementVC: UIViewController {
    
    var achievementsList: [Dictionary<String, Any>] = []
    
    @IBOutlet weak var emptyAchiLabel: UILabel!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var cancelImage: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.alpha = 0
        
        // 設定空白成就時的文字語系
        self.emptyAchiLabel.text = NSLocalizedString("Achievement.NoAchievement", comment: "")
        
        // 整理成就資料
        self.getAchievementsList()
        
        // 註冊cell
        self.collectionView.register(UINib(nibName: "AchievementCVC", bundle: nil), forCellWithReuseIdentifier: "AchievementCVC")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.decoratePanel()
        
        self.showPanel()
        
        self.submitButtonAction()
    }
    
    private func getAchievementsList() {
        
        self.achievementsList = AchievementUtils.getAllAchievements(besideEmpty: true)
        
        // 若為空則顯示label
        if self.achievementsList.count == 0 {
            self.emptyAchiLabel.isHidden = false
        } else {
            self.emptyAchiLabel.isHidden = true
        }
        
    }
    
    private func decoratePanel() {
        
        self.contentView.layer.cornerRadius = CommonUtils.commonRadius
        
    }
    
    private func showPanel() {
        
        let duration = 0.5
        
        UIView.animate(withDuration: duration,
            delay: 0.0,
            options: UIView.AnimationOptions.curveEaseInOut,
            animations: {
                self.view.alpha = 1
            },
            
            completion: { _ in
            }
        )
    }
                       
    private func hidePanel(completion: @escaping () -> ()) {
        
        let duration = 0.3
        
        self.view.alpha = 1
        
        UIView.animate(withDuration: duration,
            delay: 0.0,
            options: UIView.AnimationOptions.curveEaseInOut,
            animations: {
                self.view.alpha = 0
            },
            
            completion: { _ in
                completion()
            }
        )
    }
    
    private func submitButtonAction() {
        
        self.cancelImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (cancelAction)))
        
    }
        
}

extension AchievementVC {
    
    @objc private func cancelAction() {
        
        ImpactFeedbackUtils.shake(type: .light)
        
        AnalyticsUtils.sendEvent(type: .achievement_cancel)
        
        self.hidePanel { [weak self] in
            guard let self = self else {
                return
            }
            
            self.dismiss(animated: false, completion: nil)
        }
        
    }
    
}

extension AchievementVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.achievementsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // -20 為layout的left 和 right
        return CGSize(width: self.collectionView.bounds.width - 20, height: 91)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AchievementCVC", for: indexPath) as! AchievementCVC
        let row = indexPath.row
        
        let dict = self.achievementsList[row]
        
        let title = dict["title"] as? String ?? ""
        let describe = dict["describe"] as? String ?? ""
        
        cell.titleLabel.text = title
        cell.describeLabel.text = describe
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}
