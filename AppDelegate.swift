//
//  AppDelegate.swift
//  DotSystem
//
//  Created by ccc on 2022/1/10.
//

import UIKit
import Firebase
import AVFoundation
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .default, options: .mixWithOthers)
        
        FirebaseApp.configure()
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        // 螢幕恆亮
        UIApplication.shared.isIdleTimerDisabled = true
        
        // 初始頁面
        self.setInitPage()
        
        // 推播通知
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (_, _) in
            }
        )
        
        // 代理 UNUserNotificationCenterDelegate，這麼做可讓 App 在前景狀態下收到通知
        UNUserNotificationCenter.current().delegate = self
        
        // 重設badge數字
        application.applicationIconBadgeNumber = 0
        
        return true
    }
    
    private func setInitPage() {
        self.window = UIWindow()
        self.window?.rootViewController = HomeVC(nibName: "HomeVC", bundle: Bundle(for: Self.self))
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // 在前景收到通知時所觸發的 function
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .sound, .alert])
    }
}
