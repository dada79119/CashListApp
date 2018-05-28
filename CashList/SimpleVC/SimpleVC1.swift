//
//  SimpleVC1.swift
//  CashList
//
//  Created by fox on 2018/5/26.
//  Copyright © 2018年 fox. All rights reserved.
//

import UIKit
import Charts

class SimpleVC1: UIViewController {
    
    var ItemArray:[String] = ["食","衣","住","行","育","樂","其他"]
    
    var IncomeArray = [Double]()
    
    var ExpenseArray = [Double]()
    
    override func viewWillAppear(_ animated: Bool) {
        print("=======我是分隔線VC1=======")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // select
        let selectResult = coreDataConnect.retrieve(myEntityName, predicate: nil, sort: [["id":true]], limit: nil)
        var income:Double = 0
        var expense:Double = 0
        var FoodDataIncome:Double = 0
        var FoodDataExpense:Double = 0
        var ClothDataIncome:Double = 0
        var ClothDataExpense:Double = 0
        var LiveDataIncome:Double = 0
        var LiveDataExpense:Double = 0
        var CarDataIncome:Double = 0
        var CarDataExpense:Double = 0
        var PlayDataIncome:Double = 0
        var PlayDataExpense:Double = 0
        var EduDataIncome:Double = 0
        var EduDataExpense:Double = 0
        var OthDataIncome:Double = 0
        var OthDataExpense:Double = 0
        
        if let results = selectResult {
            for result in results {
                let typeB:String = result.value(forKey: "type2") as! String
                if "\(result.value(forKey: "type1")!)" == "收入"{
                    if let cash:String = result.value(forKey: "price") as? String{
                        income += Double(cash)!
                        if typeB == "食"{
                            FoodDataIncome += Double(cash)!
                        }else if typeB == "衣"{
                            ClothDataIncome += Double(cash)!
                        }else if typeB == "住"{
                            LiveDataIncome += Double(cash)!
                        }else if typeB == "行"{
                            CarDataIncome += Double(cash)!
                        }else if typeB == "育"{
                            EduDataIncome += Double(cash)!
                        }else if typeB == "樂"{
                            PlayDataIncome += Double(cash)!
                        }else{
                            OthDataIncome += Double(cash)!
                        }
                        
                    }
                }else{
                    
                    if let cash:String = result.value(forKey: "price") as? String{
                        expense += Double(cash)!
                        
                        if typeB == "食"{
                            FoodDataExpense += Double(cash)!
                        }else if typeB == "衣"{
                            ClothDataExpense += Double(cash)!
                        }else if typeB == "住"{
                            LiveDataExpense += Double(cash)!
                        }else if typeB == "行"{
                            CarDataExpense += Double(cash)!
                        }else if typeB == "育"{
                            EduDataExpense += Double(cash)!
                        }else if typeB == "樂"{
                            PlayDataExpense += Double(cash)!
                        }else{
                            OthDataExpense += Double(cash)!
                        }
                        
                    }
                }
            }
        }
        
        let win_width = self.view.frame.width
        let win_height = self.view.frame.height
        
        let IncomePieChartView = PieChartView(frame: CGRect(x: 0, y: 0, width: win_width, height: (win_height-126)*(2/5)))
        
        IncomePieChartView.backgroundColor = .white
        
        
        let OverViewLineChartView = LineChartView(frame: CGRect(x: 0, y: IncomePieChartView.frame.height, width: win_width, height: win_height - 126 - IncomePieChartView.frame.height))
        
        
        OverViewLineChartView.backgroundColor = .white
        OverViewLineChartView.chartDescription?.text = ""
        OverViewLineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: ItemArray)
        OverViewLineChartView.xAxis.granularity = 0
        OverViewLineChartView.xAxis.labelPosition = .bottom
        OverViewLineChartView.animate(xAxisDuration: 1.0, yAxisDuration: 2.0)
        
        self.view.addSubview(OverViewLineChartView)
        self.view.addSubview(IncomePieChartView)
        
