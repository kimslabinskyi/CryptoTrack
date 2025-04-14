//
//  ChartsViewController.swift
//  Money Manager
//
//  Created by Kim on 06.08.2024.
//

import UIKit
import Charts
import CoreHaptics

class ChartsViewController: UIViewController, ChartViewDelegate, CustomAlertDelegate {
    var hasErrorOccurred = false
    var isInitialLayoutDone = false
    var selectedIndexPath: IndexPath?
    
    private var popover = CustomPopoverView()
    private let alert = AlertController()
    private let generator = UIImpactFeedbackGenerator(style: .rigid)

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isInitialLayoutDone == false{
            let originalSize = collectionView.frame.size
            collectionView.frame.size.height = collectionView.contentSize.height
            
            collectionView.layoutIfNeeded()
            collectionView.frame.size = originalSize
            collectionView.showsVerticalScrollIndicator = false
            isInitialLayoutDone = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        for (index, _) in GlobalData.cellDataArray.enumerated(){
            self.initChart(for: &GlobalData.cellDataArray[index])
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            
            if let indexPath = selectedIndexPath{
                
                if let destinationVC = segue.destination as? DetailScreenViewController {
                    destinationVC.indexPath = indexPath
                }
            }
        }
    }
    
    private func setUp(){
        collectionView.delaysContentTouches = false
        collectionView.backgroundColor = UIColor.systemBackground
        
        let titleLabel = UILabel()
        titleLabel.text = "Crypto Currency Rates"
        titleLabel.textColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? .white: .black
        }
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        titleLabel.sizeToFit()
        
        let titleView = UIView()
        titleView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor)
        ])
        
        titleView.frame = CGRect(x: 0, y: 0, width: titleLabel.frame.width, height: titleLabel.frame.height)
        
        self.navigationItem.titleView = titleView
    }
    
    private func loadData() {
        let dispatchGroup = DispatchGroup()
        hasErrorOccurred = false

        for (index, cellData) in GlobalData.cellDataArray.enumerated() {
            dispatchGroup.enter()
            
            NetworkManager.shared.getCryptocurrencyRate(cellData.typeOfCell) { [weak self] name, jsonResponse, error in
                guard let self = self else {
                    dispatchGroup.leave()
                    return
                }
                
                if let name = name {
                    GlobalData.cellDataArray[index].currencyName = name
                }
                if let response = jsonResponse {
                    GlobalData.cellDataArray[index].dataBase = response
                    self.initChart(for: &GlobalData.cellDataArray[index])
                } else if let error = error {
                    self.hasErrorOccurred = true
                    print("Error in getCryptocurrencyRate: \(error.localizedDescription)")
                }
                
                dispatchGroup.leave()
            }
            
//            dispatchGroup.enter()
//            
//            NetworkManager.shared.getMarketCap(cellData.typeOfCell) { jsonResponse, error in
//                if let response = jsonResponse {
//                    let marketCap = response.usdMarketCap
//                    GlobalData.cellDataArray[index].marketCap = Int(marketCap)
//                    print("MarketCap = \(String(describing: response))")
//                } else if let error = error {
//                    self.hasErrorOccurred = true
//                    print("Error in getMarketCap: \(error.localizedDescription)")
//                }
//                
//                dispatchGroup.leave()
//            }
        }
        
        dispatchGroup.notify(queue: .main) {
            if self.hasErrorOccurred == false {
                self.collectionView.reloadData()
            } else {
                self.alert.showAlert(title: "Error", message: "Failed to load all data from API, please try again later", on: self)
            }
        }
    }
    
    private func showAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func doHapticFeedback() {
        if SettingsViewController.isHapticFeedbackEnabled == true {
            generator.impactOccurred()
        }
    }
    
    
    func initChart(for cellData: inout CellData){
        var entries = [BarChartDataEntry]()
        let shortDataBase = cellData.dataBase.prices.suffix(31)
        var sum: Double = 0.0
        var lowestValue: Double = Double.greatestFiniteMagnitude
        var highestValue: Double = 0.0
        
        guard let lastElement = cellData.dataBase.prices.last?[1]
        else { return }
        guard let thirtyFirstFromEnd = cellData.dataBase.prices.suffix(31).first?[1]
        else { return }
        
        let secondLastElementIndex = cellData.dataBase.prices.count - 2
        guard cellData.dataBase.prices.indices.contains(secondLastElementIndex)
        else { return }
        let secondLastElement = cellData.dataBase.prices[secondLastElementIndex][1]

        
        for (index, priceData) in shortDataBase.enumerated(){
            
            let price = round(priceData[1])
            entries.append(BarChartDataEntry(x: Double(index), y: price))
            sum += price
                        
            if priceData[1] < lowestValue{
                lowestValue = priceData[1]
            }
            
            if priceData[1] > highestValue {
                highestValue = priceData[1]
            }
        }
        
        cellData.averageValue = sum / Double(shortDataBase.count)
        cellData.lowestValue = lowestValue
        cellData.highestValue = highestValue
        
        let summaryDifference = lastElement - thirtyFirstFromEnd
        let dailyDifference = lastElement - secondLastElement
        print("summaryDifference = \(summaryDifference)")
        print("dailyDifference = \(dailyDifference)")
        cellData.dynamicSummary = summaryDifference/thirtyFirstFromEnd * 100
        cellData.dailySummary = dailyDifference/secondLastElement * 100
        cellData.dailySummaryCount = dailyDifference
    
        
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
    
}

extension ChartsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        GlobalData.cellDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ChartCollectionViewCell
        let cellData = GlobalData.cellDataArray[indexPath.row]
        configureCell(cell, with: cellData)
        
        return cell
    }
    
    private func configureCell(_ cell: ChartCollectionViewCell, with cellData: CellData) {
        let radius: CGFloat = 20
        cell.layer.cornerRadius = radius
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.masksToBounds = true
        cell.centralBarView.delegate = self
        
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.2
        cell.layer.shadowOffset = CGSize(width: 0, height: 3)
        cell.layer.shadowRadius = 6
        cell.layer.masksToBounds = false
        
        if !cellData.cellDataForChart.isEmpty {
            cell.centralBarView.data = cellData.cellDataForChart
            cell.cryptocurrencyRateLabel.text = String(Int(cellData.currencyRate)) + " USD"
            cell.cryptocurrencyNameLabel.text = cellData.currencyName
            
            if cellData.dynamicSummary < 0 {
                cell.dynamicSummaryLabel.text = String(format: "%.2f", cellData.dynamicSummary) + " %"
                cell.dynamicSummaryLabel.backgroundColor = UIColor.systemRed
            } else {
                cell.dynamicSummaryLabel.text = "+\(String(format: "%.2f", cellData.dynamicSummary)) %"
            }
            
            if cellData.dailySummary < 0 {
                cell.dailySummaryLabel.text = String(format: "%.2f", cellData.dailySummary) + " %"
                cell.dailySummaryLabel.backgroundColor = UIColor.systemRed
            } else {
                cell.dailySummaryLabel.text = "+\(String(format: "%.2f", cellData.dailySummary)) %"
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        doHapticFeedback()
        selectedIndexPath = indexPath
        performSegue(withIdentifier: "showDetail", sender: nil)
    }
    
    func customAlertAction() {
        print("Activate custom alert")
    }
    
}


extension ChartsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 340
        let height = 325
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { 10 }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { 25 }
 
}
