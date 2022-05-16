//
//  UIApplication+Extension.swift
//  DotSystem
//
//  Created by ccc on 2022/1/26.
//

import UIKit

extension UIApplication {
    
    var currentScene: UIWindowScene? {
        connectedScenes
            .first { $0.activationState == .foregroundActive } as? UIWindowScene
    }
    
}
