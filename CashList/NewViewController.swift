//
//  NewViewController.swift
//  CashList
//
//  Created by fox on 2018/5/10.
//  Copyright © 2018年 fox. All rights reserved.
//

import UIKit
import Charts


class NewViewController: UIViewController {
    
    @IBOutlet weak var ViewContainer: UIView!
    
    @IBOutlet weak var mySegmentController: UISegmentedControl!
    
    var views: [UIView]!
    
    let buttonBar = UIView()
    
    override func viewWillAppear(_ animated: Bool) {
        print("=======我是分隔線=======")
        views = [UIView]()
        views.append(SimpleVC1().view)
        views.append(SimpleVC2().view)
        for v in views{
            ViewContainer.addSubview(v)
        }
        ViewContainer.bringSubview(toFront: views[0])
        
        mySegmentController.selectedSegmentIndex = 0
        mySegmentController.backgroundColor = .clear
        mySegmentController.tintColor = .clear
        
        mySegmentController.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont(name: "DINCondensed-Bold", size: 18)!,
            NSAttributedStringKey.foregroundColor: UIColor.lightGray
            ], for: .normal)
        
        mySegmentController.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont(name: "DINCondensed-Bold", size: 18)!,
            NSAttributedStringKey.foregroundColor: UIColor.orange
            ], for: .selected)
        
        buttonBar.translatesAutoresizingMaskIntoConstraints = false
        
        buttonBar.backgroundColor = UIColor.orange
        
        view.addSubview(buttonBar)
        
        buttonBar.topAnchor.constraint(equalTo: mySegmentController.bottomAnchor).isActive = true
        buttonBar.heightAnchor.constraint(equalToConstant: 5).isActive = true
        
        buttonBar.leftAnchor.constraint(equalTo: mySegmentController.leftAnchor).isActive = true
        
        buttonBar.widthAnchor.constraint(equalTo: mySegmentController.widthAnchor, multiplier: 1 / CGFloat(mySegmentController.numberOfSegments)).isActive = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func myToggleChange(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        
        UIView.animate(withDuration: 0.3) {
            self.buttonBar.frame.origin.x = (sender.frame.width / CGFloat(sender.numberOfSegments)) * CGFloat(sender.selectedSegmentIndex)
        }
        self.ViewContainer.bringSubview(toFront: views[index])
        
    }
    
}
