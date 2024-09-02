//
//  ChartCollectionViewCell.swift
//  Money Manager
//
//  Created by Kim on 06.08.2024.
//

import UIKit
import Charts

class ChartCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var centralBarView: BarChartView!
    
    @IBOutlet weak var cryptocurrencyNameLabel: UILabel!
    @IBOutlet weak var cryptocurrencyRateLabel: UILabel!
    
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var highestLabel: UILabel!
    @IBOutlet weak var lowestLabel: UILabel!
    @IBOutlet weak var marketCapLabel: UILabel!
    
    @IBOutlet weak var dailySummaryLabel: UILabel!
    @IBOutlet weak var dynamicSummaryLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        centralBarView.isUserInteractionEnabled = true
        
        centralBarView.scaleXEnabled = false
        centralBarView.scaleYEnabled = false
        centralBarView.pinchZoomEnabled = false
        centralBarView.pinchZoomEnabled = false
        centralBarView.doubleTapToZoomEnabled = false
        //centralBarView.dragEnabled = false
        centralBarView.xAxis.drawLabelsEnabled = false
        
        centralBarView.xAxis.labelPosition = .bottom
        centralBarView.xAxis.drawGridLinesEnabled = false
        centralBarView.leftAxis.drawGridLinesEnabled = false
        centralBarView.rightAxis.enabled = false
        centralBarView.animate(yAxisDuration: 1.0)
        
        dailySummaryLabel.layer.cornerRadius = 5
        dailySummaryLabel.layer.masksToBounds = true
        dynamicSummaryLabel.layer.cornerRadius = 5
        dynamicSummaryLabel.layer.masksToBounds = true
    }
    
    func deselectElement(){
        centralBarView.highlightValue(nil)
    }
}
