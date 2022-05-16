//
//  AlertUtils.swift
//  DotSystem
//
//  Created by ccc on 2022/1/13.
//

import UIKit
import Foundation

class AlertUtils {
    
    static func showAlert(parentView: UIView, text: String) {
        let viewWidth = parentView.bounds.width
        let viewHeight = parentView.bounds.height
        
        let labelWidth = 100.0
        let labelHeight = 50.0
        
        let label = UILabel(frame: CGRect(x: (viewWidth - labelWidth) / 2, y: viewHeight, width: labelWidth, height: labelHeight))
        label.text = text
        label.textAlignment = .center
        label.baselineAdjustment = .alignCenters
        label.layer.cornerRadius = CommonUtils.commonRadius
        label.layer.borderColor = UIColor.gray.cgColor
        label.layer.borderWidth = 1
        label.textColor = .gray
        label.backgroundColor = .clear
        label.alpha = 0
        
        parentView.addSubview(label)
        
        UIView.animate(withDuration: 0.3,
            delay: 0.0,
            options: UIView.AnimationOptions.curveEaseInOut,
            animations: {
                label.frame.origin.y = viewHeight - labelHeight * 2
                label.alpha = 1
            },
            
            completion: { finished in
                UIView.animate(withDuration: 0.15,
                    delay: 3.0,
                    options: UIView.AnimationOptions.curveEaseInOut,
                    animations: {
                        label.frame.origin.y = viewHeight
                        label.alpha = 0
                    },
                    
                    completion: { finished in
                        label.removeFromSuperview()
                    }
                )
            }
        )
    }
    
    // 提示訊息
    static func showAlert(vc: UIViewController, errorString: String, message: String? = "") {
        let alert = UIAlertController(title: errorString, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Alert.OK", comment: ""), style: .cancel))
        vc.present(alert, animated: true)
    }
}
