//
//  DismissSegue.swift
//  PillBuddies
//
//  Created by William Harvey on 2019-09-20.
//  Copyright © 2019 Pill Buddies. All rights reserved.
//

import UIKit

class DismissSegue: UIStoryboardSegue {
    override func perform() {
        self.source.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
