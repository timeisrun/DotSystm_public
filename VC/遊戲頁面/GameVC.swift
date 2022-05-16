//
//  GameVC.swift
//  DotSystem
//
//  Created by ccc on 2022/1/15.
//

import UIKit
import StoreKit

class GameVC: UIViewController {
    
    // 本局目標分數, 為0表示無限局
    var targetScore = 0
    
    // 遊戲經過秒數
    var playingTimes = 0
    
    var dotTimer: Timer?
    
    var gamePanel: Panel?
    
    private var scoreLabelArray: [UILabel] = []

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var targetScoreLabel: UILabel!
    
    @IBOutlet weak var questionImage: UIImageView!
    @IBOutlet weak var cameraImage: UIImageView!
    @IBOutlet weak var rangeImage: UIImageView!
    
    @IBOutlet weak var pauseImage: UIImageView!
    @IBOutlet weak var playImage: UIImageView!
    @IBOutlet weak var cancelImage: UIImageView!
    
    @IBOutlet weak var scoreboardStackView: UIStackView!
    @IBOutlet weak var scoreboardLabel1: UILabel!
    @IBOutlet weak var scoreboardLabel2: UILabel!
    @IBOutlet weak var scoreboardLabel3: UILabel!
    @IBOutlet weak var scoreboardLabel4: UILabel!
    @IBOutlet weak var scoreboardLabel5: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 若成就未達成, 不顯示範圍功能
        if !AchievementUtils.isRangeFunctionValid() {
            self.rangeImage.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 設定分數版
        self.drawScoreboard()
        
        self.buildGamePanel()
        self.runGame()
        
        self.submitTapPanelAction()
    }
    
    private func buildGamePanel() {
        
        self.gamePanel = Panel(parentView: self.contentView)
        
        // 初始化點點
        self.gamePanel?.createDot(count: 30, besideBlack: true)
        
        // 放置點點
        self.gamePanel?.pushDot2View(parentView: self.contentView)
        
        // 遊戲面板可以點擊
        self.gamePanel?.enablePanelInteractive()
        
        // 顯示分數版
        self.showScoreboard()
    }
    
    private func runGame() {
        
        self.dotTimer?.invalidate()
        
        // 設定並產生timer
        self.dotTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(dotClock), userInfo: nil, repeats: true)
    }
    
    private func drawScoreboard() {
        
        self.scoreboardStackView.alpha = 0
        self.scoreboardStackView.layer.cornerRadius = CommonUtils.commonRadius
        self.scoreboardStackView.layer.borderColor = UIColor.darkGray.cgColor
        self.scoreboardStackView.layer.borderWidth = 1
        
        self.scoreboardStackView.isLayoutMarginsRelativeArrangement = true
        self.scoreboardStackView.layoutMargins = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        
        // 塞進陣列
        self.scoreLabelArray = [self.scoreboardLabel1, self.scoreboardLabel2, self.scoreboardLabel3, self.scoreboardLabel4, self.scoreboardLabel5]
        
    }
    
    private func showScoreboard() {
        
        let duration = 0.3
        
        self.scoreboardStackView.alpha = 0
        
        // 顯示面板
        UIView.animate(withDuration: duration,
            delay: 0.0,
            options: UIView.AnimationOptions.curveEaseInOut,
            animations: {
                self.scoreboardStackView.alpha = 1
            },
            
            completion: { finished in
            }
        )
        
    }
    
    private func hideScoreboard() {
        
        let duration = 0.2
        
        UIView.animate(withDuration: duration,
            delay: 0.0,
            options: UIView.AnimationOptions.curveEaseInOut,
            animations: {
                self.scoreboardStackView.alpha = 0
            },
            
            completion: { finished in
            }
        )
        
    }
    
    private func setTargetScoreLabel() {
        
        // 提示文字
        let targetTitle = self.targetScore == 0 ? NSLocalizedString("Game.NoneMission", comment: "") : String.localizedStringWithFormat(NSLocalizedString("Game.BlackMission", comment: ""), self.targetScore)
        
        self.targetScoreLabel.textColor = UIColor(red: 135/255, green: 206/255, blue: 235/255, alpha: 0.8)
        self.targetScoreLabel.text = String.localizedStringWithFormat(NSLocalizedString("Game.WinnerAndTarget", comment: ""), targetTitle)
        
        self.targetScoreLabel.alpha = 1
        
    }
    
    private func submitTapPanelAction() {
        
        self.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapPanel(sender:))))
        
        self.pauseImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pauseAction)))
        self.playImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(playAction)))
        self.cancelImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancelAction)))
        
        self.questionImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(questionAction)))
        self.cameraImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cameraAction)))
        self.rangeImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rangeAction)))
    }
}

extension GameVC {
    
