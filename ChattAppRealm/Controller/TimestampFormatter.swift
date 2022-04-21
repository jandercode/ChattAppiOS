//
//  DateFormatter.swift
//  ChattAppRealm
//
//  Created by Joanne Yager on 2022-04-21.
//

import Foundation

struct TimestampFormatter {
    
    func formatTimestamp(timestamp: Date) -> String {
        
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: timestamp)

       // print(Calendar.current.isDateInToday(timestamp))
        let currentYear = Calendar.current.component(.year, from: Date())
        let currentMinute = Calendar.current.component(.minute, from: Date())
        
        let isToday = Calendar.current.isDateInToday(timestamp)
        let isYesterday = Calendar.current.isDateInYesterday(timestamp)
        let isThisYear = components.year == currentYear
        let isThisMinute = components.minute == currentMinute
        
        switch true {
        case isThisMinute:
            return "just now"
        case isToday:
            return "\(components.hour ?? Calendar.current.component(.hour, from: Date())):\(components.minute ?? Calendar.current.component(.minute, from: Date()))"
        case isYesterday:
            return "Yesterday"
        case isThisYear:
            return "This year"
        default:
            return "default"
        }
        
        }
}

