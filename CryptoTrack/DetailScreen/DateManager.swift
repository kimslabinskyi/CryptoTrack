//
//  DateManager.swift
//  CryptoTrack
//
//  Created by Kim on 01.04.2025.
//
import Foundation

struct DateManager {
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM"
        return formatter
    }()
    
    func generateDateArray() -> [String] {
        let startDate = calendar.date(byAdding: .day, value: -365, to: Date())!
        let dateArray = (0...365).compactMap { calendar.date(byAdding: .day, value: $0, to: startDate) }
        return dateArray.map { dateFormatter.string(from: $0) }
    }
}



