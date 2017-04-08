//
//  NutritionAnalysisController.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 3/28/17.
//  Copyright © 2017 SuHoVan. All rights reserved.
//

import UIKit
import Charts
import SwiftDate

final class NutritionAnalysisController: BaseViewController {

    @IBOutlet fileprivate(set) weak var barChartView: BarChartView!

    let units: [Double] = [20.0, 4.0, -10.0, 3.0, 12.0, 16.0, 4.0]

    override var isNavigationBarHidden: Bool {
        return true
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

        let xAxis = barChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.drawGridLinesEnabled = false
        xAxis.granularity = 1.0
        xAxis.valueFormatter = DayAxisValueFormatter()

        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.drawGridLinesEnabled = false
        barChartView.legend.enabled = false
        barChartView.data = dataChartView()
        barChartView.fitBars = true
        barChartView.setNeedsDisplay()
    }

    private func dataChartView() -> BarChartData {
        var dataEntries: [BarChartDataEntry] = [BarChartDataEntry]()
        for i in 0..<7 {
            dataEntries.append(BarChartDataEntry(x: Double(i), y: units[i]))
        }

        let dataSet = BarChartDataSet(values: dataEntries, label: "Data Set")
        dataSet.colors = ChartColorTemplates.vordiplom()
        dataSet.drawValuesEnabled = true
        return BarChartData(dataSet: dataSet)
    }
}

extension NutritionAnalysisController: ChartViewDelegate { }

class DayAxisValueFormatter: NSObject, IAxisValueFormatter {

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let day = (DateInRegion() - (7 - Int(value)).days).ffDate().weekdayName
        let index = day.index(day.startIndex, offsetBy: 3)
        return day.substring(to: index)
    }
}
