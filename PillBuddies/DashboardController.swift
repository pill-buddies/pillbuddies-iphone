//
//  DashboardController.swift
//  PillBuddies
//
//  Created by William Harvey on 11/9/19.
//  Copyright © 2019 Pill Buddies. All rights reserved.
//

import UIKit
import DesignSystem

class DashboardController: BaseViewController {
    @IBOutlet weak var currentStack: UIStackView!
    @IBOutlet weak var upcomingStack: UIStackView!
    @IBOutlet weak var completedStack: UIStackView!
    
    // NSCalendar units for repetition https://stackoverflow.com/a/42569084/6301806
    override func viewDidLoad() {
        super.viewDidLoad()
        currentStack.translatesAutoresizingMaskIntoConstraints = false;
        //UIScreen.main.bounds.size.width
        let new = DrugCard(frame: CGRect(x: 0, y: 0, width: currentStack.frame.width, height: 72))
        new.drugName.text = "Meme Drug"
        currentStack.addArrangedSubview(new)
        new.stretchToSuperView()
        
        let new2 = DrugCard(frame: CGRect(x: 0, y: 0, width: currentStack.frame.width, height: 72))
        new2.drugName.text = "Cream Drug"
        currentStack.addArrangedSubview(new2)
        new2.stretchToSuperView()
        
        //currentStack.frame = CGRect(x: currentStack.frame.minX, y: currentStack.frame.minY, width: currentStack.frame.width, height: currentStack.frame.height + 72)
        print(currentStack.frame)
        print(currentStack.arrangedSubviews)
        currentStack.layoutSubviews()
        
        print(NSCalendar.Unit.month)
    }
    

}

