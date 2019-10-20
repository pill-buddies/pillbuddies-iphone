//
//  BaseViewController.swift
//  PillBuddies
//
//  Created by William Harvey on 2019-09-16.
//  Copyright © 2019 Pill Buddies. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class BaseViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var managedContext: NSManagedObjectContext;
    var medicationsEntity: NSEntityDescription;
    var schedulesEntity: NSEntityDescription;

    // This extends the superclass.
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.managedContext = appDelegate.persistentContainer.viewContext
        self.medicationsEntity = NSEntityDescription.entity(forEntityName: "Medications", in: managedContext)!
        self.schedulesEntity = NSEntityDescription.entity(forEntityName: "Schedules", in: managedContext)!
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    func request(entity: String, uid: String?, sortBy: String?) -> [NSManagedObject] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        if (uid != nil) {
            let filter = "uid"
            let predicate = NSPredicate(format: "type = %@", filter)
            request.predicate = predicate
        }
        if (sortBy != nil) {
            let sort = NSSortDescriptor(key: sortBy, ascending: true)
            request.sortDescriptors = [sort]
        }
        request.returnsObjectsAsFaults = false
        do {
            let result = try managedContext.fetch(request) as! [NSManagedObject]
            return result;
        } catch {
            fatalError("Failed")
        }
    }

    func request(entity: String) -> [NSManagedObject] {
        return request(entity: entity, uid: nil, sortBy: nil)
    }
    func request(entity: String, sortBy: String) -> [NSManagedObject] {
        return request(entity: entity, uid: nil, sortBy: sortBy)
    }
    func request(entity: String, uid: String) -> [NSManagedObject] {
        return request(entity: entity, uid: uid, sortBy: nil)
    }

    func save() {
        do {
           try managedContext.save()
          } catch {
           print("Failed saving")
        }
    }

    // This is also necessary when extending the superclass.
    required init?(coder aDecoder: NSCoder) {
        self.managedContext = appDelegate.persistentContainer.viewContext
        self.medicationsEntity = NSEntityDescription.entity(forEntityName: "Medications", in: managedContext)!
        self.schedulesEntity = NSEntityDescription.entity(forEntityName: "Schedules", in: managedContext)!
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        (navigationController?.tabBarController as! TabBarController).dashButtonAction(sender: sender)
    }
}
