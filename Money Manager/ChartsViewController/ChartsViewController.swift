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
    var currencyRate: Int
}

class ChartsViewController: UIViewController, ChartViewDelegate {
    
    var cellDataArray: [CellData] = [
        CellData(typeOfCell: .btc, averageValue: 0.0, highestValue: 0, lowestValue: Int.max, currencyRate: 0),
        CellData(typeOfCell: .eth, averageValue: 0.0, highestValue: 0, lowestValue: Int.max, currencyRate: 0)
    ]
    var hasErrorOccurred = false
    
    private var popover = CustomPopoverView()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         setUp()
        loadData()
    }
    
    private func setUp(){
        collectionView.delaysContentTouches = false

    }
    
    private func loadData(){
        
        let dispatchGroup = DispatchGroup()
        for (index, cellData) in cellDataArray.enumerated() {
            dispatchGroup.enter()
            NetworkManager.shared.getCryptocurrencyRate(cellData.typeOfCell) { [weak self] jsonResponse, error in
                guard let self = self else { return }
                
                if let response = jsonResponse {
                    self.cellDataArray[index].dataBase = response
                    self.initChart(for: &self.cellDataArray[index])
                    
                } else if let error = error {
                    hasErrorOccurred = true
                    print("Error: \(error.localizedDescription)")
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
        
        if let lastPrice = cellData.dataBase.prices.last?[1] {
            cellData.currencyRate = Int(lastPrice)
        }
        
        let dataSet = BarChartDataSet(entries: entries, label: "\(cellData.typeOfCell)")
        dataSet.colors = [UIColor.systemGreen]
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
            cell.averageLabel.text = "$ " + String(Int(cellData.averageValue))
            cell.highestLabel.text = "$ " + String(cellData.highestValue)
            cell.lowestLabel.text = "$ " + String(cellData.lowestValue)
            cell.cryptocurrencyRateLabel.text = "$ " + String(cellData.currencyRate)
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
