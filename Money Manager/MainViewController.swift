//
//  ViewController.swift
//  Money Manager
//
//  Created by Kim on 02.08.2024.
//

import UIKit
import Charts 

class MainViewController: UIViewController {

    @IBOutlet weak var firstBarChart: BarChartView!
    var cryptocurrenciesDataBase = CryptocurrencyRate(prices: [])
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.shared.getCryptocurrencyRate(Cryptocurrency.eth) { [weak self] jsonResponse, arg in
            guard let self = self else { return }
            
            if let response = jsonResponse {
                self.cryptocurrenciesDataBase = response
                print(response)
                
                initFirstBarChart()
            }
        }
    }
    
    func initFirstBarChart(){
        var entries = [BarChartDataEntry]()
        
        for (index, priceData) in cryptocurrenciesDataBase.prices.enumerated(){
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
    
    


}

