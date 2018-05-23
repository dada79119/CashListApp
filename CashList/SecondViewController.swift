//
//  SecondViewController.swift
//  CashListApp
//
//  Created by fox on 2018/5/4.
//  Copyright © 2018年 fox. All rights reserved.
//

import UIKit
import CoreData

enum Operation:String {
    case Add = "+"
    case Subtract = "-"
    case Divide = "/"
    case Multiply = "*"
    case None = "None"
    
}

class SecondViewController: UIViewController {
    // Adjust Color of StatusBar
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    var infoFromViewOne:Int?
    var runningNumber = ""
    var leftValue = ""
    var rightValue = ""
    var result = ""
    var currentOperation:Operation = .None
    var aType:String?
    var bType:String?
    var currentTime = Date()
    
    @IBOutlet weak var outputLabel: UILabel!
    
    @IBOutlet weak var outputButton: UIButton!
    
    @IBOutlet weak var itemTypeButton: RoundButton!
    
    @IBOutlet weak var itemTypeButton2: RoundButton!
    
    @IBAction func itemType(_ sender: RoundButton) {
        if let current_title1 = sender.currentTitle{
            if current_title1 == "收入"{
                itemTypeButton.backgroundColor = UIColor(red: 15/255, green: 206/255, blue: 112/255, alpha: 1)
                aType = "支出"
            }else{
                itemTypeButton.backgroundColor = UIColor(red:255/255, green: 13/255, blue: 9/255, alpha: 1)
                aType = "收入"
            }
            outputButton.setTitle("送出", for: .normal)
            itemTypeButton.setTitleColor(UIColor.white,for: .normal)
            itemTypeButton.setTitle(aType, for: .normal)
        }
        
    }
    
    @IBAction func itemType2(_ sender: RoundButton) {
        if let current_title2 = sender.currentTitle{
            switch current_title2{
            case "食":
                itemTypeButton2.backgroundColor = UIColor(red: 243/255, green: 165/255, blue: 0, alpha: 1)
                bType = "衣"
            case "衣":
                itemTypeButton2.backgroundColor = UIColor(red: 113/255, green: 198/255, blue: 27/255, alpha: 1)
                bType = "住"
            case "住":
                itemTypeButton2.backgroundColor = UIColor(red: 44/255, green: 198/255, blue: 174/288, alpha: 1)
                bType = "行"
            case "行":
                itemTypeButton2.backgroundColor = UIColor(red: 59/255, green: 91/255, blue: 175/255, alpha: 1)
                bType = "育"
            case "育":
                itemTypeButton2.backgroundColor = UIColor(red: 117/255, green: 0, blue: 138/255, alpha: 1)
                bType = "樂"
            case "樂":
                itemTypeButton2.backgroundColor = UIColor(red: 0/255, green: 174/255, blue: 240/255, alpha: 1)
                bType = "其他"
            case "其他":
                itemTypeButton2.backgroundColor = UIColor(red: 255/255, green: 120/255, blue: 145/255, alpha: 1)
                bType = "食"
            default:
                itemTypeButton2.backgroundColor = UIColor(red: 255/255, green: 120/255, blue: 145/255, alpha: 1)
                bType = "食"
            }
            outputButton.setTitle("送出", for: .normal)
            itemTypeButton2.setTitleColor(UIColor.white,for: .normal)
            itemTypeButton2.setTitle(bType, for: .normal)
        }
        
    }
    
    func current_time() -> String {
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy年MM月dd日 HH時mm分ss秒"
        let now = "\(dformatter.string(from: Date()))"
        return now
    }
    
    @IBAction func outputPressed(_ sender: UIButton) {
        if let current_title = sender.currentTitle{
            if current_title == "送出"{
                // 傳值
                if let firstViewController = tabBarController?.viewControllers?[1] as? FirstViewController{
                    
                    // auto increment
                    let myUserDefaults = UserDefaults.standard
                    var seq = 1
                    if let idSeq = myUserDefaults.object(forKey: "idSeq") as? Int {
                        seq = idSeq + 1
                    }
                    
                    if infoFromViewOne == nil{
                        
                        let date = getCurrentDate()
                        
                        let insetData = NSEntityDescription.insertNewObject(forEntityName: myEntityName, into: myContext)
                        
                        insetData.setValue(date.now(), forKey: "datetime")
                        insetData.setValue(seq, forKey: "id")
                        insetData.setValue(outputLabel.text!, forKey: "price")
                        insetData.setValue(aType!, forKey: "type1")
                        insetData.setValue(bType!, forKey: "type2")
                        
                        do {
                            try myContext.save()
                            myUserDefaults.set(seq, forKey: "idSeq")
                            myUserDefaults.synchronize()
                            firstViewController.data.append(["\(seq)","\(outputLabel.text!)","\(aType!)","\(bType!)","\(date.now())"])
                            print("新增資料成功")
                            
                        } catch {
                            print(error.localizedDescription)
                        }
                        
                    }else{
                        // update
                        let updateId = infoFromViewOne
                        let whereid = "id = \(updateId!)"
                        let updateResult = coreDataConnect.update(myEntityName, predicate: whereid, attributeInfo: ["price":"\(outputLabel.text!)","type1":aType!,"type2":bType!])
                        if updateResult {
                            print("更新資料成功")
                        }
                    }
            
                    
                }
            }
            tabBarController?.selectedIndex = 1
        }
    }
    
