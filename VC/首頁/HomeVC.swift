//
//  HomeVC.swift
//  DotSystem
//
//  Created by ccc on 2022/1/10.
//

import UIKit
import AVFoundation
import GoogleMobileAds

class HomeVC: UIViewController {
    
    #if DEBUG
        let adPointUID = "xxxxx/yyyyy"
    #else
        let adPointUID = "xxxxx/yyyyy"
    #endif
    
    var goodBoy2Watch = false
    
    var rewardedAd: GADRewardedAd?
    
    var isFirstTimeAtHomePage = true
    
    var isAddedWinnerAchievement = false
    
    var dotTimer: Timer?
    var energyTimer: Timer?
    var energyTimestamp: Int?
    
    var backgroundMusicPlayer: AVQueuePlayer?
    var backgroundMusicLooper: AVPlayerLooper?
    
    var backgroundPanel: Panel?

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var musicImage: UIImageView!
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var topContentView: UIView!
    @IBOutlet weak var energyStackView: UIStackView!
    @IBOutlet weak var energyLabel: UILabel!
    @IBOutlet weak var energyCDLabel: UILabel!
    @IBOutlet weak var lightImage: UIView!
    @IBOutlet weak var energyPlusImage: UIView!
    
    @IBOutlet weak var leftContentView: UIView!
    
    @IBOutlet weak var rightContentView: UIView!
    
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 版本設定
        self.setVersionLabel()
        
        // 廣告
        self.createAndLoadRewardedAd()
        
        self.drawMenu()
        
        self.refreshEnergy()
        
        self.submitButtonAction()
        
        // 設定音樂
        self.setMusic()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 若是第一次進主畫面則初始化
        if self.isFirstTimeAtHomePage {
            self.buildBackgroundPanel()
            
            self.isFirstTimeAtHomePage = false
            
            // 判斷顯示新版本流程
            self.checkVersion()
        }
        
