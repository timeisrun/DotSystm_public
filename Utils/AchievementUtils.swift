//
//  AchievementUtils.swift
//  DotSystem
//
//  Created by ccc on 2022/1/19.
//

import UIKit

class AchievementUtils {
    
    /// 資格
    enum Qualifications: CaseIterable {
    }
    
    /// 計數
    enum Cumulates: CaseIterable {
        // 首頁黑色獲勝
        case HomeBlackWin
        case HomeHaveWinner
        
        // 遊戲遊玩
        case GamePlay
        case GameWin
        case GameFailed
        case GamePlayingTimes
        
        // 遊戲顏色勝利
        case GameBlackWin
        case GameGrayWin
        case GameRedWin
        case GameOrangeWin
        case GameYellowWin
        case GameGreenWin
        case GameBlueWin
        case GamePrupleWin
        
        // 遊戲型態
        case FinishSmallGame
        case FinishMidGame
        case FinishLargeGame
        case PlayHugeGame
        
        // 廣告觀看
        case EnergyWatchAd // TODO
        case EnergyNotEnough
        
        // 休閒
        case ConwaysPlayingTimes
        case ConwaysClearDots
        
        case LangtonsPlayingTimes
        case LangtonsTenThousand
    }
    
    static private let AchievementListMap: Dictionary<Cumulates, Dictionary<Int, String>> = [
        .HomeBlackWin: [
            100: NSLocalizedString("Achi.HomeBlackWin_0", comment: ""),
            10: NSLocalizedString("Achi.HomeBlackWin_1", comment: ""),
            3: NSLocalizedString("Achi.HomeBlackWin_2", comment: ""),
            2: NSLocalizedString("Achi.HomeBlackWin_3", comment: ""),
            1: NSLocalizedString("Achi.HomeBlackWin_4", comment: "")
        ],
        .HomeHaveWinner: [
            100: NSLocalizedString("Achi.HomeHaveWinner_0", comment: ""),
            50: NSLocalizedString("Achi.HomeHaveWinner_1", comment: ""),
            20: NSLocalizedString("Achi.HomeHaveWinner_2", comment: ""),
            10: NSLocalizedString("Achi.HomeHaveWinner_3", comment: ""),
            1: NSLocalizedString("Achi.HomeHaveWinner_4", comment: "")
        ],
        .GamePlay: [
            100: NSLocalizedString("Achi.GamePlay_0", comment: ""),
            50: NSLocalizedString("Achi.GamePlay_1", comment: ""),
            20: NSLocalizedString("Achi.GamePlay_2", comment: ""),
            10: NSLocalizedString("Achi.GamePlay_3", comment: ""),
            1: NSLocalizedString("Achi.GamePlay_4", comment: "")
        ],
        .GameWin: [
            100: NSLocalizedString("Achi.GameWin_0", comment: ""),
            50: NSLocalizedString("Achi.GameWin_1", comment: ""),
            20: NSLocalizedString("Achi.GameWin_2", comment: ""),
            10: NSLocalizedString("Achi.GameWin_3", comment: ""),
            1: NSLocalizedString("Achi.GameWin_4", comment: "")
        ],
        .GameFailed: [
            100: NSLocalizedString("Achi.GameFailed_0", comment: ""),
            50: NSLocalizedString("Achi.GameFailed_1", comment: ""),
            20: NSLocalizedString("Achi.GameFailed_2", comment: ""),
            10: NSLocalizedString("Achi.GameFailed_3", comment: ""),
            1: NSLocalizedString("Achi.GameFailed_4", comment: "")
        ],
        .GamePlayingTimes: [
            259200: NSLocalizedString("Achi.GamePlayingTimes_0", comment: ""), // 72 * 3600 3 d
            86400: NSLocalizedString("Achi.GamePlayingTimes_1", comment: ""), // 24 * 3600 1 d
            7200: NSLocalizedString("Achi.GamePlayingTimes_2", comment: ""), // 2 * 3600 2 h
            1800: NSLocalizedString("Achi.GamePlayingTimes_3", comment: ""), // 30 * 60 30 m
            60: NSLocalizedString("Achi.GamePlayingTimes_4", comment: "") // 60 1 m
        ],
        .GameBlackWin: [
            1: NSLocalizedString("Achi.GameBlackWin", comment: "")
        ],
        .GameGrayWin: [
            1: NSLocalizedString("Achi.GameGrayWin", comment: "")
        ],
        .GameRedWin: [
            1: NSLocalizedString("Achi.GameRedWin", comment: "")
        ],
        .GameOrangeWin: [
            1: NSLocalizedString("Achi.GameOrangeWin", comment: "")
        ],
        .GameYellowWin: [
            1: NSLocalizedString("Achi.GameYellowWin", comment: "")
        ],
        .GameGreenWin: [
            1: NSLocalizedString("Achi.GameGreenWin", comment: "")
        ],
        .GameBlueWin: [
            1: NSLocalizedString("Achi.GameBlueWin", comment: "")
        ],
        .GamePrupleWin: [
            1: NSLocalizedString("Achi.GamePrupleWin", comment: "")
        ],
        .FinishSmallGame: [
            1: NSLocalizedString("Achi.FinishSmallGame", comment: "")
        ],
        .FinishMidGame: [
            1: NSLocalizedString("Achi.FinishMidGame", comment: "")
        ],
        .FinishLargeGame: [
            1: NSLocalizedString("Achi.FinishLargeGame", comment: "")
        ],
        .PlayHugeGame: [
            1: NSLocalizedString("Achi.PlayHugeGame", comment: "")
        ],
        .EnergyWatchAd: [
            100: NSLocalizedString("Achi.EnergyWatchAd_0", comment: ""),
            50: NSLocalizedString("Achi.EnergyWatchAd_1", comment: ""),
            20: NSLocalizedString("Achi.EnergyWatchAd_2", comment: ""),
            10: NSLocalizedString("Achi.EnergyWatchAd_3", comment: ""),
            1: NSLocalizedString("Achi.EnergyWatchAd_4", comment: "")
        ],
        .EnergyNotEnough: [
            100: NSLocalizedString("Achi.EnergyNotEnough", comment: "")
        ],
        .ConwaysPlayingTimes: [
            259200: NSLocalizedString("Achi.ConwaysPlayingTimes_0", comment: ""), // 72 * 3600 3 d
            86400: NSLocalizedString("Achi.ConwaysPlayingTimes_1", comment: ""), // 24 * 3600 1 d
            7200: NSLocalizedString("Achi.ConwaysPlayingTimes_2", comment: ""), // 2 * 3600 2 h
            1800: NSLocalizedString("Achi.ConwaysPlayingTimes_3", comment: ""), // 30 * 60 30 m
            60: NSLocalizedString("Achi.ConwaysPlayingTimes_4", comment: "") // 60 1 m
        ],
        .ConwaysClearDots: [
            100: NSLocalizedString("Achi.ConwaysClearDots_0", comment: ""),
            50: NSLocalizedString("Achi.ConwaysClearDots_1", comment: ""),
            20: NSLocalizedString("Achi.ConwaysClearDots_2", comment: ""),
            10: NSLocalizedString("Achi.ConwaysClearDots_3", comment: ""),
            1: NSLocalizedString("Achi.ConwaysClearDots_4", comment: "")
        ],
        .LangtonsPlayingTimes: [
            259200: NSLocalizedString("Achi.LangtonsPlayingTimes_0", comment: ""), // 72 * 3600 3 d
            86400: NSLocalizedString("Achi.LangtonsPlayingTimes_1", comment: ""), // 24 * 3600 1 d
            7200: NSLocalizedString("Achi.LangtonsPlayingTimes_2", comment: ""), // 2 * 3600 2 h
            1800: NSLocalizedString("Achi.LangtonsPlayingTimes_3", comment: ""), // 30 * 60 30 m
            60: NSLocalizedString("Achi.LangtonsPlayingTimes_4", comment: "") // 60 1 m
        ],
        .LangtonsTenThousand: [
            100: NSLocalizedString("Achi.LangtonsTenThousand_0", comment: ""),
            50: NSLocalizedString("Achi.LangtonsTenThousand_1", comment: ""),
            20: NSLocalizedString("Achi.LangtonsTenThousand_2", comment: ""),
            10: NSLocalizedString("Achi.LangtonsTenThousand_3", comment: ""),
            1: NSLocalizedString("Achi.LangtonsTenThousand_4", comment: "")
        ]
    ]
    