    @IBAction func numberPressed(_ sender: RoundButton) {
        outputButton.setTitle("送出", for: .normal)
        if runningNumber.count <= 8{
            runningNumber += "\(sender.tag)"
            outputLabel.text = runningNumber
        }
    }
    
    @IBAction func allClearPressed(_ sender: RoundButton) {
        runningNumber = ""
        leftValue = ""
        rightValue = ""
        currentOperation = .None
        outputLabel.text = "0"
        aType = "收入"
        itemTypeButton.backgroundColor = UIColor(red:255/255, green: 13/255, blue: 9/255, alpha: 1)
        bType = "食"
        itemTypeButton.setTitle(aType, for: .normal)
        itemTypeButton2.setTitle(bType, for: .normal)
        outputButton.setTitle("返回", for: .normal)
    }
    
    @IBAction func dotPressed(_ sender: RoundButton) {
        if runningNumber.count <= 7{
            runningNumber += "."
            outputLabel.text = runningNumber
        }
    }
    
    @IBAction func equalPressed(_ sender: RoundButton) {
        operation(operation: currentOperation)
    }
    
    @IBAction func addPressed(_ sender: RoundButton) {
        operation(operation: .Add)
    }
    
    @IBAction func subtractPressed(_ sender: RoundButton) {
        operation(operation: .Subtract)
    }
    
    @IBAction func multiplyPressed(_ sender: RoundButton) {
        operation(operation: .Multiply)
    }
    
    @IBAction func dividePressed(_ sender: RoundButton) {
        operation(operation: .Divide)
    }
    
    func operation(operation: Operation){
        if currentOperation != .None{
            if runningNumber != ""{
                rightValue = runningNumber
                runningNumber = ""
                
                if currentOperation == .Add{
                    result = "\(Double(leftValue)! + Double(rightValue)!)"
                }else if currentOperation == .Subtract{
                    result = "\(Double(leftValue)! - Double(rightValue)!)"
                }else if currentOperation == .Multiply{
                    result = "\(Double(leftValue)! * Double(rightValue)!)"
                }else if currentOperation == .Divide{
                    result = "\(Double(leftValue)! / Double(rightValue)!)"
                }
                
                leftValue = result
                // 去除整除時的小數點
                if (Double(result)!.truncatingRemainder(dividingBy: 1) == 0){
                    result = "\(Int(Double(result)!))"
                }
                // 超過九位數的狀況(待修正)
                if String(result).count >= 9 {
                    result = "\(String(result).prefix(9))"
                }
                outputLabel.text = result
            }
            currentOperation = operation
            
        }else{
            leftValue = runningNumber
            runningNumber = ""
            currentOperation = operation
        }
    }
    var data = [[String]]()
    override func viewWillAppear(_ animated: Bool) {
        itemTypeButton.backgroundColor = UIColor(red:255/255, green: 13/255, blue: 9/255, alpha: 1)
        if infoFromViewOne != nil{
            // select
            let whereid = "id= \(infoFromViewOne!)"
            let selectResult = coreDataConnect.retrieve(myEntityName, predicate: whereid, sort: [["id":true]], limit: nil)
            if let results = selectResult {
                for result in results {
                    outputLabel.text! = result.value(forKey: "price") as! String
                    aType = (result.value(forKey: "type1") as! String)
                    if aType == "支出"{
                        itemTypeButton.backgroundColor = UIColor(red: 15/255, green: 206/255, blue: 112/255, alpha: 1)
                    }else{
                        itemTypeButton.backgroundColor = UIColor(red:255/255, green: 13/255, blue: 9/255, alpha: 1)
                    }
                    bType = (result.value(forKey: "type2") as! String)
                }
            }
            runningNumber = outputLabel.text!
        }else{
            outputLabel.text = "0"
            aType = "收入"
            bType = "食"
        }
        
        itemTypeButton.setTitle(aType, for: .normal)
        itemTypeButton2.setTitle(bType, for: .normal)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        runningNumber = ""
        leftValue = ""
        rightValue = ""
        currentOperation = .None
        outputLabel.text = "0"
        aType = nil
        bType = nil
        infoFromViewOne = nil
        // 轉場閃爍(待修正)
        //itemTypeButton.setTitle("\(aType)", for: .normal)
        //itemTypeButton2.setTitle("\(bType)", for: .normal)
        outputButton.setTitle("返回", for: .normal)
    }
    
}

