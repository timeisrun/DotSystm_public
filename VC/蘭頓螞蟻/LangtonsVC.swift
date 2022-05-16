//
//  LangtonsVC.swift
//  DotSystem
//
//  Created by ccc on 2022/1/25.
//

import UIKit
import StoreKit

class LangtonsVC: UIViewController {
    
    // 遊戲經過秒數
    var playingTimes = 0
    
    // 螞蟻位置
    var antX = 0
    var antY = 0
    var antHead = 0 // 1:上, 2: 右, 3: 下, 4: 左
    
    var dotTimer: Timer?
    
    var langtonsPanel: Panel?
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var targetScoreLabel: UILabel!
    
    @IBOutlet weak var questionImage: UIImageView!
    @IBOutlet weak var cameraImage: UIImageView!
    
    @IBOutlet weak var pauseImage: UIImageView!
    @IBOutlet weak var playImage: UIImageView!
    @IBOutlet weak var cancelImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTargetScoreLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.buildLangtonsPanel()
        self.runGame()
        
        self.submitTapPanelAction()
    }
    
    private func buildLangtonsPanel() {
        
        self.langtonsPanel = Panel(parentView: self.contentView)
        
        // 初始化點點
        self.langtonsPanel?.createDot(count: 0, onlyBlack: true)
        
        // 取寬高, 生成初始螞蟻位置, 頭的位置
        self.antX = (self.langtonsPanel?.getWidth() ?? 1) / 2
        self.antY = (self.langtonsPanel?.getHeight() ?? 1) / 2
        self.antHead = Int.random(in: 1...4)
        
        // 遊戲面板可以點擊
        self.langtonsPanel?.enablePanelInteractive()
    }
    
    private func runGame() {
        
        self.dotTimer?.invalidate()
        
        // 設定並產生timer
        self.dotTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(dotClock), userInfo: nil, repeats: true)
    }
    
    private func submitTapPanelAction() {
        
        self.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapPanel(sender:))))
        
        self.pauseImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pauseAction)))
        self.playImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(playAction)))
        self.cancelImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancelAction)))
        
        self.questionImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(questionAction)))
        self.cameraImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cameraAction)))
    }
    
    private func setTargetScoreLabel() {
        
        // 提示文字
        self.targetScoreLabel.textColor = UIColor(red: 135/255, green: 206/255, blue: 235/255, alpha: 0.8)
        self.targetScoreLabel.text = "\(self.playingTimes)"
        
        self.targetScoreLabel.alpha = 1
        
    }
}

extension LangtonsVC {
    
    @objc private func dotClock() {
        
        // 每10次(1秒)加一次時間成就
        self.playingTimes += 1
        if self.playingTimes % 10 == 0 {
            // 增加成就
            AchievementUtils.addAchievement(by: .LangtonsPlayingTimes)
        }
        
        self.targetScoreLabel.text = "\(self.playingTimes)"
        
        // 計算下一步路徑
        if let (newAntX, newAntY, newAntHead) = self.langtonsPanel?.calcLangtonsStatus(antX: self.antX, antY: self.antY, antHead: self.antHead) {
            self.antX = newAntX
            self.antY = newAntY
            self.antHead = newAntHead
        }
        
        // 若有需要增加的黑點則增加
        self.langtonsPanel?.mergeAddingDotArray()
        
        // 畫出來
        self.drawStatus()
        
        // 若萬步, 增加成就
        if self.playingTimes == 10000 {
            AchievementUtils.addAchievement(by: .LangtonsTenThousand)
            
            SKStoreReviewController.requestReviewCombine()
        }
    }
    
    private func drawStatus() {
        
        // 移除點點
        self.langtonsPanel?.removeDotFromView(parentView: self.contentView)
        
        // 放置點點
        self.langtonsPanel?.pushDot2View(parentView: self.contentView, setShowRange: false)
    }
    
    @objc private func tapPanel(sender: UITapGestureRecognizer) {
        
        guard let enable = self.langtonsPanel?.isPanelInteractive(), enable else {
            return
        }
        
        if sender.state == .ended {
            
            // 若為暫停狀態, 不增加點
            guard let isValid = self.dotTimer?.isValid, isValid else {
                return
            }
            
            ImpactFeedbackUtils.shake(type: .light)
            
            AnalyticsUtils.sendEvent(type: .leisure_langtons_tap_panel)
            
            let touchLocation = sender.location(in: sender.view)
            self.langtonsPanel?.tapPanel(width: touchLocation.x, height: touchLocation.y)
        }
    }
    
    @objc private func pauseAction() {
        guard let dt = self.dotTimer, dt.isValid else {
            return
        }
        
        ImpactFeedbackUtils.shake(type: .light)
        
        AnalyticsUtils.sendEvent(type: .leisure_langtons_pause)
        
        self.dotTimer?.invalidate()
    }
    
    @objc private func playAction() {
        guard let dt = self.dotTimer, !dt.isValid else {
            return
        }
        
        ImpactFeedbackUtils.shake(type: .light)
        
        AnalyticsUtils.sendEvent(type: .leisure_langtons_play)
        
        self.runGame()
    }
    
    @objc private func cancelAction() {
        
        ImpactFeedbackUtils.shake(type: .light)
        
        AnalyticsUtils.sendEvent(type: .leisure_langtons_giveup)
        
        self.dotTimer?.invalidate()
        
        // 跳出確認視窗
        let alert = UIAlertController(title: NSLocalizedString("Langtons.CancelGame", comment: ""), message: "", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: NSLocalizedString("Langtons.ConfirmCancel", comment: ""), style: .default) { [weak self] _ in
            guard let self = self else {
                return
            }
            
            AnalyticsUtils.sendEvent(type: .leisure_langtons_giveup_sure)
            
            self.dismiss(animated: false, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Langtons.NotCancel", comment: ""), style: .cancel) { [weak self] _ in
            guard let self = self else {
                return
            }
            
            AnalyticsUtils.sendEvent(type: .leisure_langtons_giveup_cancel)
            
            self.runGame()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        
        self.present(alert, animated: true)
    }
    
    @objc private func questionAction() {
        
        ImpactFeedbackUtils.shake(type: .light)
        
        AnalyticsUtils.sendEvent(type: .leisure_langtons_question)
        
        self.dotTimer?.invalidate()
        
        // 跳出確認視窗
        let alert = UIAlertController(title: NSLocalizedString("Langtons.InfTitle", comment: ""), message: NSLocalizedString("Langtons.InfContent", comment: ""), preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: NSLocalizedString("Langtons.InfGotIt", comment: ""), style: .default) { [weak self] _ in
            guard let self = self else {
                return
            }
            
            self.runGame()
        }
        
        alert.addAction(confirmAction)
        
        self.present(alert, animated: true)
    }
    
    @objc private func cameraAction() {
        
        ImpactFeedbackUtils.shake(type: .light)
        
        AnalyticsUtils.sendEvent(type: .leisure_langtons_camera)
        
        UIImageWriteToSavedPhotosAlbum(self.contentView.asImage(), nil, nil, nil)
        
        AlertUtils.showAlert(parentView: self.view, text: NSLocalizedString("Langtons.Capture", comment: ""))
    }
}
