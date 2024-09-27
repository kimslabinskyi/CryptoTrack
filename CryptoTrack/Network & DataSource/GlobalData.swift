//
//  GlobalData.swift
//  CryptoTrack
//
//  Created by Kim on 05.09.2024.
//

import Foundation
import Charts

struct CellData {
    var typeOfCell: CryptoCurrencyType
    var dataBase = CryptocurrencyRate(prices: [])
    var cellDataForChart = BarChartData()
    var averageValue: Double
    var highestValue: Double
    var lowestValue: Double
    var currencyRate: Double
    var currencyName: String
    var dailySummary: Double
    var dynamicSummary: Double
    var marketCap: Int
}

struct GlobalData {
    static var cellDataArray: [CellData] = [

        CellData(typeOfCell: .btc,
                 averageValue: 0.0,
                 highestValue: 0.0,
                 lowestValue: Double.greatestFiniteMagnitude,
                 currencyRate: 0,
                 currencyName: "",
                 dailySummary: 0.0,
                 dynamicSummary: 0.0,
                 marketCap: 0)
        
//        CellData(typeOfCell: .eth,
//                 averageValue: 0.0,
//                 highestValue: 0.0,
//                 lowestValue: Double.greatestFiniteMagnitude,
//                 currencyRate: 0,
//                 currencyName: "",
//                 dailySummary: 0.0,
//                 dynamicSummary: 0.0,
//                 marketCap: 0)
        
//        CellData(typeOfCell: .bnb,
//                 averageValue: 0.0,
//                 highestValue: 0.0,
//                 lowestValue: Double.greatestFiniteMagnitude,
//                 currencyRate: 0,
//                 currencyName: "",
//                 dailySummary: 0.0,
//                 dynamicSummary: 0.0,
//                 marketCap: 0)
        
    ]
    

}
