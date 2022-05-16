//
//  UserDefaultUtils.swift
//  DotSystem
//
//  Created by ccc on 2022/1/13.
//

import Foundation

class UserDefaultUtils {
    
    static let userDefaults = UserDefaults()
    
    static func setEnergy(energy: Int) {
        self.userDefaults.setValue(energy, forKey: "energy")
    }
    
    static func getEnergy() -> Int {
        return self.userDefaults.value(forKey: "energy") as? Int ?? 0
    }
    
    static func setEnergyTimestamp(energyTimestamp: Int) {
        self.userDefaults.setValue(energyTimestamp, forKey: "energyTimestamp")
    }
    
    static func getEnergyTimestamp() -> Int {
        return self.userDefaults.value(forKey: "energyTimestamp") as? Int ?? 0
    }
    
    static func setShowDotRange(showRange: Bool) {
        self.userDefaults.setValue(showRange, forKey: "showRange")
    }
    
    static func getShowDotRange() -> Bool {
        return self.userDefaults.value(forKey: "showRange") as? Bool ?? false
    }
    
    static func addAchievement(by key: String) -> Int {
        var count = self.getAchievement(by: key)
        count += 1
        self.userDefaults.setValue(count, forKey: key)
        
        return count
    }
    
    static func getAchievement(by key: String) -> Int {
        return self.userDefaults.value(forKey: key) as? Int ?? 0
    }
    
    static func setMusicStatus(musicStatus: Bool) {
        self.userDefaults.setValue(musicStatus, forKey: "musicStatus")
    }
    
    static func getMusicStatus() -> Bool {
        return self.userDefaults.value(forKey: "musicStatus") as? Bool ?? true
    }

}
