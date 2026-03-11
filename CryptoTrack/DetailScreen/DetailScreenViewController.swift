//
//  DetailScreenViewController.swift
//  CryptoTrack
//
//  Created by Kim on 02.09.2024.
//

import UIKit
import DGCharts


class DetailScreenViewController: UIViewController, ChartViewDelegate {
    @IBOutlet weak var centralBarView: BarChartView!
    
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var currencyRateLabel: UILabel!
    @IBOutlet weak var highRateLabel: UILabel!
    @IBOutlet weak var lowRateLabel: UILabel!
    @IBOutlet weak var avgRateLabel: UILabel!
    @IBOutlet weak var dynamicDaysLabel: UILabel!
    
    @IBOutlet weak var dailySummaryLabel: UILabel!
    @IBOutlet weak var dynamicSummaryLabel: UILabel!
    @IBOutlet weak var dailyCountLabel: UILabel!
    @IBOutlet weak var dynamicCountLabel: UILabel!
    
    @IBOutlet weak var dailyView: UIView!
    @IBOutlet weak var dynamicView: UIView!
    @IBOutlet weak var downView: UIView!
    
    @IBOutlet weak var segmentController: UISegmentedControl!
    
    var cellDataArray = GlobalData.cellDataArray
    var stringDateArray: [String] = []
    var indexPath: IndexPath?
    var dynamicSummary: Double = 0.0
    var dynamicSummaryCount: Double = 0.0
    var rowIndex: Int {
        return indexPath?.row ?? 0
    }
    
