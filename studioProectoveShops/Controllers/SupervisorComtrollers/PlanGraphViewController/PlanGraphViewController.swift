//
//  PlanGraphViewController.swift
//  studioProectoveShops
//
//  Created by Konstantyn Byhkalo on 2/2/17.
//  Copyright © 2017 Dmitriy Gaponenko. All rights reserved.
//

import UIKit
import Charts

class PlanGraphViewController: UIViewController, ChartViewDelegate {

    @IBOutlet var chartView: BarChartView!
    
    var userDetail: UserModel!
    var planList = [DayPlanModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chartView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DayPlanManager.sharedInstance.getPlan(user: userDetail)
            .on(failed: { print("Error. PlanGraphViewController.swift LINE 24 \nError = \($0)") })
            { (dayPlanModels) in
                self.planList = dayPlanModels
                DispatchQueue.main.async {
                    self.configurateCharts()
                }
            }.start()
    }
//
    
    func configurateCharts() {
        
        var days = [String]()
        
        var values = [Double]()
        
        planList.sort { (plan1, plan2) -> Bool in
            return plan1.date > plan2.date
        }
        
        for plan in planList {
            days.append(Converter.daySringFromDate(plan.date))
            values.append(Double(plan.totalSum))
        }
        
        
        setChart(dataPoints: days, values: values)
        
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        chartView.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
//            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Unit Sold")
//        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Units Sold")
//        let chartData = BarChartData(xVals: months, dataSet: chartDataSet)
        let chartData = BarChartData(dataSets: [chartDataSet])
        chartView.data = chartData
        
        chartView.chartDescription?.text = ""
        
        chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        //        chartDataSet.colors = ChartColorTemplates.colorful()
        
        chartView.xAxis.labelPosition = .bottom
        
        //        barChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
        
        //        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
        
        let ll = ChartLimitLine(limit: 10.0, label: "Target")
        chartView.rightAxis.addLimitLine(ll)
        
    }

    
    //    MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }

}
