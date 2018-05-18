//
//  NewViewController.swift
//  CashList
//
//  Created by fox on 2018/5/10.
//  Copyright © 2018年 fox. All rights reserved.
//

import UIKit
import CoreData

class NewViewController: UIViewController {
    // Adjust Color of StatusBar
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    @IBOutlet weak var totalIncome: UILabel!
    
    @IBOutlet weak var totalExpense: UILabel!
    
    @IBOutlet weak var totalEarning: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        print("=======我是分隔線=======")
        // select
        let selectResult = coreDataConnect.retrieve(myEntityName, predicate: nil, sort: [["id":true]], limit: nil)
        
        var income:Double = 0
        
        var expense:Double = 0
        
        if let results = selectResult {
            for result in results {
                if "\(result.value(forKey: "type1")!)" == "收入"{
                    
                    if let cash:String = result.value(forKey: "price") as? String{
                        income += Double(cash)!
                    }
                    
                }else{
                    
                    if let cash:String = result.value(forKey: "price") as? String{
                        expense += Double(cash)!
                    }
                }
            }
            
            totalIncome.text = "\(income)"
            totalExpense.text = "\(expense)"
            totalEarning.text = "\(income - expense)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
