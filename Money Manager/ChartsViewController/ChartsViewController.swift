//
//  ChartsViewController.swift
//  Money Manager
//
//  Created by Kim on 06.08.2024.
//

import UIKit
import Charts

#warning("Make this class S - SOLID - Single responsibility - showing chart")


struct ChartData {
    let type: CryptoCurrencyType
    
    var chartData: Dictionary<String, String>
}

class ChartsViewController: UIViewController, ChartViewDelegate {
    #warning("Remake for reusing cells, unify data responses")
    
    var dataBase1 = CryptocurrencyRate(prices: [])
    var dataBase2 = CryptocurrencyRate(prices: [])
    var dataForCell1 = BarChartData()
    var dataForCell2 = BarChartData()
    
    var averageValue1: Double = 0.0
    var highestValue1: Double = 0.0
    var lowestValue1: Double = Double.greatestFiniteMagnitude
    var currencyRate1: Int = 0
    
    var averageValue2: Double = 0.0
    var highestValue2: Double = 0.0
    var lowestValue2: Double = Double.greatestFiniteMagnitude
    var currencyRate2: Int = 0
    
    private var popover = CustomPopoverView()
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        
    }
    
    private func setUp(){
        NetworkManager.shared.getCryptocurrencyRate(CryptoCurrencyType.btc) { [weak self] jsonResponse, arg in
            guard let self = self else { return }
            
            if let response = jsonResponse {
                self.dataBase1 = response
                print(response)
                initFirstChart()
            }
        }
        collectionView.delaysContentTouches = false

    }
    
    
    func setUpSecondChart(){
        NetworkManager.shared.getCryptocurrencyRate(CryptoCurrencyType.eth) { [weak self] jsonResponse, arg in
            guard let self = self else { return }
            
            if let response = jsonResponse {
                self.dataBase2 = response
                initSecondBarChart()
                
            }
        }
    }
    
    
    
    
    func initFirstChart(){
        var entries = [BarChartDataEntry]()
        var sum: Double = 0.0
        
        for (index, priceData) in dataBase1.prices.enumerated(){
           
            let price = round(priceData[1])
            entries.append(BarChartDataEntry(x: Double(index), y: price))
            sum += price
            
            if price < lowestValue1{
                lowestValue1 = price
            }
            
            if price > highestValue1 {
                highestValue1 = price
            }
            
            averageValue1 = Double(sum) / Double(index + 1)
        }
        
        if let lastPrice = dataBase1.prices.last?[1] {
            let intValue = Int(lastPrice)
            currencyRate1 = intValue
        }
        
        let dataSet = BarChartDataSet(entries: entries, label: "BTC")
        dataSet.colors = [UIColor.systemGreen]
        dataSet.drawValuesEnabled = false
        dataForCell1 = BarChartData(dataSet: dataSet)
        
        collectionView.reloadData()
        setUpSecondChart()
    }
    
    func initSecondBarChart(){
        var entries = [BarChartDataEntry]()
        var sum: Double = 0.0
        
        for (index, priceData) in dataBase2.prices.enumerated(){
            let price = round(priceData[1])
            entries.append(BarChartDataEntry(x: Double(index), y: price))
            sum += price
            
            if price < lowestValue2{
                lowestValue2 = price
            }
            
            if price > highestValue2 {
                highestValue2 = price
            }
            
            averageValue2 = Double(sum) / Double(index + 1)
        }
        
        let dataSet = BarChartDataSet(entries: entries, label: "ETH")
        dataSet.colors = [UIColor.red]
        dataSet.drawValuesEnabled = false

        
        dataForCell2 = BarChartData(dataSet: dataSet)
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
  
    
    
}

extension ChartsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ChartCollectionViewCell
        let radius: CGFloat = 10
        cell.layer.cornerRadius = radius
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.masksToBounds = true
        
        cell.centralBarView.delegate = self
        
        cell.centralBarView.scaleXEnabled = false
        cell.centralBarView.scaleYEnabled = false
        cell.centralBarView.pinchZoomEnabled = false
        cell.centralBarView.pinchZoomEnabled = false
        cell.centralBarView.doubleTapToZoomEnabled = false
        cell.centralBarView.dragEnabled = false
        cell.centralBarView.xAxis.drawLabelsEnabled = false

        
        func setUpCell(){
            cell.centralBarView.xAxis.labelPosition = .bottom
            cell.centralBarView.xAxis.drawGridLinesEnabled = false
            cell.centralBarView.leftAxis.drawGridLinesEnabled = false
            cell.centralBarView.rightAxis.enabled = false
            cell.centralBarView.animate(yAxisDuration: 1.0)
        }

        switch indexPath.item {
        case 0:
            if dataForCell1.dataSets.isEmpty { } else {
                
                cell.centralBarView.data = dataForCell1
                let roundedValue = round(averageValue1 * 10) / 10
                cell.averageLabel.text = "$ " + String(roundedValue)
                cell.highestLabel.text = "$ " + String(highestValue1)
                cell.lowestLabel.text = "$ " + String(lowestValue1)
                cell.cryptocurrencyRateLabel.text = "$ " + String(currencyRate1)
            setUpCell()
                
            }
        case 1:
            if dataForCell2.dataSets.isEmpty { } else {
                cell.centralBarView.data = dataForCell2
                let roundedValue = round(averageValue2 * 10) / 10
                cell.averageLabel.text = "$ " + String(roundedValue)
                cell.highestLabel.text = "$ " + String(highestValue2)
                cell.highestLabel.text = "$ " + String(highestValue2)
                setUpCell()
                
            }
        default:
            break
        }
        
        return cell

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
