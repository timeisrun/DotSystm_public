//
//  NotificationUtils.swift
//  DotSystem
//
//  Created by ccc on 2022/1/14.
//

import UserNotifications

class NotificationUtils {
    
    struct RemindStruct {
        let title: String
        let subTitle: String
        let second: Int
        let sound: String
        let identifier: String
    }
    
    static func setAchievementNoti(notiAchi: String) {
        let data = RemindStruct(title: NSLocalizedString("Noti.NotiTitle", comment: ""), subTitle: String.localizedStringWithFormat(NSLocalizedString("Noti.AchiTitle", comment: ""), notiAchi), second: 1, sound: "water_drop_01", identifier: notiAchi)
        self.createNotification(data: data)
    }
    
    static func setEnergyRemind(waitSecond: Int) {
        let data = RemindStruct(title: NSLocalizedString("Noti.NotiTitle", comment: ""), subTitle: NSLocalizedString("Noti.EnergyTitle", comment: ""), second: waitSecond, sound: "water_drop_01", identifier: "energy")
        self.createNotification(data: data)
    }
    
    static func clearEnergyRemind() {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["energy"])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["energy"])
    }
    
    static private func createNotification(data: RemindStruct) {
        
        let content = UNMutableNotificationContent()
        content.title = data.title
        content.subtitle = data.subTitle
//        content.body = "body"
        content.badge = 1
        content.sound = UNNotificationSound(named: UNNotificationSoundName("\(data.sound).mp3"))
        
        // 設定攜帶資訊
        content.userInfo = [:]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(data.second), repeats: false)
        
        let request = UNNotificationRequest(identifier: "\(data.identifier)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
//            print("成功建立通知...")
        })
        
    }
}
