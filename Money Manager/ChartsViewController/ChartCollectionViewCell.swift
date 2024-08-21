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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        centralBarView.isUserInteractionEnabled = true
        
        centralBarView.scaleXEnabled = false
        centralBarView.scaleYEnabled = false
        centralBarView.pinchZoomEnabled = false
        centralBarView.pinchZoomEnabled = false
        centralBarView.doubleTapToZoomEnabled = false
        centralBarView.dragEnabled = false
        centralBarView.xAxis.drawLabelsEnabled = false
        
    }
}
