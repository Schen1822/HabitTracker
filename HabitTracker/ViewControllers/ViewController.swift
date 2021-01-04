//
//  CalendarViewController.swift
//  HabitTracker
//
//  Created by Steven C on 12/31/20.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {

    @IBOutlet var calendar: FSCalendar!
    @IBOutlet var counter: UILabel!
    
    var count = 0
    
    init(title:String?) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if calendar == nil {
            print("poop")
        } else {
            self.navigationItem.title = self.title
            calendar.delegate = self
            calendar.allowsMultipleSelection = true
            calendar.today = nil
            counter.center = self.view.center
            counter.textAlignment = .center
            counter.text = String(count)
            initEntry()
        }
    }
    
    func initEntry() {
        let today = Date()
        let todayComponents = CalendarViewController.unpack(date: today)
        if HabitsTableViewController.db.inTable(month: todayComponents.month!, year: todayComponents.year!, from: self.title!) == false {
            HabitsTableViewController.db.insert(month: todayComponents.month!, year: todayComponents.year!, count: 0, into: self.title!)
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        count += 1
        let selected = CalendarViewController.unpack(date: date)
        HabitsTableViewController.db.update(month: selected.month!, year: selected.year!, count: count, into: self.title!)
        counter.text = String(count)
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        count -= 1
        let deselected = CalendarViewController.unpack(date: date)
        HabitsTableViewController.db.update(month: deselected.month!, year: deselected.year!, count: count, into: self.title!)
        counter.text = String(count)
    }
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return true
        /*
        if CalendarViewController.isToday(selected: date) {
            return true
        } else {
            return false
        }*/
    }
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        if CalendarViewController.isToday(selected: date) {
            return true
        } else {
            return false
        }
    }
    static func isToday(selected date: Date) -> Bool {
        let today = Date()
        let todayComponents = Calendar.current.dateComponents([Calendar.Component.month, Calendar.Component.year, Calendar.Component.day], from: today)
        let selectedComponents = Calendar.current.dateComponents([Calendar.Component.month, Calendar.Component.year, Calendar.Component.day], from: date)
        if (todayComponents.month! == selectedComponents.month!
                && todayComponents.day! == selectedComponents.day!
                && todayComponents.year! == selectedComponents.year!) {
            return true
        }
        return false
    }
    
    static func unpack(date: Date) -> DateComponents {
        return Calendar.current.dateComponents([Calendar.Component.month, Calendar.Component.year, Calendar.Component.day], from: date)
    }
}

