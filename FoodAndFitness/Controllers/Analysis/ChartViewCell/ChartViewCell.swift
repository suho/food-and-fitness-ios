//
//  ChartViewCell.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 4/30/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import Charts
import SwiftDate

final class ChartViewCell: BaseTableViewCell {
    @IBOutlet fileprivate(set) weak var barChartView: BarChartView!
    let units: [Double] = [20.0, 5.0, 10.0, 17.0, 12.0, 16.0, 8.0]

    struct Data {
        var eatenCalories: [Int]
        var burnedCalories: [Int]
    }

    var data: Data? {
        didSet {
            guard let data = data else { return }
            guard data.eatenCalories.count == 7 && data.burnedCalories.count == 7 else { return }
            barChartView.data = dataForChartView(eatenCalories: data.eatenCalories,
                                                 burnedCalories: data.burnedCalories)
        }
    }

    override func setupUI() {
        super.setupUI()
        configureChartView()
    }

    private func configureChartView() {
        barChartView.delegate = self
        barChartView.chartDescription?.enabled = false
        barChartView.pinchZoomEnabled = false
        barChartView.drawBarShadowEnabled = false
        barChartView.drawGridBackgroundEnabled = false
        barChartView.doubleTapToZoomEnabled = false

        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.xAxis.granularity = 1.0
        barChartView.xAxis.valueFormatter = DayAxisValueFormatter()

        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.drawGridLinesEnabled = false
        barChartView.legend.enabled = false
        barChartView.scaleXEnabled = false
        barChartView.scaleYEnabled = false

        barChartView.fitBars = true
        barChartView.setNeedsDisplay()
    }

    private func dataForChartView(eatenCalories: [Int], burnedCalories: [Int]) -> BarChartData {
        var eatenDataEntries: [BarChartDataEntry] = [BarChartDataEntry]()
        var burnedDataEntries: [BarChartDataEntry] = [BarChartDataEntry]()
        for i in 0..<7 {
            eatenDataEntries.append(BarChartDataEntry(x: Double(i), y: Double(eatenCalories[i])))
            burnedDataEntries.append(BarChartDataEntry(x: Double(i), y: Double(burnedCalories[i])))
        }

        let eatenDataSet = BarChartDataSet(values: eatenDataEntries, label: "Eaten")
        let burnedDataSet = BarChartDataSet(values: burnedDataEntries, label: "Burn")
        eatenDataSet.colors = [Color.blue63]
        eatenDataSet.drawValuesEnabled = true
        burnedDataSet.colors = [Color.gray245]
        burnedDataSet.drawValuesEnabled = true
        let data = BarChartData(dataSets: [eatenDataSet, burnedDataSet])
        let groupSpace = 0.1
        let barSpace = 0.05
        let barWidth = 0.4
        let xAxis = -0.5
        data.barWidth = barWidth
        data.groupBars(fromX: xAxis, groupSpace: groupSpace, barSpace: barSpace)
        return data
    }
}

extension ChartViewCell: ChartViewDelegate { }

final class DayAxisValueFormatter: NSObject, IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let day = (DateInRegion() - (7 - Int(value)).days).ffDate().weekdayName
        let index = day.index(day.startIndex, offsetBy: 3)
        return day.substring(to: index)
    }
}
