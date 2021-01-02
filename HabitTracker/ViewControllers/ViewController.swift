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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if calendar == nil {
            print("poop")
        } else {
            calendar.delegate = self
            calendar.allowsMultipleSelection = true
            calendar.today = nil
            counter.center = self.view.center
            counter.textAlignment = .center
            counter.text = String(count)
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        count += 1
        counter.text = String(count)
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        count -= 1
        counter.text = String(count)
    }
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        
        if CalendarViewController.isToday(selected: date) {
            return true
        } else {
            return false
        }
    }
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        if CalendarViewController.isToday(selected: date) {
            return true
        } else {
            return false
        }
    }
    /*/
    func calendar(_ calendar:FSCalendar, imageFor date: Date) -> UIImage? {
        
    }*/
    static func isToday(selected date: Date) -> Bool {
        let today = Date()
        var todayComponents = Calendar.current.dateComponents([Calendar.Component.month, Calendar.Component.year, Calendar.Component.day], from: today)
        var selectedComponents = Calendar.current.dateComponents([Calendar.Component.month, Calendar.Component.year, Calendar.Component.day], from: date)
        if (todayComponents.month! == selectedComponents.month!
                && todayComponents.day! == selectedComponents.day!
                && todayComponents.year! == selectedComponents.year!) {
            return true
        }
        return false
    }



}

