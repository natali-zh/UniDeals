//
//  DiscountFormatter.swift
//  CU-Bachelors-Project
//

import SwiftUI

enum DiscountFormatter {
    static func daysLeftText(for endDate: Date) -> String {
        let days = Calendar.current.dateComponents([.day], from: Date(), to: endDate).day ?? 0
        if days < 0 { return "ვადა გასულია" }
        if days == 0 { return "დღეს იწურება" }
        return "\(days) დღე დარჩა"
    }

    static func daysLeftColor(for endDate: Date) -> Color {
        let days = Calendar.current.dateComponents([.day], from: Date(), to: endDate).day ?? 0
        if days < 0 { return .gray500 }
        return days <= 3 ? .red : .green
    }

    static func isUrgent(endDate: Date) -> Bool {
        let days = Calendar.current.dateComponents([.day], from: Date(), to: endDate).day ?? 0
        return days <= 3
    }

    static func isExpired(endDate: Date) -> Bool {
        endDate < Date()
    }

    static func formattedDate(_ date: Date, locale: Locale = Locale(identifier: "ka_GE")) -> String {
        let f = DateFormatter()
        f.dateFormat = "d MMMM, yyyy"
        f.locale = locale
        return f.string(from: date)
    }

    static func distanceText(_ km: Double) -> String {
        String(format: "%.1f კმ", km)
    }
}