        if income == 0 && expense == 0{
            
            IncomePieChartView.noDataFont = UIFont(name: "Helvetica", size: 12)!
            
            IncomePieChartView.noDataTextColor = UIColor.orange
            
            IncomePieChartView.noDataText = "No Data Available"
            
            OverViewLineChartView.noDataFont = UIFont(name: "Helvetica", size: 12)!
            OverViewLineChartView.noDataTextColor = UIColor.orange
            
            OverViewLineChartView.noDataText = "No Data Available"
            
        }else{
            
            IncomeArray = [FoodDataIncome,ClothDataIncome,LiveDataIncome,CarDataIncome,EduDataIncome,PlayDataIncome,OthDataIncome]
            
            ExpenseArray = [FoodDataExpense,ClothDataExpense,LiveDataExpense,CarDataExpense,EduDataExpense,PlayDataExpense,OthDataExpense]
            
            var chartDataSets : [LineChartDataSet] = [LineChartDataSet]()
            var Set1Entries: [ChartDataEntry] = []
            for i in 0..<IncomeArray.count {
                let dataEntry1 = ChartDataEntry(x: Double(i), y:IncomeArray[i])
                Set1Entries.append(dataEntry1)
            }
            let chartDataSet1 = LineChartDataSet(values: Set1Entries, label: "收入")
            chartDataSet1.setColor(UIColor(red: 97/255, green: 238/255, blue: 1, alpha: 1))
            chartDataSet1.setCircleColor(UIColor(red: 97/255, green: 238/255, blue: 1, alpha: 1))
            chartDataSet1.drawValuesEnabled = false
            
            var Set2Entries: [ChartDataEntry] = []
            for i in 0..<ExpenseArray.count {
                let dataEntry2 = ChartDataEntry(x:Double(i) , y: ExpenseArray[i])
                Set2Entries.append(dataEntry2)
            }
            
            let chartDataSet2 = LineChartDataSet(values: Set2Entries, label: "支出")
            chartDataSet2.setColor(UIColor(red: 1, green: 128/255, blue: 150/255, alpha: 1))
            chartDataSet2.setCircleColor(UIColor(red: 1, green: 128/255, blue: 150/255, alpha: 1))
            chartDataSet2.drawValuesEnabled = false
            
            chartDataSets.append(chartDataSet1)
            
            chartDataSets.append(chartDataSet2)
            
            let lineChartData = LineChartData(dataSets: chartDataSets)
            
            OverViewLineChartView.data = lineChartData
            
            
            IncomePieChartView.backgroundColor = .white
            IncomePieChartView.chartDescription?.text = ""
            IncomePieChartView.centerText = "盈餘：\(income - expense)"
            IncomePieChartView.animate(xAxisDuration: 0, yAxisDuration: 1.0)
            IncomePieChartView.highlightPerTapEnabled = false
            
            let pieChartLegend = IncomePieChartView.legend
            pieChartLegend.font = UIFont(name: "Helvetica", size: 12)!
            pieChartLegend.textColor = UIColor.black
            pieChartLegend.horizontalAlignment = Legend.HorizontalAlignment.right
            pieChartLegend.verticalAlignment = Legend.VerticalAlignment.top
            pieChartLegend.orientation = Legend.Orientation.vertical
            pieChartLegend.drawInside = false
            pieChartLegend.yOffset = 10.0
            
            var numberOfDownLoadDataEntries = [PieChartDataEntry]()
            var dataEntry = [income,expense]
            
            for i in 0..<dataEntry.count{
                let tempDataEntry = PieChartDataEntry(value: 0)
                if i == 0{
                    tempDataEntry.label = "總收入"
                }else{
                    tempDataEntry.label = "總支出"
                }
                tempDataEntry.value = (dataEntry[i]/(income+expense))*100
                numberOfDownLoadDataEntries.append(tempDataEntry)
            }
            
            let piechartDataSet = PieChartDataSet(values: numberOfDownLoadDataEntries, label: nil)
            let pieChartData = PieChartData(dataSet: piechartDataSet)
            
            let color = [UIColor(red: 0, green: 150/255, blue: 1, alpha: 1),UIColor(red: 253/255, green: 93/255, blue: 100/255, alpha: 1)]
            piechartDataSet.colors = color
            
            let format = NumberFormatter()
            format.numberStyle = .percent
            format.maximumFractionDigits = 1
            format.multiplier = 1.0
            
            pieChartData.setValueFormatter(DefaultValueFormatter(formatter:format))
            piechartDataSet.xValuePosition = .outsideSlice
            piechartDataSet.yValuePosition = .outsideSlice
            piechartDataSet.valueColors = [UIColor.black,UIColor.black]
            piechartDataSet.valueLineColor = UIColor.black
            piechartDataSet.sliceSpace = 2.0
            
            IncomePieChartView.data = pieChartData
            
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
