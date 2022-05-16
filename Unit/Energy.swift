//
//  Energy.swift
//  DotSystem
//
//  Created by ccc on 2022/1/13.
//

import Foundation

class Energy {
    
    static let Max = 5
    static let CD = 3600
    
    static func calcEnergy() -> (Int, Int?) {
        
        // 確認能量餘額
        let energy = UserDefaultUtils.getEnergy()
        
        // 滿格則
        if energy == self.Max {
            // 滿能量清空推播
            NotificationUtils.clearEnergyRemind()
            
            // 設定時間戳後回傳
            self.setEnergyTimestampNow()
            
            return (self.Max, nil)
        }
        
        // 若未滿則取得上次時間戳與當前時間戳
        let energyTimestamp = UserDefaultUtils.getEnergyTimestamp()
        let nowTimestamp = CommonUtils.convertDate2Int(date: Date())
        
        // 計算時間戳差額為多少份的CD
        let goThroughTimestamp = nowTimestamp - energyTimestamp
        let willAddEnergy = goThroughTimestamp / self.CD
        
        // 若差額小於0表示使用者改時間
        if willAddEnergy < 0 {
            // 清空推播
            NotificationUtils.clearEnergyRemind()
            
            // 回傳原本的能量, 不倒數
            return (energy, nil)
        }
        
        // 計算差額是否補足
        let newEnergy = energy + willAddEnergy
        if newEnergy >= self.Max {
            // 滿能量清空推播
            NotificationUtils.clearEnergyRemind()
            
            // 補足則設定新能量, 新時間戳後回傳
            UserDefaultUtils.setEnergy(energy: self.Max)
            self.setEnergyTimestampNow()
            
            return (self.Max, nil)
        }
        
        // 設定補滿能量通知
        let waitSecond = energyTimestamp + (self.Max - energy) * self.CD - nowTimestamp
        print("waitsecond: \(waitSecond)")
        NotificationUtils.setEnergyRemind(waitSecond: waitSecond)
        
        // 未補足則設定新能量, 新起始時間戳後, 回傳新能量及新起始時間戳
        UserDefaultUtils.setEnergy(energy: newEnergy)
        
        let newTS = energyTimestamp + willAddEnergy * self.CD
        UserDefaultUtils.setEnergyTimestamp(energyTimestamp: newTS)
        
        return (newEnergy, newTS)
    }
    
    static func addEnergy() {
        
        // 確認能量餘額
        let energy = UserDefaultUtils.getEnergy()
        let newEnergy = energy + 1 <= self.Max ? energy + 1 : self.Max
        UserDefaultUtils.setEnergy(energy: newEnergy)
    }
    
    static private func setEnergyTimestampNow() {
        // 比較當前與舊時間戳誰大誰小, 以防有使用者調時間
        let oldTS = UserDefaultUtils.getEnergyTimestamp()
        let nowTS = CommonUtils.convertDate2Int(date: Date())
        
        if nowTS > oldTS {
            UserDefaultUtils.setEnergyTimestamp(energyTimestamp: nowTS)
        }
    }
    
    static func isEnergyEnough() -> Bool {
        return UserDefaultUtils.getEnergy() > 0
    }
    
    static func useEnergy() {
        
        let energy = UserDefaultUtils.getEnergy()
        
        // 若能量為滿, 重設timestamp
        if energy == self.Max {
            self.setEnergyTimestampNow()
        }
        
        if energy > 0 {
            UserDefaultUtils.setEnergy(energy: energy - 1)
        }
        
    }
    
}
