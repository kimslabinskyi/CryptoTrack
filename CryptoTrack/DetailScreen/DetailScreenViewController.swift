//
//  DetailScreenViewController.swift
//  CryptoTrack
//
//  Created by Kim on 02.09.2024.
//

import UIKit
import Charts



class DetailScreenViewController: UIViewController, ChartViewDelegate, CustomAlertDelegate {
    @IBOutlet weak var centralBarView: BarChartView!
    
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var currencyRateLabel: UILabel!
    @IBOutlet weak var highRateLabel: UILabel!
    @IBOutlet weak var lowRateLabel: UILabel!
    @IBOutlet weak var avgRateLabel: UILabel!
    @IBOutlet weak var marketCapLabel: UILabel!
    @IBOutlet weak var daysCounterLabel: UILabel!
    @IBOutlet weak var dynamicDaysLabel: UILabel!
    @IBOutlet weak var dailySummaryLabel: UILabel!
    @IBOutlet weak var dynamicSummaryLabel: UILabel!
    
    @IBOutlet weak var segmentController: UISegmentedControl!
    
    var cellDataArray = GlobalData.cellDataArray
    var indexPath: IndexPath?
    var dynamicSummary: Double = 0.0
    var rowIndex: Int {
        return indexPath?.row ?? 0
    }
    
    private var popover = CustomPopoverView()
    private let alertController = AlertController()
    private var customAlert: CustomAlertViewController?
    
    
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
        marketCapLabel.text = String(cellDataArray[rowIndex].marketCap)
        
        if cellDataArray[rowIndex].dailySummary < 0 {
            dailySummaryLabel.text = "\(String(format: "%.3f", cellDataArray[rowIndex].dailySummary)) %"
            dailySummaryLabel.backgroundColor = UIColor.systemRed
        } else {
            dailySummaryLabel.text = "+\(String(format: "%.3f", cellDataArray[rowIndex].dailySummary)) %"
            dailySummaryLabel.backgroundColor = UIColor.systemGreen
        }
        
        countLabelsValue(daysCount: 31)
        dailySummaryLabel.layer.cornerRadius = 5
        dailySummaryLabel.layer.masksToBounds = true
        dynamicSummaryLabel.layer.cornerRadius = 5
        dynamicSummaryLabel.layer.masksToBounds = true
        
        countDynamicSummary(daysCount: 31)
        segmentController.selectedSegmentIndex = 1
        
        customAlert = storyboard?.instantiateViewController(withIdentifier: "CustomAlertView") as? CustomAlertViewController
        customAlert?.delegate = self
        customAlert?.modalPresentationStyle = .overCurrentContext
        customAlert?.providesPresentationContextTransitionStyle = true
        customAlert?.definesPresentationContext = true
        customAlert?.modalTransitionStyle = .crossDissolve
    }
    
    @IBAction func segmentSwitched(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        
        switch selectedIndex {
        case 0:
            initChart(daysCount: 7)
            countDynamicSummary(daysCount: 7)
            countLabelsValue(daysCount: 7)
            daysCounterLabel.text = "7"
            dynamicDaysLabel.text = "7"
            popover.hide()
            centralBarView.highlightValues(nil)
        case 1:
            initChart(daysCount: 31)
            countDynamicSummary(daysCount: 31)
            countLabelsValue(daysCount: 31)
            daysCounterLabel.text = "31"
            dynamicDaysLabel.text = "31"
            popover.hide()
            centralBarView.highlightValues(nil)
        case 2:
            initChart(daysCount: 90)
            countDynamicSummary(daysCount: 90)
            countLabelsValue(daysCount: 90)
            daysCounterLabel.text = "90"
            dynamicDaysLabel.text = "90"
            popover.hide()
            centralBarView.highlightValues(nil)
        case 3:
            initChart(daysCount: 365)
            countDynamicSummary(daysCount: 365)
            countLabelsValue(daysCount: 365)
            daysCounterLabel.text = "365"
            dynamicDaysLabel.text = "365"
            popover.hide()
            centralBarView.highlightValues(nil)
        case 4:
            print("Empty")
            popover.hide()
            centralBarView.highlightValues(nil)
            self.present(customAlert!, animated: true, completion: nil)
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
    
    func countDynamicSummary(daysCount: Int) {
        guard let lastElement = cellDataArray[rowIndex].dataBase.prices.last?[1]
        else { return }
        guard let dynamicFirstElement = cellDataArray[rowIndex].dataBase.prices.suffix(daysCount).first?[1]
        else { return }
        
        let dynamicDifference = lastElement - dynamicFirstElement
        let dynamicSummary = dynamicDifference/dynamicFirstElement * 100
        
        if dynamicSummary < 0 {
            dynamicSummaryLabel.text = "\(String(format: "%.3f", dynamicSummary)) %"
            dynamicSummaryLabel.backgroundColor = .systemRed
        } else {
            dynamicSummaryLabel.text = "+\(String(format: "%.3f", dynamicSummary)) %"
            dynamicSummaryLabel.backgroundColor = .systemGreen
        }
    }
    
    func countLabelsValue(daysCount: Int){
        var sum: Double = 0.0
        var lowestValue: Double = Double.greatestFiniteMagnitude
        var highestValue: Double = 0.0
        
        let startIndex = max(0, cellDataArray[rowIndex].dataBase.prices.count - daysCount)
        let selectedArray = cellDataArray[rowIndex].dataBase.prices[startIndex..<cellDataArray[rowIndex].dataBase.prices.count]
    
        for priceData in selectedArray{
            
            let price = priceData[1]
            sum += price
            
            for priceData in selectedArray{
                let price = priceData[1]
                
                if price < lowestValue {
                    lowestValue = price
                }
                
                if price > highestValue {
                    highestValue = price
                }
            }
                        
            }

        avgRateLabel.text = "\(String(format: "%.2f", sum / Double(daysCount))) USD"
        highRateLabel.text = String(format: "%.2f", highestValue) + " USD"
        lowRateLabel.text = String(format: "%.2f", lowestValue) + " USD"
    }

    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight){
        print("Selected value: \(entry.y)")
        guard let barChartView = chartView as? BarChartView else { return }
        
        let xAxisValue = entry.x
        let yAxisValue = entry.y
        
        let transformer = barChartView.getTransformer(forAxis: .left)
        let point = transformer.pixelForValues(x: xAxisValue, y: yAxisValue)
        let convertedPoint = barChartView.convert(point, to: self.view)
        
        let text = "\(Int(entry.y))"
        
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

    func buttonTapped() {
        print("Activate custom alert")
    }
    
}
