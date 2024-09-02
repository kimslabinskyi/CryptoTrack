//
//  ChartsViewController.swift
//  Money Manager
//
//  Created by Kim on 06.08.2024.
//

import UIKit
import Charts


struct CellData {
    var typeOfCell: CryptoCurrencyType
    var dataBase = CryptocurrencyRate(prices: [])
    var cellDataForChart = BarChartData()
    var averageValue: Double
    var highestValue: Int
    var lowestValue: Int
    var currencyRate: Double
    var currencyName: String
    var dailySummary: Double
    var dynamicSummary: Double
    var marketCap: Int
}

class ChartsViewController: UIViewController, ChartViewDelegate {
    
    var cellDataArray: [CellData] = [
        CellData(typeOfCell: .btc,
                 averageValue: 0.0,
                 highestValue: 0,
                 lowestValue: Int.max,
                 currencyRate: 0,
                 currencyName: "",
                 dailySummary: 0.0,
                 dynamicSummary: 0.0,
                 marketCap: 0),
        
        CellData(typeOfCell: .eth,
                 averageValue: 0.0,
                 highestValue: 0,
                 lowestValue: Int.max,
                 currencyRate: 0,
                 currencyName: "",
                 dailySummary: 0.0,
                 dynamicSummary: 0.0,
                 marketCap: 0)
    ]
    
    var hasErrorOccurred = false
    var selectedIndexPath: IndexPath?
    
