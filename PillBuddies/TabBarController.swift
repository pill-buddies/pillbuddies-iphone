//
//  TabBarController.swift
//  PillBuddies
//
//  Created by William Harvey on 7/14/19.
//  Copyright © 2019 Pill Buddies. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    @IBInspectable var defaultIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = defaultIndex
    }
}

