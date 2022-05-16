//
//  UIView+Extension.swift
//  DotSystem
//
//  Created by ccc on 2022/1/19.
//

import UIKit

extension UIView {
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
}
