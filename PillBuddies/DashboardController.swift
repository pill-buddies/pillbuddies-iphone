//
//  DashboardController.swift
//  PillBuddies
//
//  Created by William Harvey on 11/9/19.
//  Copyright © 2019 Pill Buddies. All rights reserved.
//

import UIKit
import DesignSystem
import CoreData

class DashboardController: BaseViewController {
    @IBOutlet weak var currentStack: UIStackView!
    @IBOutlet weak var upcomingStack: UIStackView!
    @IBOutlet weak var completedStack: UIStackView!
    var timer = Timer()
    
    // NSCalendar units for repetition https://stackoverflow.com/a/42569084/6301806
    override func viewDidLoad() {
        super.viewDidLoad()
        currentStack.translatesAutoresizingMaskIntoConstraints = false;
        //UIScreen.main.bounds.size.width
        
        var schedules = self.request(entity: "Schedules", sortBy: "occurance");
        if (schedules.count == 0) {
            createTestSchedules()
            schedules = self.request(entity: "Schedules", sortBy: "occurance");
        }
        setUpScheduleCards(schedules: schedules)
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(DashboardController.update), userInfo: nil, repeats: true)
    }
    
    // MARK: - Set up cards
    
    func setUpScheduleCards(schedules: [NSManagedObject]) {
        for databaseSchedule in schedules as! [Schedules] {
            var testSchedule = databaseSchedule.copyProperties() as! Schedules
            testSchedule.medication = databaseSchedule.medication!.copyProperties() as? Medications
            testSchedule.logs = databaseSchedule.logs
            let n = Int(databaseSchedule.repetitionCount)
            let u = Date.getUnitByIndex(index: databaseSchedule.repetitionUnit)
            
            var cardSchedules: [Schedules] = [];
            while(testSchedule.occurance! < Date.tomorrow) {
                cardSchedules.append(testSchedule);
                testSchedule = testSchedule.copyProperties() as! Schedules
                testSchedule.medication = databaseSchedule.medication!.copyProperties() as? Medications
                testSchedule.logs = databaseSchedule.logs
                testSchedule.occurance = testSchedule.occurance!.addUnit(n: n, u: u)
            }
            
            for schedule in cardSchedules {
                let new = DrugCard(frame: CGRect(x: 0, y: 0, width: currentStack.frame.width, height: 72))
                new.drugName.text = schedule.medication!.name
                new.drugTime.text = schedule.occurance!.toString()
                
                
                // MARK: Select stack and colour
                let calendar = Calendar.current
                let currentDate = calendar.date(byAdding: .minute, value: 10, to: Date())
                let logs = schedule.logs!.allObjects as! [Logs]
                let currentLog = logs.filter { $0.due == schedule.occurance }
                if (currentLog.count > 0) {
                    // Completed
                    new.lateLabel.isHidden = true
                    new.drugCard.backgroundColor = DesignColours.grey
                    currentStack.addArrangedSubview(new)
                }
                else if (schedule.occurance! < currentDate!) {
                    // Current
                    if (schedule.occurance! < Date()) {
                        new.lateLabel.isHidden = false
                    }
                    else {
                        new.lateLabel.isHidden = true
                    }
                    new.drugCard.backgroundColor = .white
                    currentStack.addArrangedSubview(new)
                }
                else {
                    // Upcoming
                    new.lateLabel.isHidden = true
                    new.drugCard.backgroundColor = .white
                    upcomingStack.addArrangedSubview(new)
                }
                
                new.stretchToSuperView()
            }
        }
    }
    
    //MARK: - For testing
    func deleteAll(objects: [NSManagedObject]) {
        print(objects)
        for object in objects {
            self.managedContext.delete(object)
        }
        save()
    }
    
    func createTestSchedules() {
        // Insert for testing
        let medications = self.request(entity: "Medications");
        var newMedication: Medications;
        if(medications.count == 0) {
            newMedication = Medications(context: self.managedContext)
            let medicationUid = UUID().uuidString
            newMedication.uid = medicationUid
            newMedication.name = "Test Medication"
            newMedication.dosage = "10mg"
        }
        else {
            newMedication = medications[0] as! Medications
        }

        let firstSchedule = Schedules(context: self.managedContext)
        firstSchedule.uid = UUID().uuidString
        //8 am
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        components.hour = 8
        components.minute = 0
        components.second = 0
        let time = calendar.date(from: components)
        firstSchedule.occurance = time
        //12 hours
        firstSchedule.repetitionCount = 12
        firstSchedule.repetitionUnit = Date.getIndexByUnit(unit: .hour)
        firstSchedule.medication = newMedication

//        let secondSchedule = Schedules(context: self.managedContext)
//        secondSchedule.uid = UUID().uuidString
//        //8 pm
//
//        var secondComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
//        secondComponents.hour = 20
//        secondComponents.minute = 0
//        secondComponents.second = 0
//        let secondTime = calendar.date(from: secondComponents)
//        secondSchedule.occurance = secondTime
//        //1 day
//        secondSchedule.repetitionCount = 1
//        secondSchedule.repetitionUnit = Date.getIndexByUnit(unit: .day)
//        secondSchedule.medication = newMedication
        save()
    }

    @objc func update() {
        print("regenerate")
        currentStack.removeAllArrangedSubviewsExceptFirst()
        upcomingStack.removeAllArrangedSubviewsExceptFirst()
        completedStack.removeAllArrangedSubviewsExceptFirst()
        let schedules = self.request(entity: "Schedules", sortBy: "occurance");
        setUpScheduleCards(schedules: schedules)
    }
}