    @objc private func dotClock() {
        
        // 判斷是否為準備階段
        let limitTime = 30
        let isNotPreparing: Bool
        if self.playingTimes <= limitTime {
            isNotPreparing = false
        } else {
            isNotPreparing = true
        }
        
        if self.playingTimes == 0 {
            self.scoreLabelAnimation(title: NSLocalizedString("Game.TapPanelAndCount3", comment: ""))
        } else if self.playingTimes == 10 {
            self.scoreLabelAnimation(title: NSLocalizedString("Game.TapPanelAndCount2", comment: ""))
        } else if self.playingTimes == 20 {
            self.scoreLabelAnimation(title: NSLocalizedString("Game.TapPanelAndCount1", comment: ""))
        } else if self.playingTimes == 30 {
            self.setTargetScoreLabel()
        }
        
        // 每10次(1秒)加一次時間成就
        self.playingTimes += 1
        if isNotPreparing && self.playingTimes % 10 == 0 {
            // 增加成就
            AchievementUtils.addAchievement(by: .GamePlayingTimes)
        }
        
        // 自動新增點點
        if isNotPreparing {
            self.gamePanel?.autoProduceDot(count: 5, besideBlack: true)
        }
        
        // 若有需要增加的黑點則增加
        self.gamePanel?.mergeAddingDotArray()
        
        // 計算下一步路徑
        if isNotPreparing {
            self.gamePanel?.calcStatus()
        }
        
        // 畫出來
        self.drawStatus()
        
        // 計算分數
        let valueColorArray = self.gamePanel?.calcScoreBoard()
        
        // 更新分數版
        self.refreshScoreLabel(valueColorArray: valueColorArray)
        
        // 判斷是否有人獲勝
        if isNotPreparing {
            self.identifyWinner(valueColorArray: valueColorArray)
        }
    }
    
    private func drawStatus() {
        
        // 移除點點
        self.gamePanel?.removeDotFromView(parentView: self.contentView)
        
        // 放置點點
        self.gamePanel?.pushDot2View(parentView: self.contentView)
        
    }
    
    private func refreshScoreLabel(valueColorArray: [Dictionary<String, Any>]?) {
        
        guard let valueColorArray = valueColorArray else {
            return
        }
        
        // 改變label數據
        for i in 0..<5 {
            if i >= valueColorArray.count {
                self.scoreLabelArray[i].text = "0"
                continue
            }
            
            let value = valueColorArray[i]["value"] as? Double ?? 0
            let color = valueColorArray[i]["color"] as? UIColor ?? .darkGray
            
            self.scoreLabelArray[i].text = String(format: "%.2f", value)
            self.scoreLabelArray[i].textColor = color
        }
        
    }
    
