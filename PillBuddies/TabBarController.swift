//
//  TabBarController.swift
//  PillBuddies
//
//  Created by William Harvey on 7/14/19.
//  Copyright © 2019 Pill Buddies. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    @IBInspectable var defaultIndex: Int = 0

    let dashButton = UIButton.init(type: .custom)
    let selectedColor = UIColor(hexString: "#FF7F00")
    let unselectedColor = UIColor(hexString: "#28275A")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        selectedIndex = defaultIndex
        
        dashButton.backgroundColor = UIColor(hexString: "#DADAEA")
        dashButton.layer.cornerRadius = 32
        let image = UIImage(named: "pill-100")?.withRenderingMode(.alwaysTemplate)
        dashButton.setImage(image, for: .normal)
        if (defaultIndex == 1) {
            dashButton.tintColor = selectedColor
        }
        else {
            dashButton.tintColor = unselectedColor
        }
        dashButton.addTarget(self, action: #selector(dashButtonAction), for: .touchUpInside)
        self.view.insertSubview(dashButton, aboveSubview: self.tabBar)
    }

    @objc func dashButtonAction(sender: UIButton!) {
        selectedIndex = 1 // Center index
        dashButton.tintColor = selectedColor
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController)!
        if selectedIndex != 1 {
            dashButton.tintColor = unselectedColor
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let inset = getInset()
        
        dashButton.frame = CGRect.init(x: self.tabBar.center.x - 32, y: self.view.bounds.height - 64 - inset, width: 64, height: 64)
    }

    func getInset() -> CGFloat {
        switch UIScreen.main.scale {
        case 1,
             2:
            return 16
        case 3:
            return 48
        default:
            return 48
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

