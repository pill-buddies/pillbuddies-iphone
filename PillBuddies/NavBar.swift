//
//  NavBar.swift
//  PillBuddies
//
//  Created by William Harvey on 2019-09-13.
//  Copyright © 2019 Pill Buddies. All rights reserved.
//

import Foundation
import UIKit

class NavBar: UINavigationBar {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setUpUI()
    }
    
    func setUpUI() {
        //        let logoImage = UIImage.init(named: named)
        //        let logoImageView = UIImageView.init(image: logoImage)
        let frame = CGRect(x:0.0,y:0.0, width:60,height:25.0)
        let logoTextView = UILabel.init(frame: frame)
        logoTextView.textAlignment = NSTextAlignment.left
        logoTextView.text = "PillPals"
        // logoImageView.frame = CGRect(x:0.0,y:0.0, width:60,height:25.0)
        let logoItem = UIBarButtonItem.init(customView: logoTextView)
        let widthConstraint = logoTextView.widthAnchor.constraint(equalToConstant: 60)
        let heightConstraint = logoTextView.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        navigationItem.leftBarButtonItem =  logoItem
    }
}