    private var popover = CustomPopoverView()
    private let generator = UIImpactFeedbackGenerator(style: .soft)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpLabels()
        initChart(daysCount: 31)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "selectFromDetail" {
//            let destinationVC = segue.destination as! ChangeCurrencyViewController
//            destinationVC.
//            
//            
//            let shortCurrencyName = cellDataArray[rowIndex].currencyName.dropLast(5)
//            destinationVC.selectedCurrenciesList = ["\(shortCurrencyName)"]
//        }
//    }
    
    private func setUp(){
        centralBarView.delegate = self
        centralBarView.isUserInteractionEnabled = true
        
        centralBarView.scaleYEnabled = false
        centralBarView.pinchZoomEnabled = false
        centralBarView.doubleTapToZoomEnabled = false
        
        centralBarView.xAxis.labelPosition = .bottom
        centralBarView.leftAxis.drawGridLinesEnabled = true
        centralBarView.rightAxis.enabled = false
        centralBarView.legend.enabled = false 
        
        let dateManager = DateManager()
        stringDateArray = dateManager.generateDateArray()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutsideChart(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setUpLabels(){
        currencyRateLabel.text = String(format: "%.2f", cellDataArray[rowIndex].currencyRate) + " USD"
        currencyNameLabel.text = cellDataArray[rowIndex].currencyName
        
        if cellDataArray[rowIndex].dailySummary < 0 {
            dailySummaryLabel.text = "\(String(format: "%.2f", cellDataArray[rowIndex].dailySummary * -1)) %"
            dailyCountLabel.text = "\(String(format: "%.2f", cellDataArray[rowIndex].dailySummaryCount * -1))"
            dailyView.backgroundColor = UIColor.systemRed
        } else {
            dailySummaryLabel.text = "\(String(format: "%.2f", cellDataArray[rowIndex].dailySummary)) %"
            dailyCountLabel.text = "\(String(format: "%.2f", cellDataArray[rowIndex].dailySummaryCount))"
            dailyView.backgroundColor = UIColor.systemGreen
        }
        
        countLabelsValue(daysCount: 31)
        dailyView.layer.cornerRadius = 15
        dailyView.layer.masksToBounds = true
        dynamicView.layer.cornerRadius = 15
        dynamicView.layer.masksToBounds = true
        downView.layer.cornerRadius = 15
        
        countDynamicSummary(daysCount: 31)
        segmentController.selectedSegmentIndex = 1
        
    }
    
    private func doHapticFeedback(){
        if SettingsViewController.isHapticFeedbackEnabled == true {
            generator.impactOccurred()
        }
    }
    
    private func initChart(daysCount: Int) {
        var entries = [BarChartDataEntry]()
        var filteredEntries = [BarChartDataEntry]()
        
        for (index, priceData) in cellDataArray[rowIndex].dataBase.prices.enumerated() {
            let price = priceData[1]
            print("price = \(price)")
            entries.append(BarChartDataEntry(x: Double(index), y: price))
            filteredEntries = Array(entries.suffix(daysCount))
        }
        
        let dataSet = BarChartDataSet(entries: filteredEntries, label: cellDataArray[rowIndex].currencyName)
        
        if cellDataArray[rowIndex].dailySummary < 0 {
            dataSet.colors = [UIColor.systemRed]
        } else {
            dataSet.colors = [UIColor.systemGreen]
        }
        
        dataSet.drawValuesEnabled = false
        
        
        let data = BarChartData(dataSet: dataSet)
        centralBarView.data = data
        
        
        let xAxis = self.centralBarView.xAxis
        xAxis.valueFormatter = CustomXAxisFormatter(labels: stringDateArray)
        xAxis.granularity = 1
        xAxis.labelPosition = .bottom
        
        self.centralBarView.notifyDataSetChanged()
    }
    
    private func countDynamicSummary(daysCount: Int) {
        guard let lastElement = cellDataArray[rowIndex].dataBase.prices.last?[1]
        else { return }
        guard let dynamicFirstElement = cellDataArray[rowIndex].dataBase.prices.suffix(daysCount).first?[1]
        else { return }
        
        let dynamicDifference = lastElement - dynamicFirstElement
        let dynamicSummary = dynamicDifference/dynamicFirstElement * 100
        
        if dynamicSummary < 0 {
            dynamicSummaryLabel.text = " \(String(format: "%.2f", dynamicSummary * -1)) %"
            dynamicCountLabel.text = "\(String(format: "%.2f", dynamicDifference * -1))"
            dynamicView.backgroundColor = .systemRed
        } else {
            dynamicSummaryLabel.text = " \(String(format: "%.2f", dynamicSummary)) %"
            dynamicCountLabel.text = "\(String(format: "%.2f", dynamicDifference))"
            dynamicView.backgroundColor = .systemGreen
        }
    }
    
    private func countLabelsValue(daysCount: Int){
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

    
    @IBAction func segmentSwitched(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        doHapticFeedback()
        
        switch selectedIndex {
        case 0:
            initChart(daysCount: 7)
            countDynamicSummary(daysCount: 7)
            countLabelsValue(daysCount: 7)
            dynamicDaysLabel.text = "7"
            popover.hide()
            centralBarView.highlightValues(nil)
        case 1:
            initChart(daysCount: 31)
            countDynamicSummary(daysCount: 31)
            countLabelsValue(daysCount: 31)
            dynamicDaysLabel.text = "31"
            popover.hide()
            centralBarView.highlightValues(nil)
        case 2:
            initChart(daysCount: 90)
            countDynamicSummary(daysCount: 90)
            countLabelsValue(daysCount: 90)
            dynamicDaysLabel.text = "90"
            popover.hide()
            centralBarView.highlightValues(nil)
        case 3:
            initChart(daysCount: 365)
            countDynamicSummary(daysCount: 365)
            countLabelsValue(daysCount: 365)
            dynamicDaysLabel.text = "365"
            popover.hide()
            centralBarView.highlightValues(nil)
        case 4:
            print("Empty")
            popover.hide()
            centralBarView.highlightValues(nil)
            present(UIAlertController.apiMessage(), animated: true)

        default:
            break
        }
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight){
        doHapticFeedback()
        guard let barChartView = chartView as? BarChartView else { return }
        
        let xAxisValue = entry.x
        let yAxisValue = entry.y
        
        let transformer = barChartView.getTransformer(forAxis: .left)
        let point = transformer.pixelForValues(x: xAxisValue, y: yAxisValue)
        let convertedPoint = barChartView.convert(point, to: self.view)
        
        let popoverWith: CGFloat = 100
        let popoverHeight: CGFloat = 50
        let popoverX = convertedPoint.x - popoverWith / 2
        let popoverY = convertedPoint.y - popoverHeight - 8
    
        let serialNumber = Int(xAxisValue) + 1
        
        popover.setup(date: stringDateArray[serialNumber], text: String(format: "%.2f", yAxisValue) )
        popover.show(at: CGPoint(x: popoverX, y: popoverY), in: self.view)
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        popover.hide()
    }
    
    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        let scrollThreshold: CGFloat = 2.0
        
        if abs(dX) > scrollThreshold || abs(dY) > scrollThreshold {
            popover.hide()
            centralBarView.highlightValues(nil)
        }
        
    }

    func customAlertAction() {
        print("Activate custom alert")
    }
    
    @objc func handleTapOutsideChart(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        
        if !centralBarView.frame.contains(location) {
            popover.hide()
            centralBarView.highlightValues(nil)
        }
        
    }
    
}