        // 每次都要的處理
        self.runBackground()
        self.showMenu()
    }
    
    private func buildBackgroundPanel() {
        
        self.backgroundPanel = Panel(parentView: self.contentView)
        
        // 取得成就數量, 增加點點數
        var factor = AchievementUtils.getAchievement(by: .HomeHaveWinner)
        
        // 上限增加100個
        factor = factor > 100 ? 100 : factor
        
        // 初始化點點
        self.backgroundPanel?.createDot(count: 10 + factor)
        
        // 放置點點
        self.backgroundPanel?.pushDot2View(parentView: self.contentView)
    }
    
    private func runBackground() {
        
        self.dotTimer?.invalidate()
        
        // 設定並產生timer
        self.dotTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(dotClock), userInfo: nil, repeats: true)
    }
    
    private func drawMenu() {
        
        // 底色
        self.topContentView.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.3)
        self.leftContentView.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.3)
        self.rightContentView.backgroundColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.3)
        self.energyStackView.backgroundColor = UIColor(red: 165/255, green: 42/255, blue: 42/255, alpha: 0.5)
        
        // corner radius
        self.topContentView.layer.cornerRadius = CommonUtils.commonRadius
        self.leftContentView.layer.cornerRadius = CommonUtils.commonRadius
        self.rightContentView.layer.cornerRadius = CommonUtils.commonRadius
        self.energyStackView.layer.cornerRadius = CommonUtils.commonRadius
        
        self.topContentView.alpha = 0
        self.leftContentView.alpha = 0
        self.rightContentView.alpha = 0
        
        self.energyStackView.isLayoutMarginsRelativeArrangement = true
        self.energyStackView.layoutMargins = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
    }
    
    private func showMenu() {
        
        let duration = 0.5
        
        UIView.animate(withDuration: duration,
            delay: 0.0,
            options: UIView.AnimationOptions.curveEaseInOut,
            animations: {
                self.topContentView.alpha = 1
            },
            
            completion: { finished in
                UIView.animate(withDuration: duration,
                    delay: 0.0,
                    options: UIView.AnimationOptions.curveEaseInOut,
                    animations: {
                        self.leftContentView.alpha = 1
                    },
                    
                    completion: { finished in
                        UIView.animate(withDuration: duration,
                            delay: 0.0,
                            options: UIView.AnimationOptions.curveEaseInOut,
                            animations: {
                                self.rightContentView.alpha = 1
                            },
                            
                            completion: { finished in
                            }
                        )
                    }
                )
            }
        )
    }
    
    private func hideMenu(completion: @escaping () -> ()) {
        
        let duration = 0.3
        
        UIView.animate(withDuration: duration,
            delay: 0.0,
            options: UIView.AnimationOptions.curveEaseInOut,
            animations: {
                self.topContentView.alpha = 0
                self.leftContentView.alpha = 0
                self.rightContentView.alpha = 0
            },
            
            completion: { finished in
                completion()
            }
        )
    }
    
    private func submitButtonAction() {
        
        self.topContentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (startGameAction)))
        self.energyStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (addEnergyAction)))
        self.leftContentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (leisureModeAction)))
        self.rightContentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (achievementAction)))
        
        self.musicImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(musicAction)))
    }
    
    private func setVersionLabel() {
        let appVersion1 = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let appVersion2 = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        self.versionLabel.text = "\(appVersion1 ?? ""), \(appVersion2 ?? "")"
    }
    
    private func refreshEnergy() {
        
        let (energy, timestamp) = Energy.calcEnergy()
        
        self.energyLabel.text = "\(energy) / \(Energy.Max)"
        self.energyTimestamp = timestamp
        
        // 若能量為滿, 不需顯示+能量按鈕
        if energy >= Energy.Max {
            self.energyStackView.isUserInteractionEnabled = false
            self.lightImage.isHidden = false
            self.energyPlusImage.isHidden = true
        } else {
            self.energyStackView.isUserInteractionEnabled = true
            self.lightImage.isHidden = true
            self.energyPlusImage.isHidden = false
        }
        
        self.energyTimer?.invalidate()
        
        // 執行一次
        self.energyClock()
        
        if let _ = self.energyTimestamp {
            self.energyTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(energyClock), userInfo: nil, repeats: true)
        }
    }
    
    private func setMusic() {
        
        let musicName = "Greenery"
        
        // 設定背景音樂
        backgroundMusicPlayer = AVQueuePlayer()
        let item = AVPlayerItem(url: Bundle.main.url(forResource: musicName, withExtension: "mp3")!)
        backgroundMusicLooper = AVPlayerLooper(player: backgroundMusicPlayer!, templateItem: item)
        backgroundMusicPlayer?.volume = 0.8
        backgroundMusicPlayer?.play()
        
        // 應用音樂狀態
        self.implementMusicStatus()
    }
    
    private func implementMusicStatus() {
        
        let musicStatus = UserDefaultUtils.getMusicStatus()
        if musicStatus {
            // 開播
            self.backgroundMusicPlayer?.play()
            self.musicImage.image = UIImage(named: "volume")
        } else {
            // 暫停
            self.backgroundMusicPlayer?.pause()
            self.musicImage.image = UIImage(named: "mute")
        }
    }
}

extension HomeVC {
    
    @objc private func dotClock() {
        
        // 計算下一步路徑
        self.backgroundPanel?.calcStatus()
        
        // 畫出來
        self.drawStatus()
        
        // 計算
        let valueColorArray = self.backgroundPanel?.calcScoreBoard()
        
        // 判斷第一名是否為黑色
        self.identifyBlackWin(valueColorArray: valueColorArray)
    }
    
