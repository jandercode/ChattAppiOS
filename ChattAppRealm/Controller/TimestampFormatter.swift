//
//  DateFormatter.swift
//  ChattAppRealm
//
//  Created by Joanne Yager on 2022-04-21.
//

import Foundation

struct TimestampFormatter {
    
    func formatChatRowTimestampString(timestamp: Date) -> String {
        
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        let timeString = timeFormatter.string(from: timestamp)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        let dateString = dateFormatter.string(from: timestamp)
        
        let isToday = Calendar.current.isDateInToday(timestamp)
        let isYesterday = Calendar.current.isDateInYesterday(timestamp)
        
        switch true {
        case isToday:
            return timeString
        case isYesterday:
            return "Yesterday"
        default:
            return dateString
        }
    }
    
    func formatMessageRowTimestampString(timestamp: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let string = formatter.string(from: timestamp)
        
        return string
    }
    
    func formatMessagesViewDateString(timestamp: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        let dateString = dateFormatter.string(from: timestamp)
        
        let isToday = Calendar.current.isDateInToday(timestamp)
        let isYesterday = Calendar.current.isDateInYesterday(timestamp)
        
        switch true {
        case isToday:
            return "Today"
        case isYesterday:
            return "Yesterday"
        default:
            return dateString
        }
    }
}

