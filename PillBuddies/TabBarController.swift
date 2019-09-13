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
        let frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 25.0)
        let logoTextView = UILabel.init(frame: frame)
        logoTextView.textAlignment = NSTextAlignment.left

        let normalText  = "Pill"
        let normalFont = UIFont(name: "Roboto-Medium", size: 22)
        let normalAttributes = [NSAttributedString.Key.font: normalFont]
        let attributedString = NSMutableAttributedString(string: normalText, attributes: normalAttributes as [NSAttributedString.Key : Any])
        let lightText = "Pals"
        let lightFont = UIFont(name: "Roboto-Light", size: 22)
        let lightAttributes = [NSAttributedString.Key.font: lightFont]
        let lightString = NSMutableAttributedString(string: lightText, attributes: lightAttributes as [NSAttributedString.Key : Any])
        attributedString.append(lightString)

        logoTextView.attributedText = attributedString
        logoTextView.textColor = .white
        let logoItem = UIBarButtonItem.init(customView: logoTextView)
        let widthConstraint = logoTextView.widthAnchor.constraint(equalToConstant: 80)
        let heightConstraint = logoTextView.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        navigationItem.leftBarButtonItem =  logoItem
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

