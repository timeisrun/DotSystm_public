//
//  CommonUtils.swift
//  DotSystem
//
//  Created by ccc on 2022/1/13.
//

import UIKit
import Foundation

class CommonUtils {
    
    static let calendar = Calendar.current
    
    static let appID = "xxxxxxxxx"
    
    static let commonRadius = 10.0
    
    static let validColor: [UIColor] = [.black, .gray, .red, .orange, .yellow, .green, .blue, .purple]
    
    static func getColorString(color: UIColor) -> String {
        
        let returnString: String
        
        switch color {
        case .black:
            returnString = NSLocalizedString("Common.black", comment: "")
        case .gray:
            returnString = NSLocalizedString("Common.gray", comment: "")
        case .red:
            returnString = NSLocalizedString("Common.red", comment: "")
        case .orange:
            returnString = NSLocalizedString("Common.orange", comment: "")
        case .yellow:
            returnString = NSLocalizedString("Common.yellow", comment: "")
        case .green:
            returnString = NSLocalizedString("Common.green", comment: "")
        case .blue:
            returnString = NSLocalizedString("Common.blue", comment: "")
        case .purple:
            returnString = NSLocalizedString("Common.purple", comment: "")
        default:
            returnString = NSLocalizedString("Common.unknown", comment: "")
        }
        
        return returnString
    }
    
    static func convertDate2Int(date: Date) -> Int {
        return Int(date.timeIntervalSince1970)
    }
    
    static func convertDatetime2Date(datetime: Int) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(datetime))
    }
    
    static func getComponents4Int(datetime: Int) -> DateComponents {
        let nowDate = Date()
        let nowTimestamp = self.convertDate2Int(date: nowDate)
        let newDate = self.convertDatetime2Date(datetime: nowTimestamp + datetime)
        return self.calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: nowDate, to: newDate)
    }
    
    static func getComponentsBetweenNow(toDate: Date) -> DateComponents {
        return self.calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date(), to: toDate)
    }
    
    static func convertComponents2String(components: DateComponents) -> String {
        var hour = components.hour ?? 0
        var minute = components.minute ?? 0
        var second = components.second ?? 0
        hour = hour < 0 ? 0 : hour
        minute = minute < 0 ? 0 : minute
        second = second < 0 ? 0 : second
        
        return "\(self.setZero4OneNumber(tmpValue: hour)):\(self.setZero4OneNumber(tmpValue: minute)):\(self.setZero4OneNumber(tmpValue: second))"
    }
    
    static func convertComponents2LongString(components: DateComponents) -> String {
        
        var finalString = ""
        if let year = components.year, year != 0 {
            finalString += "\(year)Y "
        }
        if let month = components.month, month != 0 {
            finalString += "\(month)M "
        }
        if let day = components.day, day != 0 {
            finalString += "\(day)D "
        }
        if let hour = components.hour, hour != 0 {
            finalString += "\(hour)H "
        }
        if let minute = components.minute, minute != 0 {
            finalString += "\(minute)m "
        }
        if let second = components.second, second != 0 {
            finalString += "\(second)s "
        }
        
        // 若finalString為空則顯示 剛剛
        if finalString.isWhiteSpace() {
            return "0s"
        } else {
            return finalString
        }
        
    }
    
    // 將數字為個位數時, 補零
    static func setZero4OneNumber(tmpValue: Int) -> String {
        if tmpValue > 9 {
            return "\(tmpValue)"
        }
        
        return "0\(tmpValue)"
    }
    
}
