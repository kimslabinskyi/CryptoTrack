//
//  CustomXAxisFormatter.swift
//  CryptoTrack
//
//  Created by Kim on 31.03.2025.
//
import DGCharts
import ObjectiveC

class CustomXAxisFormatter: NSObject, AxisValueFormatter {
    private let labels: [String]
    
    init(labels: [String]) {
        self.labels = labels
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let index = Int(value)
        guard index >= 0, index < labels.count else { return ""}
        return labels[index]
    }
}
