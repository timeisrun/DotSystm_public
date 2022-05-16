//
//  ConwaysVC.swift
//  DotSystem
//
//  Created by ccc on 2022/1/24.
//

import UIKit
import StoreKit

class ConwaysVC: UIViewController {
    
    // 遊戲經過秒數
    var playingTimes = 0
    
    var dotTimer: Timer?
    
    var conwaysPanel: Panel?
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var questionImage: UIImageView!
    @IBOutlet weak var cameraImage: UIImageView!
    
    @IBOutlet weak var pauseImage: UIImageView!
    @IBOutlet weak var playImage: UIImageView!
    @IBOutlet weak var cancelImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.buildConwaysPanel()
        self.runGame()
        
        self.submitTapPanelAction()
    }
    
    private func buildConwaysPanel() {
        
        self.conwaysPanel = Panel(parentView: self.contentView)
        
        // 初始化點點
        self.conwaysPanel?.createDot(count: 1000, onlyBlack: true)
        
        // 遊戲面板可以點擊
        self.conwaysPanel?.enablePanelInteractive()
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
}

extension ConwaysVC {
    
    @objc private func dotClock() {
        
        // 每10次(1秒)加一次時間成就
        self.playingTimes += 1
        if self.playingTimes % 10 == 0 {
            // 增加成就
            AchievementUtils.addAchievement(by: .ConwaysPlayingTimes)
        }
        
        // 計算下一步路徑
        self.conwaysPanel?.calcConwaysStatus()
        
        // 若有需要增加的黑點則增加
        self.conwaysPanel?.mergeAddingDotArray()
        
        // 畫出來
        self.drawStatus()
        
        // 判斷是否勝利
        self.identifyWinner()
    }
    
    private func drawStatus() {
        
        // 移除點點
        self.conwaysPanel?.removeDotFromView(parentView: self.contentView)
        
        // 放置點點
        self.conwaysPanel?.pushDot2View(parentView: self.contentView, setShowRange: false)
    }
    
    private func identifyWinner() {
        
        // 判斷是否有人獲勝
        let dotCount = self.conwaysPanel?.getDotArrayCount() ?? 0
        if dotCount != 0 {
            // 還有點點在畫面, 尚未結束
            return
        }
        
        // 停止timer
        self.dotTimer?.invalidate()
            
        // 增加成就
        AchievementUtils.addAchievement(by: .ConwaysClearDots)
        
        AnalyticsUtils.sendEvent(type: .leisure_conways_winner)
        
        // 顯示結束
        let alert = UIAlertController(title: NSLocalizedString("Conways.ClearViewSuccess", comment: ""), message: "", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: NSLocalizedString("Conways.GoHomePage", comment: ""), style: .default) { [weak self] _ in
            guard let self = self else {
                return
            }
            
            self.dismiss(animated: false, completion: {
                SKStoreReviewController.requestReviewCombine()
            })
        }
        
        alert.addAction(confirmAction)
        
        self.present(alert, animated: true)
    }
    
    @objc private func tapPanel(sender: UITapGestureRecognizer) {
        
        guard let enable = self.conwaysPanel?.isPanelInteractive(), enable else {
            return
        }
        
        if sender.state == .ended {
            
            // 若為暫停狀態, 不增加點
            guard let isValid = self.dotTimer?.isValid, isValid else {
                return
            }
            
            ImpactFeedbackUtils.shake(type: .light)
            
            AnalyticsUtils.sendEvent(type: .leisure_conways_tap_panel)
            
            let touchLocation = sender.location(in: sender.view)
            self.conwaysPanel?.tapPanel(width: touchLocation.x, height: touchLocation.y)
        }
    }
    
    @objc private func pauseAction() {
        guard let dt = self.dotTimer, dt.isValid else {
            return
        }
        
        ImpactFeedbackUtils.shake(type: .light)
        
        AnalyticsUtils.sendEvent(type: .leisure_conways_pause)
        
        self.dotTimer?.invalidate()
    }
    
    @objc private func playAction() {
        guard let dt = self.dotTimer, !dt.isValid else {
            return
        }
        
        ImpactFeedbackUtils.shake(type: .light)
        
        AnalyticsUtils.sendEvent(type: .leisure_conways_play)
        
        self.runGame()
    }
    
    @objc private func cancelAction() {
        
        ImpactFeedbackUtils.shake(type: .light)
        
        AnalyticsUtils.sendEvent(type: .leisure_conways_giveup)
        
        self.dotTimer?.invalidate()
        
        // 跳出確認視窗
        let alert = UIAlertController(title: NSLocalizedString("Conways.CancelGame", comment: ""), message: "", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: NSLocalizedString("Conways.ConfirmCancel", comment: ""), style: .default) { [weak self] _ in
            guard let self = self else {
                return
            }
            
            AnalyticsUtils.sendEvent(type: .leisure_conways_giveup_sure)
            
            self.dismiss(animated: false, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Conways.NotCancel", comment: ""), style: .cancel) { [weak self] _ in
            guard let self = self else {
                return
            }
            
            AnalyticsUtils.sendEvent(type: .leisure_conways_giveup_cancel)
            
            self.runGame()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        
        self.present(alert, animated: true)
    }
    
    @objc private func questionAction() {
        
        ImpactFeedbackUtils.shake(type: .light)
        
        AnalyticsUtils.sendEvent(type: .leisure_conways_question)
        
        self.dotTimer?.invalidate()
        
        // 跳出確認視窗
        let alert = UIAlertController(title: NSLocalizedString("Conways.InfTitle", comment: ""), message: NSLocalizedString("Conways.InfContent", comment: ""), preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: NSLocalizedString("Conways.InfGotIt", comment: ""), style: .default) { [weak self] _ in
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
        
        AnalyticsUtils.sendEvent(type: .leisure_conways_camera)
        
        UIImageWriteToSavedPhotosAlbum(self.contentView.asImage(), nil, nil, nil)
        
        AlertUtils.showAlert(parentView: self.view, text: NSLocalizedString("Conways.Capture", comment: ""))
    }
}