    private var popover = CustomPopoverView()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            
            if let indexPath = selectedIndexPath{
                let selectedDataBase = cellDataArray[indexPath.item].dataBase
                let selectedCurrencyRate = cellDataArray[indexPath.item].currencyRate
                let selectedCCurrencyName = cellDataArray[indexPath.item].currencyName
                let selectedAwgValue = cellDataArray[indexPath.item].averageValue
                let selectedHighValue = cellDataArray[indexPath.item].highestValue
                let selectedLowValue = cellDataArray[indexPath.item].lowestValue
                let selectedMarketCap = cellDataArray[indexPath.item].marketCap
                
                if let destinationVC = segue.destination as? DetailScreenViewController {
                    destinationVC.dataBase = selectedDataBase
                    destinationVC.currencyRate = selectedCurrencyRate
                    destinationVC.currencyName = selectedCCurrencyName
                    destinationVC.averageValue = selectedAwgValue
                    destinationVC.highestValue = selectedHighValue
                    destinationVC.lowestValue = selectedLowValue
                    destinationVC.marketCap = selectedMarketCap
                    
                }
            }
        }
    }
    
    private func setUp(){
        collectionView.delaysContentTouches = false
        
    }
    
    private func loadData(){
        
        let dispatchGroup = DispatchGroup()
        for (index, cellData) in cellDataArray.enumerated() {
            dispatchGroup.enter()
            NetworkManager.shared.getCryptocurrencyRate(cellData.typeOfCell) { [weak self] name, jsonResponse, error in
                guard let self = self else { return }
                
                if let name = name {
                    self.cellDataArray[index].currencyName = name
                }
                if let response = jsonResponse {
                    self.cellDataArray[index].dataBase = response
                    self.initChart(for: &self.cellDataArray[index])
                    
                } else if let error = error {
                    hasErrorOccurred = true
                    print("Error: \(error.localizedDescription)")
                }
                
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            NetworkManager.shared.getMarketCap(cellData.typeOfCell) { [weak self] jsonResponse, error in
                guard let self = self else { return }
                
                if let response = jsonResponse {
                    let marketCap = response.usdMarketCap
                    self.cellDataArray[index].marketCap = Int(marketCap)
                    print("MarketCap = \(String(describing: jsonResponse))")
                } else if let error = error {
                    print(error.localizedDescription)
                }
                
                dispatchGroup.leave()
            }
            
            dispatchGroup.notify(queue: .main){
                if self.hasErrorOccurred == false {
                    self.collectionView.reloadData()
                } else {
                    self.showAlert(title: "Error", message: "Filed to load all data from API, please try again later")
                }
            }
        }
        
    }
    
    func initChart(for cellData: inout CellData){
        var entries = [BarChartDataEntry]()
        var sum: Double = 0.0
        var lowestValue: Double = Double.greatestFiniteMagnitude
        var highestValue: Double = 0.0
        
        guard let firstElement = cellData.dataBase.prices.first?[1]
        else { return }
        guard let lastElement = cellData.dataBase.prices.last?[1]
        else { return }
        
        let secondLastElementIndex = cellData.dataBase.prices.count - 2
        guard cellData.dataBase.prices.indices.contains(secondLastElementIndex)
        else { return }
        let secondLastElement = cellData.dataBase.prices[secondLastElementIndex][1]
        
        
        for (index, priceData) in cellData.dataBase.prices.enumerated(){
            
            let price = round(priceData[1])
            entries.append(BarChartDataEntry(x: Double(index), y: price))
            sum += price
            
            if price < lowestValue{
                lowestValue = price
            }
            
            if price > highestValue {
                highestValue = price
            }
        }
        
        cellData.averageValue = sum / Double(cellData.dataBase.prices.count)
        cellData.lowestValue = Int(lowestValue)
        cellData.highestValue = Int(highestValue)
        
        let summaryDifference = lastElement - firstElement
        let dailyDifference = lastElement - secondLastElement
        cellData.dynamicSummary = summaryDifference/firstElement * 100
        cellData.dailySummary = dailyDifference/secondLastElement * 100
        
        if let lastPrice = cellData.dataBase.prices.last?[1] {
            cellData.currencyRate = lastPrice
        }
        
        let dataSet = BarChartDataSet(entries: entries, label: "\(cellData.typeOfCell)")
        
        if cellData.dailySummary < 0 {
            dataSet.colors = [UIColor.systemRed]
        } else if cellData.dailySummary >= 0 {
            dataSet.colors = [UIColor.systemGreen]
        }
        dataSet.drawValuesEnabled = false
        cellData.cellDataForChart = BarChartData(dataSet: dataSet)
        
        collectionView.reloadData()
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
    
    private func showAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
}

extension ChartsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ChartCollectionViewCell
        let cellData = cellDataArray[indexPath.row]
        configureCell(cell, with: cellData)
        
        return cell
    }
    
    private func configureCell(_ cell: ChartCollectionViewCell, with cellData: CellData) {
        let radius: CGFloat = 10
        cell.layer.cornerRadius = radius
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.masksToBounds = true
        cell.centralBarView.delegate = self
        
        if !cellData.cellDataForChart.isEmpty {
            cell.centralBarView.data = cellData.cellDataForChart
            cell.averageLabel.text = String(Int(cellData.averageValue)) + " USD"
            cell.highestLabel.text = String(cellData.highestValue) + " USD"
            cell.lowestLabel.text = String(cellData.lowestValue) + " USD"
            cell.cryptocurrencyRateLabel.text = String(Int(cellData.currencyRate)) + " USD"
            cell.cryptocurrencyNameLabel.text = cellData.currencyName
            cell.marketCapLabel.text = String(cellData.marketCap)
            
            if cellData.dynamicSummary < 0 {
                cell.dynamicSummaryLabel.text = String(format: "%.2f", cellData.dynamicSummary) + " %"
                cell.dynamicSummaryLabel.backgroundColor = UIColor.systemRed
            } else {
                cell.dynamicSummaryLabel.text = "+\(String(format: "%.2f", cellData.dynamicSummary))%"
            }
            
            if cellData.dailySummary < 0 {
                cell.dailySummaryLabel.text = String(format: "%.2f", cellData.dailySummary) + " %"
                cell.dailySummaryLabel.backgroundColor = UIColor.systemRed
            } else {
                cell.dailySummaryLabel.text = "+\(String(format: "%.2f", cellData.dailySummary))%"
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        performSegue(withIdentifier: "showDetail", sender: nil)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            popover.hide()
            for cell in collectionView.visibleCells {
                if let chartCell = cell as? ChartCollectionViewCell {
                    chartCell.deselectElement()
                }
            }
        }
        
    }
    
}


extension ChartsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 340
        let height = 420
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
