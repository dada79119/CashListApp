//
//  FirstViewController.swift
//  CashListApp
//
//  Created by fox on 2018/5/4.
//  Copyright © 2018年 fox. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("=======我是分隔線=======")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        /*
         cell.imageView?.image = UIImage(named: "Add")
         if type1[indexPath.row] == "收入"{
         cell.textLabel?.textColor = .orange
         }else{
         cell.textLabel?.textColor = .red
         }
         cell.accessoryType = .detailButton
         cell.textLabel?.font = UIFont(name: "arial", size: 24)
         cell.textLabel?.text = cash[indexPath.row]
         cell.detailTextLabel?.text = datetime[indexPath.row]
         
         */
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
        if let secondViewController = tabBarController?.viewControllers?[1] as? SecondViewController{
            secondViewController.infoFromViewOne = indexPath.row
        }
        // 選擇編號1 的viewControlloer
        tabBarController?.selectedIndex = 1
    }
    
    
}

