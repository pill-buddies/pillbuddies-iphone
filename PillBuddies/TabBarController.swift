//
//  TabBarController.swift
//  PillBuddies
//
//  Created by William Harvey on 7/14/19.
//  Copyright © 2019 Pill Buddies. All rights reserved.
//

import UIKit
import SVGKit
import DesignSystem

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    @IBInspectable var defaultIndex: Int = 0

    let dashIndex = 2
    let dashButton = UIButton.init(type: .custom)
    let selectedColor = DesignColours.orange
    let unselectedColor = DesignColours.purple
    let dashItemDimension = 36
    let itemDimension = 28

    let searchImage = "search"
    let medicationsImage = "format_list_bulleted"
    let dashImage = "pill-v5"
    let historyImage = "graph-v2"
    let recommendationsImage = "lightbulb_outline"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        selectedIndex = defaultIndex

        dashButton.backgroundColor = DesignColours.lightBlue
        dashButton.layer.cornerRadius = 32
        let svgImage = SVGKImage(named: dashImage)
        svgImage.size = CGSize(width: dashItemDimension, height: dashItemDimension)
        let image = svgImage.uiImage.withRenderingMode(.alwaysTemplate)
        dashButton.setImage(image, for: .normal)
        if (defaultIndex == dashIndex) {
            dashButton.tintColor = selectedColor
        }
        else {
            dashButton.tintColor = unselectedColor
        }
        dashButton.addTarget(self, action: #selector(dashButtonAction), for: .touchUpInside)
        self.view.insertSubview(dashButton, aboveSubview: self.tabBar)

        setupTabBarItems()
    }

    func setupTabBarItems() {
        let myTabBarItem1 = (self.tabBar.items?[0])! as UITabBarItem
        let svgImage1 = SVGKImage(named: searchImage)
        svgImage1.size = CGSize(width: itemDimension, height: itemDimension)
        myTabBarItem1.image = svgImage1.uiImage.withRenderingMode(.alwaysTemplate)
        myTabBarItem1.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

        let myTabBarItem2 = (self.tabBar.items?[1])! as UITabBarItem
        let svgImage2 = SVGKImage(named: medicationsImage)
        svgImage2.size = CGSize(width: itemDimension, height: itemDimension)
        myTabBarItem2.image = svgImage2.uiImage.withRenderingMode(.alwaysTemplate)
        myTabBarItem2.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

        let myTabBarItem3 = (self.tabBar.items?[3])! as UITabBarItem
        let svgImage3 = SVGKImage(named: historyImage)
        svgImage3.size = CGSize(width: itemDimension, height: itemDimension)
        myTabBarItem3.image = svgImage3.uiImage.withRenderingMode(.alwaysTemplate)
        myTabBarItem3.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

        let myTabBarItem4 = (self.tabBar.items?[4])! as UITabBarItem
        let svgImage4 = SVGKImage(named: recommendationsImage)
        svgImage4.size = CGSize(width: itemDimension, height: itemDimension)
        myTabBarItem4.image = svgImage4.uiImage.withRenderingMode(.alwaysTemplate)
        myTabBarItem4.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
    }

    @objc func dashButtonAction(sender: UIButton!) {
        selectedIndex = dashIndex // Center index
        dashButton.tintColor = selectedColor
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController)!
        if selectedIndex != dashIndex {
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
            return 8
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