    static func addAchievement(by key: Cumulates) {
        let newCount = UserDefaultUtils.addAchievement(by: "\(key.self)")
        
        // 判斷有無新成就達成
        if let notiAchi = self.isAchievementsArrived(by: key, newCount: newCount) {
            NotificationUtils.setAchievementNoti(notiAchi: notiAchi)
        }
    }
    
    static func getAchievement(by key: Cumulates) -> Int {
        return UserDefaultUtils.getAchievement(by: "\(key.self)")
    }
    
    static func getAllAchievements(besideEmpty: Bool = false) -> [Dictionary<String, Any>] {
        
        var returnDict: [Dictionary<String, Any>] = []
        
        let allAchievementsKeyArray = Cumulates.allCases
        for titleKey in allAchievementsKeyArray {
            // 處理資料
            let value = UserDefaultUtils.getAchievement(by: "\(titleKey.self)")
            
            // 若不需要空的
            if besideEmpty && value == 0 {
                continue
            }
            
            let (title, describe) = self.getTitleAndDescribe(titleKey: titleKey, value: value)
            returnDict.append([
                "titleKey": titleKey,
                "title": title,
                "describe": describe,
                "value": value
            ])
        }
        
        return returnDict
    }
    
    private static func getTitleAndDescribe(titleKey: Cumulates, value: Int) -> (String, String) {
        
        var returnTitle: String = ""
        let returnDescribe: String
        
        let dict = self.AchievementListMap[titleKey] ?? [:]
        for (line, title) in dict {
            if value >= line {
                returnTitle = title
                break
            }
        }
        
        switch titleKey {
        case .HomeBlackWin:
            if value < 1 {
                returnDescribe = "？？？？？"
            } else {
                returnDescribe = String.localizedStringWithFormat(NSLocalizedString("Achi.HomeBlackWin.Describe", comment: ""), value)
            }
        case .HomeHaveWinner:
            if value < 1 {
                returnDescribe = "？？？？？"
            } else {
                returnDescribe = String.localizedStringWithFormat(NSLocalizedString("Achi.HomeHaveWinner.Describe", comment: ""), value)
            }
        case .GamePlay:
            if value < 1 {
                returnDescribe = "？？？？？"
            } else {
                returnDescribe = String.localizedStringWithFormat(NSLocalizedString("Achi.GamePlay.Describe", comment: ""), value)
            }
        case .GameWin:
            if value < 1 {
                returnDescribe = "？？？？？"
            } else {
                returnDescribe = String.localizedStringWithFormat(NSLocalizedString("Achi.GameWin.Describe", comment: ""), value)
            }
        case .GameFailed:
            if value < 1 {
                returnDescribe = "？？？？？"
            } else {
                returnDescribe = String.localizedStringWithFormat(NSLocalizedString("Achi.GameFailed.Describe", comment: ""), value)
            }
        case .GamePlayingTimes:
            // 計算時間
            if value < 1 {
                returnDescribe = "？？？？？"
            } else {
                let dateComponents = CommonUtils.getComponents4Int(datetime: value)
                let subdescribe = CommonUtils.convertComponents2LongString(components: dateComponents)
                returnDescribe = String.localizedStringWithFormat(NSLocalizedString("Achi.GamePlayingTimes.Describe", comment: ""), subdescribe)
            }
        case .GameBlackWin:
            if value < 1 {
                returnDescribe = "？？？？？"
            } else {
                returnDescribe = String.localizedStringWithFormat(NSLocalizedString("Achi.GameBlackWin.Describe", comment: ""), value)
            }
        case .GameGrayWin:
            if value < 1 {
                returnDescribe = "？？？？？"
            } else {
                returnDescribe = String.localizedStringWithFormat(NSLocalizedString("Achi.GameGrayWin.Describe", comment: ""), value)
            }
        case .GameRedWin:
            if value < 1 {
                returnDescribe = "？？？？？"
            } else {
                returnDescribe = String.localizedStringWithFormat(NSLocalizedString("Achi.GameRedWin.Describe", comment: ""), value)
            }
        case .GameOrangeWin:
            if value < 1 {
                returnDescribe = "？？？？？"
            } else {
                returnDescribe = String.localizedStringWithFormat(NSLocalizedString("Achi.GameOrangeWin.Describe", comment: ""), value)
            }
        case .GameYellowWin:
            if value < 1 {
                returnDescribe = "？？？？？"
            } else {
                returnDescribe = String.localizedStringWithFormat(NSLocalizedString("Achi.GameYellowWin.Describe", comment: ""), value)
            }
        case .GameGreenWin:
            if value < 1 {
                returnDescribe = "？？？？？"
            } else {
                returnDescribe = String.localizedStringWithFormat(NSLocalizedString("Achi.GameGreenWin.Describe", comment: ""), value)
            }
        case .GameBlueWin:
            if value < 1 {
                returnDescribe = "？？？？？"
            } else {
                returnDescribe = String.localizedStringWithFormat(NSLocalizedString("Achi.GameBlueWin.Describe", comment: ""), value)
            }
        case .GamePrupleWin:
            if value < 1 {
                returnDescribe = "？？？？？"
            } else {
                returnDescribe = String.localizedStringWithFormat(NSLocalizedString("Achi.GamePrupleWin.Describe", comment: ""), value)
            }
        case .FinishSmallGame:
            if value < 1 {
                returnDescribe = "？？？？？"
            } else {
                returnDescribe = String.localizedStringWithFormat(NSLocalizedString("Achi.FinishSmallGame.Describe", comment: ""), value)
            }
        case .FinishMidGame:
            if value < 1 {
                returnDescribe = "？？？？？"
            } else {
                returnDescribe = String.localizedStringWithFormat(NSLocalizedString("Achi.FinishMidGame.Describe", comment: ""), value)
            }
        case .FinishLargeGame:
            if value < 1 {
                returnDescribe = "？？？？？"
            } else {
                returnDescribe = String.localizedStringWithFormat(NSLocalizedString("Achi.FinishLargeGame.Describe", comment: ""), value)
            }
        case .PlayHugeGame:
            if value < 1 {
                returnDescribe = "？？？？？"
            } else {
                returnDescribe = String.localizedStringWithFormat(NSLocalizedString("Achi.PlayHugeGame.Describe", comment: ""), value)
            }
        case .EnergyWatchAd:
            if value < 1 {
                returnDescribe = "？？？？？"
            } else {
                returnDescribe = String.localizedStringWithFormat(NSLocalizedString("Achi.EnergyWatchAd.Describe", comment: ""), value)
            }
        case .EnergyNotEnough:
            if value < 100 {
                returnDescribe = "？？？\(value)次"
            } else {
                returnDescribe = String.localizedStringWithFormat(NSLocalizedString("Achi.EnergyNotEnough.Describe", comment: ""), value)
            }
        case .ConwaysPlayingTimes:
            // 計算時間
            if value < 1 {
                returnDescribe = "？？？？？"
            } else {
                let dateComponents = CommonUtils.getComponents4Int(datetime: value)
                let subdescribe = CommonUtils.convertComponents2LongString(components: dateComponents)
                returnDescribe = String.localizedStringWithFormat(NSLocalizedString("Achi.ConwaysPlayingTimes.Describe", comment: ""), subdescribe)
            }
        case .ConwaysClearDots:
            if value < 1 {
                returnDescribe = "？？？？？"
            } else {
                returnDescribe = String.localizedStringWithFormat(NSLocalizedString("Achi.ConwaysClearDots.Describe", comment: ""), value)
            }
        case .LangtonsPlayingTimes:
            // 計算時間
            if value < 1 {
                returnDescribe = "？？？？？"
            } else {
                let dateComponents = CommonUtils.getComponents4Int(datetime: value)
                let subdescribe = CommonUtils.convertComponents2LongString(components: dateComponents)
                returnDescribe = String.localizedStringWithFormat(NSLocalizedString("Achi.LangtonsPlayingTimes.Describe", comment: ""), subdescribe)
            }
        case .LangtonsTenThousand:
            if value < 1 {
                returnDescribe = "？？？？？"
            } else {
                returnDescribe = String.localizedStringWithFormat(NSLocalizedString("Achi.LangtonsTenThousand.Describe", comment: ""), value)
            }
        }
        
        returnTitle = returnTitle == "" ? "？？？" : returnTitle
        
        return (returnTitle, returnDescribe)
    }
    
    static func isAchievementsArrived(by key: Cumulates, newCount: Int) -> String? {
        
        var returnAchi: String? = nil
        
        let dict = self.AchievementListMap[key] ?? [:]
        for (line, title) in dict {
            if newCount == line {
                returnAchi = title
                break
            }
        }
        
        return returnAchi
    }
    
    static func isRangeFunctionValid() -> Bool {
        let count = UserDefaultUtils.getAchievement(by: "\(AchievementUtils.Cumulates.HomeBlackWin.self)")
        return count >= 100
    }
}
