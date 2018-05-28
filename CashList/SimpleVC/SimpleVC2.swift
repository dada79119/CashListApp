//
//  SimpleVC2.swift
//  CashList
//
//  Created by fox on 2018/5/26.
//  Copyright © 2018年 fox. All rights reserved.
//

import UIKit
import CoreData
import Charts

class SimpleVC2: UIViewController {
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
    
    var ItemArray:[String] = ["食","衣","住","行","育","樂","其他"]
    
    var IncomeArray = [Double]()
    
    var ExpenseArray = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        print("=======我是分隔線VC2=======")
        // select
        let date = getCurrentDate()
        print("123")
        //创建一个日期格式器
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateFormatters = DateFormatter()
        dateFormatters.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatters.timeZone = TimeZone(abbreviation: "GMT+0:00")
        //當月第一天日期
        let startDate = dateFormatter.string(from: date.startOfCurrentMonth() as Date)
        let startTime = dateFormatters.date(from: startDate)!
        
        //當月最後一天日期
        let endDate2 = dateFormatter.string(from: date.endOfCurrentMonth(returnEndTime: true))
        let endTime = dateFormatters.date(from: endDate2)!
        
        // select && sort by datetime
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: myEntityName)
        
        let datePredicate = NSPredicate(format: "datetime > %@ and datetime < %@", startTime as NSDate, endTime as NSDate)
        request.predicate = datePredicate
        
        request.sortDescriptors =
            [NSSortDescriptor(key: "datetime", ascending: false)]
        do {
            let results = try myContext.fetch(request) as? [NSManagedObject]
            for result in results! {
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
            
        } catch {
            fatalError("\(error)")
        }
        
        let win_width = self.view.frame.width
        let win_height = self.view.frame.height
        
        let OverViewLineChartView = LineChartView(frame: CGRect(x: 0, y: 8, width: win_width, height: win_height - 136 ))
        
        
        OverViewLineChartView.backgroundColor = .white
        OverViewLineChartView.chartDescription?.text = ""
        OverViewLineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: ItemArray)
        OverViewLineChartView.xAxis.granularity = 0
        OverViewLineChartView.xAxis.labelPosition = .bottom
        
        self.view.addSubview(OverViewLineChartView)
        
        
        if income == 0 && expense == 0{
            
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
            
        }
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