    @objc private func energyClock() {
        
        guard let timestamp = self.energyTimestamp else {
            self.energyCDLabel.text = "(00:00:00)"
            return
        }
        
        // 取得差額後顯示
        let nowTS = CommonUtils.convertDate2Int(date: Date())
        let targetTimestamp = timestamp + Energy.CD
        
        let targetDate = CommonUtils.convertDatetime2Date(datetime: targetTimestamp)
        let components = CommonUtils.getComponentsBetweenNow(toDate: targetDate)
        self.energyCDLabel.text = "(\(CommonUtils.convertComponents2String(components: components)))"
        
        if targetTimestamp - nowTS <= 0 {
            self.refreshEnergy()
        }
        
    }
    
    private func identifyBlackWin(valueColorArray: [Dictionary<String, Any>]?) {
        
        if self.isAddedWinnerAchievement {
            return
        }
        
        guard let valueColorArray = valueColorArray else {
            return
        }
        
        // 若陣列不等於1, 表示有多個顏色或無顏色, 不動作
        if valueColorArray.count != 1 {
            return
        }
        
        // 一場只加一次
        self.isAddedWinnerAchievement = true
        
        // 單一顏色, 增加勝利者成就
        let color = valueColorArray[0]["color"] as? UIColor ?? .darkGray
        // 若最高分是黑色, 額外增加成就
        if color == .black {
            AchievementUtils.addAchievement(by: .HomeBlackWin)
        }
        
        // 增加成就
        AchievementUtils.addAchievement(by: .HomeHaveWinner)
    }
    
    private func drawStatus() {
        
        // 移除點點
        self.backgroundPanel?.removeDotFromView(parentView: self.contentView)
        
        // 放置點點
        self.backgroundPanel?.pushDot2View(parentView: self.contentView)
    }
    
    private func checkVersion() {
        
        // 若前面有提示視窗就不需跳新版本提示(會自動擋掉, 所以直接顯示)
        ValidationUtils.checkVersionProcess { appDataErrorType, version, releaseNotes in
            
            switch appDataErrorType {
            
            case .isNewVersion:
                return
            case .haveNewVersion:
                AnalyticsUtils.sendEvent(type: .version_have_new)
                break
            case .urlError:
                AnalyticsUtils.sendEvent(type: .version_url_error)
                return
            case .urlGetDataError:
                AnalyticsUtils.sendEvent(type: .version_url_get_data_error)
                return
            case .convertJsonError:
                AnalyticsUtils.sendEvent(type: .version_convert_json_error)
                return
            case .resultsFieldError:
                AnalyticsUtils.sendEvent(type: .version_results_field_error)
                return
            case .resultsArrayCountError:
                AnalyticsUtils.sendEvent(type: .version_results_array_count_error)
                return
            case .versionFieldError:
                AnalyticsUtils.sendEvent(type: .version_version_field_error)
                return
            case .releaseNotesFieldError:
                AnalyticsUtils.sendEvent(type: .version_release_notes_field_error)
                return
            case .localVersionNumError:
                AnalyticsUtils.sendEvent(type: .version_local_version_num_error)
                return
            }
            
            guard let version = version, var releaseNotes = releaseNotes else {
                return
            }
            
            if releaseNotes.count > 100 {
                releaseNotes = "\(releaseNotes.substring(to: 100))...\(NSLocalizedString("Home.VersionSeeMore", comment: ""))"
            }
            
            let alert = UIAlertController(title: String.localizedStringWithFormat(NSLocalizedString("Home.VersionIsRelease", comment: ""), version), message: releaseNotes, preferredStyle: .alert)
            let updateAction = UIAlertAction(title: NSLocalizedString("Home.VersionRenewNow", comment: ""), style: .default) { _ in
                
                AnalyticsUtils.sendEvent(type: .version_choose_update)
                
                if let url = URL(string: "itms-apps://apple.com/app/id\(CommonUtils.appID)") {
                    UIApplication.shared.open(url)
                }
            }

            let cancelAction = UIAlertAction(title: NSLocalizedString("Home.VersionRenewWait", comment: ""), style: .cancel) { _ in
                AnalyticsUtils.sendEvent(type: .version_choose_dont_update)
            }

            alert.addAction(cancelAction)
            alert.addAction(updateAction)

            self.present(alert, animated: true)
        }
        
    }
    
