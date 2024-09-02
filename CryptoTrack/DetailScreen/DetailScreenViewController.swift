//
//  DetailScreenViewController.swift
//  CryptoTrack
//
//  Created by Kim on 02.09.2024.
//

import UIKit
import Charts

class DetailScreenViewController: UIViewController, ChartViewDelegate {
    
    var dataBase = CryptocurrencyRate(prices: [])
    var cellDataForChart = BarChartData()
    var averageValue: Double = 0.0
    var highestValue: Int = 0
    var lowestValue: Int = 0
    var currencyRate: Double = 0.0
    var currencyName: String = ""
    var dailySummary: Double = 0.0
    var dynamicSummary: Double = 0.0
    var marketCap: Int = 0
    
    private var popover = CustomPopoverView()

    @IBOutlet weak var centralBarView: BarChartView!
    
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var currencyRateLabel: UILabel!
    @IBOutlet weak var highRateLabel: UILabel!
    @IBOutlet weak var lowRateLabel: UILabel!
    @IBOutlet weak var awgRateLabel: UILabel!
    @IBOutlet weak var marketCapLabel: UILabel!
    @IBOutlet weak var daysCounterLabel: UILabel!
    
    @IBOutlet weak var segmentController: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpLabels()
        initChart()
    }
    
    private func setUp(){
        centralBarView.delegate = self
        centralBarView.isUserInteractionEnabled = true
        
        centralBarView.scaleXEnabled = false
        centralBarView.scaleYEnabled = false
        centralBarView.pinchZoomEnabled = false
        centralBarView.pinchZoomEnabled = false
        centralBarView.doubleTapToZoomEnabled = false
        centralBarView.xAxis.drawLabelsEnabled = false
        
        centralBarView.xAxis.labelPosition = .bottom
        centralBarView.xAxis.drawGridLinesEnabled = false
        centralBarView.leftAxis.drawGridLinesEnabled = true
        centralBarView.rightAxis.enabled = false
        centralBarView.animate(yAxisDuration: 1.0)
    }
    
    private func setUpLabels(){
        currencyRateLabel.text = String(format: "%.2f", currencyRate) + " USD"
        currencyNameLabel.text = String(currencyName)
        highRateLabel.text = String(highestValue) + " USD"
        lowRateLabel.text = String(lowestValue) + " USD"
        awgRateLabel.text = String(Int(averageValue)) + " USD"
        marketCapLabel.text = String(marketCap)
        
    }

    func initChart() {
        
        var entries = [BarChartDataEntry]()
        
        for (index, priceData) in dataBase.prices.enumerated() {
            let price = round(priceData[1])
            entries.append(BarChartDataEntry(x: Double(index), y: price))
        }
        
        let dataSet = BarChartDataSet(entries: entries, label: "TEST")
        
        dataSet.colors = [UIColor.systemGreen]
        dataSet.drawValuesEnabled = false
    
        
        let data = BarChartData(dataSet: dataSet)
        
        centralBarView.data = data
    }
    
        func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight){
            print("Selected value: \(entry.y)")
            guard let barChartView = chartView as? BarChartView else { return }
    
            let xAxisValue = entry.x
            let yAxisValue = entry.y
    
            let transformer = barChartView.getTransformer(forAxis: .left)
            let point = transformer.pixelForValues(x: xAxisValue, y: yAxisValue)
            let convertedPoint = barChartView.convert(point, to: self.view)
    
            let text = "\(entry.y)"
    
            let popoverWith: CGFloat = 100
            let popoverHeight: CGFloat = 50
            let popoverX = convertedPoint.x - popoverWith / 2
            let popoverY = convertedPoint.y - popoverHeight - 8
    
            popover.setup(with: text)
            popover.show(at: CGPoint(x: popoverX, y: popoverY), in: self.view)
        }
        
        func chartValueNothingSelected(_ chartView: ChartViewBase) {
            popover.hide()
        }
    
    

}
