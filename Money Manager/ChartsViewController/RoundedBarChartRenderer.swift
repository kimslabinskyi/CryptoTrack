//
//  RoundedBarChartRenderer.swift
//  Money Manager
//
//  Created by Kim on 10.08.2024.
//

import Charts
import UIKit

class RoundedBarChartRenderer: BarChartRenderer {

    override func drawDataSet(context: CGContext, dataSet: BarChartDataSetProtocol, index: Int) {
        guard let dataProvider = dataProvider else { return }

        let barData = dataProvider.barData
        let trans = dataProvider.getTransformer(forAxis: dataSet.axisDependency)
        let drawBarShadowEnabled = dataProvider.isDrawBarShadowEnabled
        let drawValueAboveBar = dataProvider.isDrawValueAboveBarEnabled
        let isInverted = dataProvider.isInverted(axis: dataSet.axisDependency)

        let phaseY = animator.phaseY

        var barRect = CGRect()

        for j in 0 ..< Int(ceil(Double(dataSet.entryCount) * animator.phaseX)) {
            guard let e = dataSet.entryForIndex(j) as? BarChartDataEntry else { continue }

            let y = e.y

            let barWidth = barData?.barWidth ?? 0.0
            let x = e.x

            barRect.origin.x = CGFloat(x - barWidth / 2.0)
            barRect.size.width = CGFloat(barWidth)
            barRect.origin.y = y >= 0.0 ? 0.0 : CGFloat(y) * CGFloat(phaseY)
            barRect.size.height = abs(CGFloat(y) * CGFloat(phaseY))

            trans.rectValueToPixel(&barRect)

            if !viewPortHandler.isInBoundsLeft(barRect.origin.x + barRect.size.width) {
                continue
            }

            if !viewPortHandler.isInBoundsRight(barRect.origin.x) {
                break
            }

            // Закругление углов
            let cornerRadius = min(barRect.width, barRect.height) / 4
            let path = UIBezierPath(roundedRect: barRect, cornerRadius: cornerRadius)

            context.saveGState()
            context.setFillColor(dataSet.color(atIndex: j).cgColor)
            context.addPath(path.cgPath)
            context.fillPath()
            context.restoreGState()
        }
    }
}