    @objc private func startGameAction() {
        
        ImpactFeedbackUtils.shake(type: .light)
        
        AnalyticsUtils.sendEvent(type: .home_game)
        
        if !Energy.isEnergyEnough() {
            AlertUtils.showAlert(parentView: self.view, text: NSLocalizedString("Home.EnergyNotEnough", comment: ""))
            
            AnalyticsUtils.sendEvent(type: .home_energy_isnt_enough)
            
            // 增加成就
            AchievementUtils.addAchievement(by: .EnergyNotEnough)
            return
        }
        
        // 先決定是否本局無限
        let infiniteRound = Int.random(in: 0..<100) < 5 ? true : false
        
        // 擲骰子, 得出本局分數
        let targetScore = infiniteRound ? 0 : Int.random(in: 1000...10000)
        
        // 提示文字
        let alertTitle = targetScore == 0 ? NSLocalizedString("Home.NoneMission", comment: "") : String.localizedStringWithFormat(NSLocalizedString("Home.BlackMission", comment: ""), targetScore)
        
        // 跳出確認視窗
        let alert = UIAlertController(title: "\(NSLocalizedString("Home.WinCondition", comment: ""))\(alertTitle)", message: "", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: NSLocalizedString("Home.GameStart", comment: ""), style: .default) { [weak self] _ in
            guard let self = self else {
                return
            }
            
            AnalyticsUtils.sendEvent(type: .home_game_confirm)
            
            Energy.useEnergy()
            self.refreshEnergy()
            
            self.dotTimer?.invalidate()
            
            // 移除點點
            self.backgroundPanel?.removeDotFromView(parentView: self.contentView)
            
            // 增加成就
            AchievementUtils.addAchievement(by: .GamePlay)
            
            // 判斷無限局成就
            if targetScore == 0 {
                AchievementUtils.addAchievement(by: .PlayHugeGame)
            }
            
            self.hideMenu { [weak self] in
                guard let self = self else {
                    return
                }
                
                let controller = GameVC(nibName: "GameVC", bundle: Bundle(for: Self.self))
                controller.modalPresentationStyle = .fullScreen
                controller.targetScore = targetScore
                self.present(controller, animated: false)
            }
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Home.GameCancel", comment: ""), style: .cancel) { _ in
            
            AnalyticsUtils.sendEvent(type: .home_game_cancel)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        
        self.present(alert, animated: true)
    }
    
    @objc private func addEnergyAction() {
        
        ImpactFeedbackUtils.shake(type: .light)
        
        AnalyticsUtils.sendEvent(type: .home_add_energy)
        
        guard let ad = rewardedAd else {
            
            AnalyticsUtils.sendEvent(type: .ad_load_failed)
            
            AlertUtils.showAlert(vc: self, errorString: NSLocalizedString("Home.ADIsntOK", comment: ""))
            return
        }
        
        // 看廣告
        let alert = UIAlertController(title: NSLocalizedString("Home.ADWillGet1Energy", comment: ""), message: "", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: NSLocalizedString("Home.ADOK", comment: ""), style: .default) { [weak self] _ in
            guard let self = self else {
                return
            }
            
            self.dotTimer?.invalidate()
            
            self.hideMenu { [weak self] in
                guard let self = self else {
                    return
                }
                
                ad.present(fromRootViewController: self) {
                    
                    AnalyticsUtils.sendEvent(type: .ad_watch_success)
                    
                    self.goodBoy2Watch = true
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Home.ADCancel", comment: ""), style: .cancel) { _ in
            AnalyticsUtils.sendEvent(type: .ad_cancel)
        }
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        self.present(alert, animated: true)
    }
    
    @objc private func leisureModeAction() {
        
        ImpactFeedbackUtils.shake(type: .light)
        
        AnalyticsUtils.sendEvent(type: .home_leisure)
        
        // 跳出確認視窗
        let alert = UIAlertController(title: NSLocalizedString("Home.PleaseChooseMode", comment: ""), message: "", preferredStyle: .alert)
        let conwaysAction = UIAlertAction(title: NSLocalizedString("Home.ChooseConways", comment: ""), style: .default) { [weak self] _ in
            guard let self = self else {
                return
            }
            
            AnalyticsUtils.sendEvent(type: .home_leisure_conways)
            
            self.dotTimer?.invalidate()
            
            // 移除點點
            self.backgroundPanel?.removeDotFromView(parentView: self.contentView)
            
            self.hideMenu { [weak self] in
                guard let self = self else {
                    return
                }
                
                let controller = ConwaysVC(nibName: "ConwaysVC", bundle: Bundle(for: Self.self))
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: false)
            }
        }
        
        let langtonsAction = UIAlertAction(title: NSLocalizedString("Home.ChooseLangtons", comment: ""), style: .default) { [weak self] _ in
            guard let self = self else {
                return
            }

            AnalyticsUtils.sendEvent(type: .home_leisure_langtons)

            self.dotTimer?.invalidate()

            // 移除點點
            self.backgroundPanel?.removeDotFromView(parentView: self.contentView)

            self.hideMenu { [weak self] in
                guard let self = self else {
                    return
                }

                let controller = LangtonsVC(nibName: "LangtonsVC", bundle: Bundle(for: Self.self))
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: false)
            }
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Home.ChooseCancel", comment: ""), style: .cancel) { _ in
            
            AnalyticsUtils.sendEvent(type: .home_leisure_cancel)
        }
        
        alert.addAction(conwaysAction)
        alert.addAction(langtonsAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    @objc private func achievementAction() {
        
        ImpactFeedbackUtils.shake(type: .light)
        
        AnalyticsUtils.sendEvent(type: .home_achievement)
        
        let controller = AchievementVC(nibName: "AchievementVC", bundle: Bundle(for: Self.self))
        controller.modalPresentationStyle = .overFullScreen
        self.present(controller, animated: false)
    }
    
    @objc private func musicAction() {
        
        ImpactFeedbackUtils.shake(type: .light)
        
        let musicStatus = UserDefaultUtils.getMusicStatus()
        UserDefaultUtils.setMusicStatus(musicStatus: !musicStatus)
        
        if musicStatus {
            AnalyticsUtils.sendEvent(type: .home_setting_music_close)
        } else {
            AnalyticsUtils.sendEvent(type: .home_setting_music_open)
        }
        
        self.implementMusicStatus()
    }
    
    private func createAndLoadRewardedAd() {
        GADRewardedAd.load(
            withAdUnitID: self.adPointUID,
            request: GADRequest()
        ) { ad, error in
            if let error = error {
                print("Rewarded ad failed to load with error: \(error.localizedDescription)")
                
                AnalyticsUtils.sendEvent(type: .ad_load_failed)
                
                self.rewardedAd = nil
                return
            }
            
            AnalyticsUtils.sendEvent(type: .ad_load_success)
            
            self.rewardedAd = ad
            self.rewardedAd?.fullScreenContentDelegate = self
        }
    }
    
    private func getADReward() {
        
        // +1能量
        Energy.addEnergy()
        
        // 更新能量
        self.refreshEnergy()
        
        AlertUtils.showAlert(vc: self, errorString: NSLocalizedString("Home.ADSuccessWatch", comment: ""), message: NSLocalizedString("Home.ADGet1Energy", comment: ""))
    }
}

// 廣告
extension HomeVC: GADFullScreenContentDelegate {
    
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        // do nothing
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        // 刷新廣告object
        self.createAndLoadRewardedAd()
        
        // 有乖乖看完則領獎
        if goodBoy2Watch {
            self.getADReward()
        }
        
        self.goodBoy2Watch = false
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        AlertUtils.showAlert(vc: self, errorString: NSLocalizedString("Home.ADLoadFailed", comment: ""))
    }
}
