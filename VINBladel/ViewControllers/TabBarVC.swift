//
//  TabBarVC.swift
//  VIN-Bladel
//
//  Created by Alisha Fong on 3/2/18.
//  Copyright © 2018 John Hersey High School. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewWillLayoutSubviews() {
        var customTabFrame = self.tabBarController?.tabBar.frame
        customTabFrame?.size.height = CGFloat(80)
        customTabFrame?.origin.y = self.view.frame.size.height - CGFloat(80)
        self.tabBarController?.tabBar.frame = customTabFrame!
        tabBarController?.tabBar.barStyle = .black
        tabBarController?.tabBar.tintColor = .white
        
    }
}
