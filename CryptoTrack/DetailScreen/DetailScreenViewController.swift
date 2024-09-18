//
//  DetailScreenViewController.swift
//  CryptoTrack
//
//  Created by Kim on 02.09.2024.
//

import UIKit
import Charts



class DetailScreenViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var centralBarView: BarChartView!
    
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var currencyRateLabel: UILabel!
    @IBOutlet weak var highRateLabel: UILabel!
    @IBOutlet weak var lowRateLabel: UILabel!
    @IBOutlet weak var awgRateLabel: UILabel!
    @IBOutlet weak var marketCapLabel: UILabel!
    @IBOutlet weak var daysCounterLabel: UILabel!
    @IBOutlet weak var dailySummaryLabel: UILabel!
    @IBOutlet weak var dynamicSummaryLabel: UILabel!
    
    @IBOutlet weak var segmentController: UISegmentedControl!
    
    var cellDataArray = GlobalData.cellDataArray
    var indexPath: IndexPath?
    var rowIndex: Int {
        return indexPath?.row ?? 0
    }
    
    private var popover = CustomPopoverView()
    private let alertController = AlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpLabels()
        initChart(daysCount: 31)
    }
    
    private func setUp(){
        centralBarView.delegate = self
        centralBarView.isUserInteractionEnabled = true
        
        centralBarView.scaleXEnabled = false
        centralBarView.scaleYEnabled = false
        centralBarView.pinchZoomEnabled = false
        centralBarView.doubleTapToZoomEnabled = false
        centralBarView.xAxis.drawLabelsEnabled = false
        
        centralBarView.xAxis.labelPosition = .bottom
        centralBarView.xAxis.drawGridLinesEnabled = false
        centralBarView.leftAxis.drawGridLinesEnabled = true
        centralBarView.rightAxis.enabled = false
        
       
    }
    
    private func setUpLabels(){
        currencyRateLabel.text = String(format: "%.2f", cellDataArray[rowIndex].currencyRate) + " USD"
        currencyNameLabel.text = cellDataArray[rowIndex].currencyName
        highRateLabel.text = String(format: "%.2f", cellDataArray[rowIndex].highestValue) + " USD"
        lowRateLabel.text = String(format: "%.2f", cellDataArray[rowIndex].lowestValue) + " USD"
        awgRateLabel.text = String(format: "%.2f", cellDataArray[rowIndex].averageValue) + " USD"
        marketCapLabel.text = String(cellDataArray[rowIndex].marketCap)
        
        if cellDataArray[rowIndex].dailySummary < 0 {
            dailySummaryLabel.text = "\(String(format: "%.3f", cellDataArray[rowIndex].dailySummary)) %"
            dailySummaryLabel.backgroundColor = UIColor.systemRed
        } else {
            dailySummaryLabel.text = "+\(String(format: "%.3f", cellDataArray[rowIndex].dailySummary)) %"
            dailySummaryLabel.backgroundColor = UIColor.systemGreen
        }
        
        if cellDataArray[rowIndex].dynamicSummary < 0 {
            dynamicSummaryLabel.text = "\(String(format: "%.3f", cellDataArray[rowIndex].dynamicSummary)) %"
            dynamicSummaryLabel.backgroundColor = UIColor.systemRed
        } else {
            dynamicSummaryLabel.text = "+\(String(format: "%.3f", cellDataArray[rowIndex].dynamicSummary)) %"
            dynamicSummaryLabel.backgroundColor = UIColor.systemGreen
        }
        
        dailySummaryLabel.layer.cornerRadius = 5
        dailySummaryLabel.layer.masksToBounds = true
        dynamicSummaryLabel.layer.cornerRadius = 5
        dynamicSummaryLabel.layer.masksToBounds = true
        
        segmentController.selectedSegmentIndex = 1 
    }
    
    @IBAction func segmentSwitched(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        
        switch selectedIndex {
        case 0:
            initChart(daysCount: 7)
        case 1:
            initChart(daysCount: 31)
        case 2:
            initChart(daysCount: 90)
        case 3:
            initChart(daysCount: 365)
        case 4:
            print("Empty")
        default:
            break
        }
    }
    
    func initChart(daysCount: Int) {
        var entries = [BarChartDataEntry]()
        var testEntries = [BarChartDataEntry]()
        
        for (index, priceData) in cellDataArray[rowIndex].dataBase.prices.enumerated() {
            let price = round(priceData[1])
            entries.append(BarChartDataEntry(x: Double(index), y: price))
            testEntries = Array(entries.suffix(daysCount))
        }
        
        let dataSet = BarChartDataSet(entries: testEntries, label: cellDataArray[rowIndex].currencyName)
        
        if cellDataArray[rowIndex].dailySummary < 0 {
            dataSet.colors = [UIColor.systemRed]
        } else {
            dataSet.colors = [UIColor.systemGreen]
        }
        
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
