//
//  FirstViewController.swift
//  CashListApp
//
//  Created by fox on 2018/5/4.
//  Copyright © 2018年 fox. All rights reserved.
//

import UIKit
import CoreData

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
   
    
    // Adjust Color of StatusBar
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    @IBOutlet weak var myTableView: UITableView!
    
    @IBOutlet weak var myPickeView: UIPickerView!
    
    @IBOutlet weak var myEarning: UILabel!
    
    var data = [[String]]()
    
    var YearArray = [Int]()
    
    var MonthArray = [Int]()
    
    var DefaultYear = 2018
    
    var DefaultMonth = 1
    
    var Earning:Double = 0
    
    override func viewWillAppear(_ animated: Bool) {
        print("=======我是分隔線=======")
        let date = getCurrentDate()
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
            data = [[String]]()
            Earning = 0
            for result in results! {
                
                if "\(result.value(forKey: "type1")!)" == "支出"{
                    Earning -= Double("\(result.value(forKey: "price")!)")!
                }else{
                    Earning += Double("\(result.value(forKey: "price")!)")!
                }
                
                data.append(["\(result.value(forKey: "id")!)","\(result.value(forKey: "price")!)","\(result.value(forKey: "type1")!)","\(result.value(forKey: "type2")!)","\(result.value(forKey: "datetime")!)"])
            }
            if Earning > 0{
                myEarning.textColor = UIColor.red
            }else if Earning < 0{
                myEarning.textColor = UIColor.green
            }else{
                myEarning.textColor = UIColor.yellow
            }
            
            myEarning.text = "\(Earning)"
        } catch {
            fatalError("\(error)")
        }
        
        
        
        let currentDateArr = startDate.split{$0 == "-"}.map(String.init)
        if let currentYear = Int(currentDateArr[0]){
            if  let i = YearArray.index(of: currentYear) {
                myPickeView.selectRow(i, inComponent: 0, animated: false)
            }
        }
        if let currentMonth = Int(currentDateArr[1]){
            myPickeView.selectRow(currentMonth-1, inComponent: 1, animated: false)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        myPickeView.delegate = self
        myPickeView.dataSource = self
        
        for i in 0...10 {
            let currentYear = 2018 + i
            YearArray.append(currentYear)
        }
        
        for j in 1...12{
            let currentMonth = j
            MonthArray.append(currentMonth)
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        let income_expence = data[indexPath.row][2]
        if income_expence == "收入"{
            cell.textLabel?.textColor = .red
        }else{
            cell.textLabel?.textColor = .green
        }
        cell.backgroundColor = UIColor(red: 18/255, green: 41/255, blue: 70/255, alpha: 1)
        let type2 = data[indexPath.row][3]
        switch type2 {
        case "食":
            cell.imageView?.image = UIImage(named: "food")
        case "衣":
            cell.imageView?.image = UIImage(named: "cloth")
        case "住":
            cell.imageView?.image = UIImage(named: "home")
        case "行":
            cell.imageView?.image = UIImage(named: "car")
        case "育":
            cell.imageView?.image = UIImage(named: "education")
        case "樂":
            cell.imageView?.image = UIImage(named: "play")
        case "其他":
            cell.imageView?.image = UIImage(named: "other")
        default:
            cell.imageView?.image = UIImage(named: "other")
        }
        
        cell.accessoryType = .detailButton
        cell.textLabel?.font = UIFont(name: "arial", size: 24)
        cell.textLabel?.text = "\(data[indexPath.row][1])"
        
        cell.detailTextLabel?.textColor = UIColor.white
        cell.detailTextLabel?.text = "\(data[indexPath.row][4])".replacingOccurrences(of: "+0000", with: "",options:NSString.CompareOptions.literal, range:nil)
        
        return cell
    }
    /*
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
     return "May"
     }
     */
    // 實作 commit editingStyle
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            // delete
            if data[indexPath.row][2] == "支出"{
                Earning += Double(data[indexPath.row][1])!
            }else{
                Earning -= Double(data[indexPath.row][1])!
            }
            let deleteID = data[indexPath.row][0]
            let whereid = "id = \(deleteID)"
            let deleteResult = coreDataConnect.delete(myEntityName, predicate: whereid)
            if deleteResult {
                print("刪除資料成功")
            }
            
            if Earning > 0{
                myEarning.textColor = UIColor.red
            }else if Earning < 0{
                myEarning.textColor = UIColor.green
            }else{
                myEarning.textColor = UIColor.yellow
            }
            myEarning.text = "\(Earning)"
            data.remove(at: indexPath.row)
            myTableView.reloadData()
        }
    }
    
    // 實作 shouldHighlightRowAt
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // 實作 accessoryButtonTappedForRowWith
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        // 傳值
        if let secondViewController = tabBarController?.viewControllers?[2] as? SecondViewController{
            secondViewController.infoFromViewOne = Int(data[indexPath.row][0])
        }
        // 選擇編號1 的viewControlloer
        tabBarController?.selectedIndex = 2
    }
    
    
    // numberOfComponents
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // how many component in Picke View
        return 2
    }
    
    // numberOfRowsInComponent
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return YearArray.count
        }else{
            return MonthArray.count
        }
    }
    
    // titleForRow
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            return "\(YearArray[row])年"
        }else{
            return "\(MonthArray[row])月"
        }
    }
    
    // viewForRow
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        if component == 0 {
            pickerLabel.textColor = .white
            pickerLabel.textAlignment = .center
            pickerLabel.text = String("\(self.YearArray[row])年")
            pickerLabel.font = UIFont(name:"Helvetica", size: 28)
        }else{
            pickerLabel.textColor = .white
            pickerLabel.textAlignment = .center
            pickerLabel.text = String("\(self.MonthArray[row])月")
            pickerLabel.font = UIFont(name:"Helvetica", size: 28)

        }
        return pickerLabel
    }
    
    
    // didSelectRow
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0{
            DefaultYear = YearArray[row]
        }else{
            DefaultMonth = MonthArray[row]
        }
        
        let date = getCurrentDate()
        //创建一个日期格式器
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        //当月第一天日期
        let startDate = dateFormatter.string(from: date.startOfMonth(year: DefaultYear, month: DefaultMonth))
        
        //当月最后一天日期
        let endDate =  dateFormatter.string(from: date.endOfMonth(year: DefaultYear, month: DefaultMonth, returnEndTime: true))
        
        // format: String to Date
        let dateFormatters = DateFormatter()
        dateFormatters.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatters.timeZone = TimeZone(abbreviation: "GMT+0:00")
        
        let startTime = dateFormatters.date(from: startDate)!
        let endTime = dateFormatters.date(from: endDate)!
        
        // select && sort by datetime
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: myEntityName)
        
        request.sortDescriptors =
            [NSSortDescriptor(key: "datetime", ascending: false)]
        
        let datePredicate = NSPredicate(format: "datetime > %@ and datetime < %@", startTime as NSDate, endTime as NSDate)
        request.predicate = datePredicate
        
        do {
            let results = try myContext.fetch(request) as? [NSManagedObject]
            data = [[String]]()
            Earning = 0
            for result in results! {
                
                if "\(result.value(forKey: "type1")!)" == "支出"{
                    Earning -= Double("\(result.value(forKey: "price")!)")!
                }else{
                    Earning += Double("\(result.value(forKey: "price")!)")!
                }
                
                data.append(["\(result.value(forKey: "id")!)","\(result.value(forKey: "price")!)","\(result.value(forKey: "type1")!)","\(result.value(forKey: "type2")!)","\(result.value(forKey: "datetime")!)"])
            }
        } catch {
            fatalError("\(error)")
        }
        
        if Earning > 0{
            myEarning.textColor = UIColor.red
        }else if Earning < 0{
            myEarning.textColor = UIColor.green
        }else{
            myEarning.textColor = UIColor.yellow
        }
        myEarning.text = "\(Earning)"
        
        myTableView.reloadData()
        
    }
    
}

