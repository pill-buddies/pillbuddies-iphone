//
//  BaseViewController.swift
//  PillBuddies
//
//  Created by William Harvey on 2019-09-16.
//  Copyright © 2019 Pill Buddies. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setUpNavBar()
    }
    
    func setUpNavBar() {
        setUpLeftNavBar()
        
    }
    
    func setUpLeftNavBar() {
        let logoButton  = UIButton(type: .custom)
        let normalText  = "Pill"
        let normalFont = UIFont(name: "Roboto-Medium", size: 22)
        let normalAttributes = [NSAttributedString.Key.font: normalFont, NSAttributedString.Key.foregroundColor: UIColor.white]
        let attributedString = NSMutableAttributedString(string: normalText, attributes: normalAttributes as [NSAttributedString.Key : Any])
        let lightText = "Pals"
        let lightFont = UIFont(name: "Roboto-Light", size: 22)
        let lightAttributes = [NSAttributedString.Key.font: lightFont, NSAttributedString.Key.foregroundColor: UIColor.white]
        let lightString = NSMutableAttributedString(string: lightText, attributes: lightAttributes as [NSAttributedString.Key : Any])
        attributedString.append(lightString)
        logoButton.setAttributedTitle(attributedString, for: .normal)
        logoButton.addTarget(self, action: #selector(logoItemAction), for: .touchUpInside)
        let logoItem = UIBarButtonItem.init(customView: logoButton)
        let widthConstraint = logoButton.widthAnchor.constraint(equalToConstant: 80)
        let heightConstraint = logoButton.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        navigationItem.leftBarButtonItems = [logoItem]
    }
    
    @objc func logoItemAction(sender: UIButton!) {
        navigationController?.tabBarController?.selectedIndex = 1 // Center index
    }
}
