//
//  SKStoreReviewController+Extension.swift
//  DotSystem
//
//  Created by ccc on 2022/1/26.
//

import StoreKit

extension SKStoreReviewController {
    
    static func requestReviewCombine() {
        if #available(iOS 14.0, *) {
            if let scene = UIApplication.shared.currentScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        } else if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        }
    }
    
}
