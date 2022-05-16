//
//  Dot.swift
//  DotSystem
//
//  Created by ccc on 2022/1/10.
//

import UIKit

class Dot {
    
    let baseRange = 20.0
    
    var x: Int
    var y: Int
    var r: Double // 覓食範圍
    var speed: Int
    var color: UIColor
    var weight: Int // 繪點大小
    var value: Double // 權值
    private var flag = true // 是否存在
    
    init(x: Int, y: Int, r: Double? = nil, speed: Int = 1, color: UIColor, weight: Int = 1, value: Double = 1) {
        self.x = x
        self.y = y
        
        if let r = r {
            self.r = r
        } else {
            self.r = self.baseRange
        }
        
        self.speed = speed
        self.color = color
        self.weight = weight
        self.value = value
    }
    
    func isAlive() -> Bool {
        return self.flag
    }
    
    func isDied() -> Bool {
        return !self.flag
    }
    
    func setDied() {
        self.flag = false
    }
    
    func isDirectionValid(width: Int, height: Int, direction: Int) -> Bool {
        
        var isValid = false
        switch direction {
        case Direction.middle:
            isValid = true
        case Direction.UpperLeft:
            if self.x >= 1 && self.y >= 1 {
                isValid = true
            }
        case Direction.Up:
            if self.y >= 1 {
                isValid = true
            }
        case Direction.UpperRight:
            if self.x < width - 1 && self.y >= 1 {
                isValid = true
            }
        case Direction.Right:
            if self.x < width - 1 {
                isValid = true
            }
        case Direction.LowerRight:
            if self.x < width - 1 && self.y < height - 1 {
                isValid = true
            }
        case Direction.Low:
            if self.y < height - 1 {
                isValid = true
            }
        case Direction.LowerLeft:
            if self.x >= 1 && self.y < height - 1 {
                isValid = true
            }
        case Direction.Left:
            if self.x >= 1 {
                isValid = true
            }
        default:
            break
        }
        
        return isValid
    }
    
    func calcFoodRange() {
        self.r = self.baseRange + sqrt(self.value) / 2
    }
    
    func createView(weight: Int) -> UIView {
        
        // 讓點點隨著分數變大
        var factor = pow(self.value, 0.2) / 10
        
        // 但不可以太大
        factor = factor < 5 ? factor : 5
        
        let (objectX, objectY, objectWidth, objectHeight, objectCornerRadius) = self.convertObject(originX: self.x, originY: self.y, originR: 0.5 + factor, weight: weight)
        
        let returnView = UIView(frame: CGRect(x: objectX, y: objectY, width: objectWidth, height: objectHeight))
        returnView.backgroundColor = self.color
        returnView.isUserInteractionEnabled = false
        returnView.layer.cornerRadius = objectCornerRadius
        
        return returnView
    }
    
    func createRangeView(weight: Int) -> UIView {
        
        let (objectX, objectY, objectWidth, objectHeight, objectCornerRadius) = self.convertObject(originX: self.x, originY: self.y, originR: self.r, weight: weight)
        
        let returnView = UIView(frame: CGRect(x: objectX, y: objectY, width: objectWidth, height: objectHeight))
        returnView.backgroundColor = .clear
        returnView.isUserInteractionEnabled = false
        returnView.layer.cornerRadius = objectCornerRadius
        returnView.layer.borderWidth = 1
        returnView.layer.borderColor = self.color.cgColor
        
        return returnView
    }
    
    private func convertObject(originX: Int, originY: Int, originR: Double, weight: Int) -> (Double, Double, Double, Double, Double) {
        
        let doubleWeight = Double(weight)
        
        let objectCornerRadius = originR * doubleWeight
        
        // 計算x, y位置, +半個身位, -半徑
        let objectX = (Double(originX) + 0.5) * doubleWeight - objectCornerRadius
        let objectY = (Double(originY) + 0.5) * doubleWeight - objectCornerRadius
        let objectWidth = objectCornerRadius * 2
        
        return (objectX, objectY, objectWidth, objectWidth, objectCornerRadius)
    }
    
    func gotoDirection(direction: Int, directionDot: Dot?) {
        
        // 如果該方向有食物
        if let directionDot = directionDot {
            // 能吃的食物則吃掉
            if self.value >= directionDot.value {
                // 同顏色直接相加
                if self.color == directionDot.color {
                    self.value += directionDot.value
                } else {
                    // 不同顏色減半
                    self.value += directionDot.value / 2
                }
                
                // value增加重新計算覓食範圍
                self.calcFoodRange()
                
                // 該食物設定鼠掉
                directionDot.setDied()
            } else {
                // 不能吃的食物則原地不動
                return
            }
        }
        
        // 移動過去
        switch direction {
        case 1:
            self.x -= 1
            self.y -= 1
        case 2:
            self.y -= 1
        case 3:
            self.x += 1
            self.y -= 1
        case 4:
            self.x += 1
        case 5:
            self.x += 1
            self.y += 1
        case 6:
            self.y += 1
        case 7:
            self.x -= 1
            self.y += 1
        case 8:
            self.x -= 1
        default:
            break
        }
    }
    
}
