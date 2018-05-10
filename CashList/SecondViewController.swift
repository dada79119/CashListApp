//
//  SecondViewController.swift
//  CashListApp
//
//  Created by fox on 2018/5/4.
//  Copyright © 2018年 fox. All rights reserved.
//

import UIKit

enum Operation:String {
    case Add = "+"
    case Subtract = "-"
    case Divide = "/"
    case Multiply = "*"
    case None = "None"
    
}

enum CashListType:String {
    case Datetime = "date"
    case Cash = "cash"
    case Type1 = "type1"
    case Type2 = "type2"
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
    
    
    @IBOutlet weak var outputLabel: UILabel!
    
    @IBOutlet weak var outputButton: UIButton!
    
    @IBOutlet weak var itemTypeButton: RoundButton!
    
    @IBOutlet weak var itemTypeButton2: RoundButton!
    
    @IBAction func itemType(_ sender: RoundButton) {
        if let current_title1 = sender.currentTitle{
            if current_title1 == "收入"{
                aType = "支出"
            }else{
                aType = "收入"
            }
            outputButton.setTitle("送出", for: .normal)
            itemTypeButton.setTitle(aType, for: .normal)
        }
        
    }
    
    @IBAction func itemType2(_ sender: RoundButton) {
        if let current_title2 = sender.currentTitle{
            switch current_title2{
            case "食":
                bType = "衣"
            case "衣":
                bType = "住"
            case "住":
                bType = "行"
            case "行":
                bType = "育"
            case "育":
                bType = "樂"
            case "樂":
                bType = "其他"
            case "其他":
                bType = "食"
            default:
                bType = "食"
            }
            outputButton.setTitle("送出", for: .normal)
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
                if let firstViewController = tabBarController?.viewControllers?[0] as? FirstViewController{
                    
                    if infoFromViewOne == nil{
                        
                        
                    }else{
                        
                        
                    }
                    
                    firstViewController.myTableView.reloadData()
                }
            }
            tabBarController?.selectedIndex = 0
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
    
    override func viewWillAppear(_ animated: Bool) {
        if infoFromViewOne != nil{
            
            if let cash = UserDefaults.standard.stringArray(forKey: "\(CashListType.Cash)"){
                outputLabel.text = cash[infoFromViewOne!]
            }
            if let type1 = UserDefaults.standard.stringArray(forKey: "\(CashListType.Type1)"){
                aType = "\(type1[infoFromViewOne!])"
            }
            if let type2 = UserDefaults.standard.stringArray(forKey: "\(CashListType.Type2)"){
                bType = "\(type2[infoFromViewOne!])"
            }
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

