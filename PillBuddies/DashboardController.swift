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
import UserNotifications

class DashboardController: BaseViewController {
    @IBOutlet weak var currentStack: UIStackView!
    @IBOutlet weak var upcomingStack: UIStackView!
    @IBOutlet weak var completedStack: UIStackView!
    var timer = Timer()
    var cardSchedules: [Schedules] = []
    
    // MARK: - viewDidLoad
    // NSCalendar units for repetition https://stackoverflow.com/a/42569084/6301806
    override func viewDidLoad() {
        super.viewDidLoad()
        currentStack.translatesAutoresizingMaskIntoConstraints = false;

        var schedules = self.request(entity: "Schedules", sortBy: "occurance");
        if (schedules.count == 0) {
            createTestSchedules()
            schedules = self.request(entity: "Schedules", sortBy: "occurance");
        }
        setUpScheduleCards(schedules: schedules)
        timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(DashboardController.update), userInfo: nil, repeats: true)
    }
    
    //MARK: - Logging Drugs
    @objc func drugLogFunction(_ sender: UIButton) {
        let schedule = cardSchedules[sender.tag]
        let databaseSchedule = self.request(entity: "Schedules", uid: schedule.uid!)[0] as! Schedules
        let newLog = Logs(context: self.managedContext)
        newLog.uid = UUID().uuidString
        newLog.occurance = Date()
        newLog.due = schedule.occurance
        let n = Int(databaseSchedule.repetitionCount)
        let u = Date.getUnitByIndex(index: databaseSchedule.repetitionUnit)
        databaseSchedule.occurance = databaseSchedule.occurance!.addUnit(n: n, u: u)
        newLog.schedule = databaseSchedule
        save()
        update()
    }

    // MARK: - Set up cards
    func setUpScheduleCards(schedules: [NSManagedObject]) {
        cardSchedules = [];
        for databaseSchedule in schedules as! [Schedules] {
            var testSchedule = databaseSchedule.copyProperties() as! Schedules
            testSchedule.medication = databaseSchedule.medication!.copyProperties() as? Medications
            testSchedule.logSet = databaseSchedule.logs

            let logObjects = databaseSchedule.logs!.allObjects as! [Logs]
            let loggedToday = logObjects.filter { $0.occurance! > Date.today && $0.occurance! < Date.tomorrow }.count
            let n = Int(databaseSchedule.repetitionCount)
            let u = Date.getUnitByIndex(index: databaseSchedule.repetitionUnit)

            for _ in 0..<loggedToday {
                testSchedule.occurance = testSchedule.occurance!.addUnit(n: -n, u: u)
            }

            while(testSchedule.occurance! < Date.tomorrow) {
                if(testSchedule.occurance! > Date.today) {
                    cardSchedules.append(testSchedule)
                }
                testSchedule = testSchedule.copyProperties() as! Schedules
                testSchedule.medication = databaseSchedule.medication!.copyProperties() as? Medications
                testSchedule.logSet = databaseSchedule.logs
                testSchedule.occurance = testSchedule.occurance!.addUnit(n: n, u: u)
            }
           
            
        }

        for (index, schedule) in cardSchedules.enumerated(){
            let new = DrugCard(frame: CGRect(x: 0, y: 0, width: currentStack.frame.width, height: 72))
            new.drugName.text = schedule.medication!.name
            new.drugTime.text = schedule.occurance!.toString()
            let countdown = schedule.occurance!.timeIntervalSinceNow
            new.countdownLabel.text = countdown.toShortString()
            new.logButton.tag = index
            new.logButton.addTarget(self, action: #selector(drugLogFunction(_:)), for: .touchUpInside)
            new.lateLabel.isHidden = true
            new.logButton.isHidden = true
            new.countdownLabel.isHidden = true
            new.doneImage.isHidden = true

            // MARK: Select stack and colour
            let calendar = Calendar.current
            let currentDate = calendar.date(byAdding: .minute, value: 10, to: Date())!
            let lateDate = calendar.date(byAdding: .minute, value: -10, to: Date())!
            let logs = schedule.logSet!.allObjects as! [Logs]
            let currentLog = logs.filter { $0.due == schedule.occurance }
            if (currentLog.count > 0) {
                // Completed
                new.doneImage.isHidden = false
                new.drugCard.backgroundColor = DesignColours.grey
                completedStack.addArrangedSubview(new)
            }
            else if (currentDate >= schedule.occurance!) {
                // Current
                new.logButton.isHidden = false
                if (lateDate >= schedule.occurance!) {
                    new.lateLabel.isHidden = false
                }
                new.drugCard.backgroundColor = .white
                currentStack.addArrangedSubview(new)
            }
            else {
                // Upcoming
                new.countdownLabel.isHidden = false
                new.drugCard.backgroundColor = .white
                upcomingStack.addArrangedSubview(new)
            }

            new.stretchToSuperView()
        }
    }
    
    //MARK: - For testing
    func deleteAll(objects: [NSManagedObject]) {
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
        var firstComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        firstComponents.hour = 8
        firstComponents.minute = 0
        firstComponents.second = 0
        let time = calendar.date(from: firstComponents)
        firstSchedule.occurance = time
        //1 day
        firstSchedule.repetitionCount = 1
        firstSchedule.repetitionUnit = Date.getIndexByUnit(unit: .day)
        firstSchedule.medication = newMedication

        let notificationCenter = UNUserNotificationCenter.current()
        
        let firstTrigger = UNCalendarNotificationTrigger(dateMatching: firstComponents, repeats: true)
        let firstContent = UNMutableNotificationContent()
        firstContent.title = "Dose due: " + firstSchedule.medication!.name! + " " + firstSchedule.medication!.dosage!
        var firstRepetition = "Daily"
        switch firstSchedule.repetitionUnit {
        case 0: firstRepetition = "Yearly"
        case 1: firstRepetition = "Monthly"
        case 2: firstRepetition = "Daily"
        case 3: firstRepetition = "Hourly"
        case 4: firstRepetition = "Minutely"
        case 5: firstRepetition = "Secondly"
        default: firstRepetition = "Daily"
        }
        firstContent.body = firstRepetition + " at " + (firstSchedule.occurance?.toString())!
        firstContent.sound = UNNotificationSound.default
        firstContent.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
        
        let firstNotificationId = "notification.schedule." + firstSchedule.uid!
        let firstRequest = UNNotificationRequest(identifier: firstNotificationId, content: firstContent, trigger: firstTrigger)
        // Schedule the request with the system.
        
        notificationCenter.add(firstRequest) { (error) in
           if error != nil {
              // Handle any errors.
           }
        }
        
        let secondSchedule = Schedules(context: self.managedContext)
        secondSchedule.uid = UUID().uuidString
        //8 pm

        var secondComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        secondComponents.hour = 20
        secondComponents.minute = 0
        secondComponents.second = 0
        let secondTime = calendar.date(from: secondComponents)
        secondSchedule.occurance = secondTime
        //1 day
        secondSchedule.repetitionCount = 1
        secondSchedule.repetitionUnit = Date.getIndexByUnit(unit: .day)
        secondSchedule.medication = newMedication
        
        let secondTrigger = UNCalendarNotificationTrigger(dateMatching: secondComponents, repeats: true)
        let secondContent = UNMutableNotificationContent()
        secondContent.title = "Dose due: " + secondSchedule.medication!.name! + " " + secondSchedule.medication!.dosage!
        var secondRepetition = "Daily"
        switch secondSchedule.repetitionUnit {
        case 0: secondRepetition = "Yearly"
        case 1: secondRepetition = "Monthly"
        case 2: secondRepetition = "Daily"
        case 3: secondRepetition = "Hourly"
        case 4: secondRepetition = "Minutely"
        case 5: secondRepetition = "Secondly"
        default: secondRepetition = "Daily"
        }
        secondContent.body = secondRepetition + " at " + (secondSchedule.occurance?.toString())!
        secondContent.sound = UNNotificationSound.default
        secondContent.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
        
        let secondNotificationId = "notification.schedule." + secondSchedule.uid!
        let secondRequest = UNNotificationRequest(identifier: secondNotificationId, content: secondContent, trigger: secondTrigger)
        // Schedule the request with the system.
        
        notificationCenter.add(secondRequest) { (error) in
           if error != nil {
              // Handle any errors.
           }
        }
        
        save()
    }

    // MARK: - Update Function
    @objc func update() {
        currentStack.removeAllArrangedSubviewsExceptFirst()
        upcomingStack.removeAllArrangedSubviewsExceptFirst()
        completedStack.removeAllArrangedSubviewsExceptFirst()
        let schedules = self.request(entity: "Schedules", sortBy: "occurance");
        setUpScheduleCards(schedules: schedules)
    }
}

