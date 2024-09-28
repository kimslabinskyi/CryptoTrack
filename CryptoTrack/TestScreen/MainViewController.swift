//
//  ViewController.swift
//  Money Manager
//
//  Created by Kim on 02.08.2024.
//

import UIKit
import Charts
import RealmSwift

class ObjectForDataBase: Object{
    
    @Persisted var value: String = ""
    @Persisted var number: Int = 0
    
    convenience init(value: String, number: Int){
        self.init()
        self.value = value
        self.number = number
    }
}

class MainViewController: UIViewController, ChartViewDelegate {

    @IBOutlet weak var firstBarChart: BarChartView!
    @IBOutlet weak var secondBarChart: BarChartView!
    
    var bitcoinDataBase = CryptocurrencyRate(prices: [])
    var ethereumDataBase = CryptocurrencyRate(prices: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    func setUpFirstChart(){
//        NetworkManager.shared.getCryptocurrencyRate(Cryptocurrency.btc) { [weak self] jsonResponse, arg in
//            guard let self = self else { return }
//            
//            if let response = jsonResponse {
//                self.bitcoinDataBase = response
//                print(response)
//                
//                initFirstBarChart()
//                setUpSecondChart()
//            }
//        }
        firstBarChart.delegate = self

        firstBarChart.scaleXEnabled = false
        firstBarChart.scaleYEnabled = false
        firstBarChart.pinchZoomEnabled = false
        firstBarChart.pinchZoomEnabled = false
        firstBarChart.doubleTapToZoomEnabled = false
        firstBarChart.dragEnabled = false
        
        
    }
    
//    func setUpSecondChart(){
//        
//        NetworkManager.shared.getCryptocurrencyRate(CryptoCurrencyType.eth) { [ weak self ] jsonResponse, arg in
//            guard let self = self else { return }
//            
//            if let response = jsonResponse {
//                self.ethereumDataBase = response
//                
//                initSecondBarChart()
//            }
//            
//        }
//        secondBarChart.delegate = self
//        
//        
//    }
    
    func initFirstBarChart(){
        var entries = [BarChartDataEntry]()
        
        for (index, priceData) in bitcoinDataBase.prices.enumerated(){
            let price = round(priceData[1])
            entries.append(BarChartDataEntry(x: Double(index), y: price))
        }
        
        let dataSet = BarChartDataSet(entries: entries, label: "BTC")
        dataSet.colors = [UIColor.blue]
        
        let data = BarChartData(dataSet: dataSet)
        firstBarChart.data = data
        
        firstBarChart.xAxis.labelPosition = .bottom
        firstBarChart.xAxis.drawGridLinesEnabled = false
        firstBarChart.leftAxis.drawGridLinesEnabled = false
        firstBarChart.rightAxis.enabled = false
        firstBarChart.animate(yAxisDuration: 1.0)
    }
    
    func initSecondBarChart(){
        var entries = [BarChartDataEntry]()
        
        for (index, priceData) in ethereumDataBase.prices.enumerated(){
            let price = round(priceData[1])
            entries.append(BarChartDataEntry(x: Double(index), y: price))
        }
        
        let dataSet = BarChartDataSet(entries: entries, label: "Eth")
        dataSet.colors = [UIColor.blue]
        
        let data = BarChartData(dataSet: dataSet)
        secondBarChart.data = data
        
        secondBarChart.xAxis.labelPosition = .bottom
        secondBarChart.xAxis.drawGridLinesEnabled = false
        secondBarChart.leftAxis.drawGridLinesEnabled = false
        secondBarChart.rightAxis.enabled = false
        secondBarChart.animate(yAxisDuration: 1.0)
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight){
        print("Selected value: \(entry.y)")
    }

}

