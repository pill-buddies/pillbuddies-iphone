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
        setUpNavBar()
    }
    
    func setUpNavBar() {
        let button  = UIButton(type: .custom)
        let normalText  = "Pill"
        let normalFont = UIFont(name: "Roboto-Medium", size: 22)
        let normalAttributes = [NSAttributedString.Key.font: normalFont, NSAttributedString.Key.foregroundColor: UIColor.white]
        let attributedString = NSMutableAttributedString(string: normalText, attributes: normalAttributes as [NSAttributedString.Key : Any])
        let lightText = "Pals"
        let lightFont = UIFont(name: "Roboto-Light", size: 22)
        let lightAttributes = [NSAttributedString.Key.font: lightFont, NSAttributedString.Key.foregroundColor: UIColor.white]
        let lightString = NSMutableAttributedString(string: lightText, attributes: lightAttributes as [NSAttributedString.Key : Any])
        attributedString.append(lightString)
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(logoItemAction), for: .touchUpInside)
        let logoItem = UIBarButtonItem.init(customView: button)
        let widthConstraint = button.widthAnchor.constraint(equalToConstant: 80)
        let heightConstraint = button.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        navigationItem.leftBarButtonItem = logoItem
    }
    
    @objc func logoItemAction(sender: UIButton!) {
        selectedIndex = 1 // Center index
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

