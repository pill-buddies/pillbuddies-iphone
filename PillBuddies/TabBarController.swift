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

    let dashButton = UIButton.init(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = defaultIndex
        
        dashButton.backgroundColor = UIColor(hexString: "#DADAEA")
        dashButton.layer.cornerRadius = 32
        // let image = UIImage(named: "image_name") as UIImage?
        // dashButton.setImage(image, for: .normal)
        dashButton.addTarget(self, action: #selector(dashButtonAction), for: .touchUpInside)
        self.view.insertSubview(dashButton, aboveSubview: self.tabBar)
    }

    @objc func dashButtonAction(sender: UIButton!) {
        selectedIndex = 1 // Center index
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        dashButton.frame = CGRect.init(x: self.tabBar.center.x - 32, y: self.view.bounds.height - 64 - 32, width: 64, height: 64)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