    private func identifyWinner(valueColorArray: [Dictionary<String, Any>]?) {
        
        guard let valueColorArray = valueColorArray, valueColorArray.count >= 1 else {
            return
        }
        
        // 判斷是否有人獲勝
        let targetScore = Double(self.targetScore)
        if targetScore == 0 {
            // 0分表示infinite局, 不需動作
            return
        }
        
        // 取最高分者
        let highestValue = valueColorArray[0]["value"] as? Double ?? 0
        if highestValue < targetScore {
            // 未達最高分, 不動作
            return
        }
        
        // 停止timer
        self.dotTimer?.invalidate()
        
        // 勝者為王
        let highestColor = valueColorArray[0]["color"] as? UIColor ?? .darkGray
        
        // 判斷勝利是否為黑色
        let winnerTitle: String
        if highestColor == UIColor.black {
            winnerTitle = NSLocalizedString("Game.isWin", comment: "")
            
            // 增加成就
            AchievementUtils.addAchievement(by: .GameWin)
        } else {
            winnerTitle = NSLocalizedString("Game.isFailed", comment: "")
            
            // 增加成就
            AchievementUtils.addAchievement(by: .GameFailed)
        }
        
        // 製作勝利者文字
        let winnerColorString = CommonUtils.getColorString(color: highestColor)
        let winnerMessage = String.localizedStringWithFormat(NSLocalizedString("Game.WinnerMessage", comment: ""), winnerColorString, String(format: "%.2f", highestValue), self.targetScore)
        
        // 記錄顏色成就
        let achiKey: AchievementUtils.Cumulates?
        switch highestColor {
        case .black:
            achiKey = .GameBlackWin
        case .gray:
            achiKey = .GameGrayWin
        case .red:
            achiKey = .GameRedWin
        case .orange:
            achiKey = .GameOrangeWin
        case .yellow:
            achiKey = .GameYellowWin
        case .green:
            achiKey = .GameGreenWin
        case .blue:
            achiKey = .GameBlueWin
        case .purple:
            achiKey = .GamePrupleWin
        default:
            achiKey = nil
        }
        
        if let key = achiKey {
            AchievementUtils.addAchievement(by: key)
        }
        
        // 增加局數型態成就
        if self.targetScore < 2000 {
            AchievementUtils.addAchievement(by: .FinishSmallGame)
        } else if self.targetScore <= 8000 {
            AchievementUtils.addAchievement(by: .FinishMidGame)
        } else {
            AchievementUtils.addAchievement(by: .FinishLargeGame)
        }
        
        // 顯示勝利者
        let alert = UIAlertController(title: winnerTitle, message: winnerMessage, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: NSLocalizedString("Game.GoHomePage", comment: ""), style: .default) { [weak self] _ in
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
    
    private func scoreLabelAnimation(title: String) {
        
        self.targetScoreLabel.alpha = 1
        self.targetScoreLabel.text = title
        UIView.animate(withDuration: 0.9,
            delay: 0.0,
            options: UIView.AnimationOptions.curveEaseInOut,
            animations: {
                self.targetScoreLabel.alpha = 0
            },
            
            completion: { finished in
            }
        )
    }
    
    @objc private func tapPanel(sender: UITapGestureRecognizer) {
        
        guard let enable = self.gamePanel?.isPanelInteractive(), enable else {
            return
        }
        
        if sender.state == .ended {
            
            // 若為暫停狀態, 不增加點
            guard let isValid = self.dotTimer?.isValid, isValid else {
                return
            }
            
            ImpactFeedbackUtils.shake(type: .light)
            
            AnalyticsUtils.sendEvent(type: .game_tap_panel)
            
            let touchLocation = sender.location(in: sender.view)
            self.gamePanel?.tapPanel(width: touchLocation.x, height: touchLocation.y)
        }
        
    }
    
    @objc private func pauseAction() {
        guard let dt = self.dotTimer, dt.isValid else {
            return
        }
        
        ImpactFeedbackUtils.shake(type: .light)
        
        AnalyticsUtils.sendEvent(type: .game_pause)
        
        self.dotTimer?.invalidate()
    }
    
    @objc private func playAction() {
        guard let dt = self.dotTimer, !dt.isValid else {
            return
        }
        
        ImpactFeedbackUtils.shake(type: .light)
        
        AnalyticsUtils.sendEvent(type: .game_play)
        
        self.runGame()
    }
    
    @objc private func cancelAction() {
        
        ImpactFeedbackUtils.shake(type: .light)
        
        AnalyticsUtils.sendEvent(type: .game_giveup)
        
        self.dotTimer?.invalidate()
        
        // 跳出確認視窗
        let alert = UIAlertController(title: NSLocalizedString("Game.CancelGame", comment: ""), message: "", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: NSLocalizedString("Game.ConfirmCancel", comment: ""), style: .default) { [weak self] _ in
            guard let self = self else {
                return
            }
            
            AnalyticsUtils.sendEvent(type: .game_giveup_sure)
            
            self.dismiss(animated: false, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Game.NotCancel", comment: ""), style: .cancel) { [weak self] _ in
            guard let self = self else {
                return
            }
            
            AnalyticsUtils.sendEvent(type: .game_giveup_cancel)
            
            self.runGame()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        
        self.present(alert, animated: true)
    }
    
    @objc private func questionAction() {
        
        ImpactFeedbackUtils.shake(type: .light)
        
        AnalyticsUtils.sendEvent(type: .game_question)
        
        self.dotTimer?.invalidate()
        
        // 跳出確認視窗
        let alert = UIAlertController(title: NSLocalizedString("Game.InfTitle", comment: ""), message: NSLocalizedString("Game.InfContent", comment: ""), preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: NSLocalizedString("Game.InfGotIt", comment: ""), style: .default) { [weak self] _ in
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
        
        AnalyticsUtils.sendEvent(type: .game_camera)
        
        UIImageWriteToSavedPhotosAlbum(self.contentView.asImage(), nil, nil, nil)
        
        AlertUtils.showAlert(parentView: self.view, text: NSLocalizedString("Game.Capture", comment: ""))
    }
    
    @objc private func rangeAction() {
        
        ImpactFeedbackUtils.shake(type: .light)
        
        AnalyticsUtils.sendEvent(type: .game_range)
        
        // 如果首頁黑色有勝利10次, 可使用range功能
        if !AchievementUtils.isRangeFunctionValid() {
            AlertUtils.showAlert(parentView: self.view, text: NSLocalizedString("Game.RangeLocked", comment: ""))
            return
        }
        
        let showRange = UserDefaultUtils.getShowDotRange()
        
        if showRange {
            UserDefaultUtils.setShowDotRange(showRange: false)
            AlertUtils.showAlert(parentView: self.view, text: NSLocalizedString("Game.RangeHide", comment: ""))
            
            AnalyticsUtils.sendEvent(type: .game_range_not_show)
        } else {
            UserDefaultUtils.setShowDotRange(showRange: true)
            AlertUtils.showAlert(parentView: self.view, text: NSLocalizedString("Game.RangeShow", comment: ""))
            
            AnalyticsUtils.sendEvent(type: .game_range_show)
        }
    }
}
