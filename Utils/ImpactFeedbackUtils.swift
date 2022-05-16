//
//  ImpactFeedbackUtils.swift
//  DotSystem
//
//  Created by ccc on 2022/1/13.
//

import UIKit

class ImpactFeedbackUtils {
    
    static func shake(type: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: type).impactOccurred()
    }
    
}
