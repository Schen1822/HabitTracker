//
//  CalendarViewController.swift
//  HabitTracker
//
//  Created by Steven C on 12/31/20.
//

import UIKit
import FSCalendar

extension FSCalendar: UIScrollViewDelegate {
public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    (delegate as? ExtendedFSCalendarDelegate)?.didEndDecelerating(calendar: self)
    }
}

protocol ExtendedFSCalendarDelegate: FSCalendarDelegate {
    func didEndDecelerating(calendar: FSCalendar)
}

extension ExtendedFSCalendarDelegate {
    func didEndDecelerating(calendar: FSCalendar) { }
}

class CalendarViewController: UIViewController, ExtendedFSCalendarDelegate, FSCalendarDataSource {

    @IBOutlet var calendar: FSCalendar!
    @IBOutlet var counter: UILabel!
    
    var count: Int = 0
    var dates: [Date] = []
    
    init(title:String?) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("dataStuff")

    override func viewDidLoad() {
        super.viewDidLoad()
        if calendar == nil {
            print("poop")
        } else {
            self.navigationItem.title = self.title
            self.view.backgroundColor = UIColor(red: 175.0/255.0, green: 150/255.0, blue: 100.0/255.0, alpha: 1)
            calendar.backgroundColor = UIColor(red: 226.0/255.0, green: 214/255.0, blue: 191/255.0, alpha: 1)
            calendar.appearance.headerTitleColor = UIColor(red: 120.0/255.0, green: 100/255.0, blue: 66.0/255.0, alpha: 1)
            calendar.appearance.weekdayTextColor = UIColor(red: 57/255.0, green: 42/255.0, blue: 19/255.0, alpha: 1)
            calendar.appearance.titleDefaultColor = UIColor(red: 57/255.0, green: 42/255.0, blue: 19/255.0, alpha: 1)
            calendar.appearance.selectionColor = UIColor(red: 57/255.0, green: 42/255.0, blue: 19/255.0, alpha: 1)
            calendar.delegate = self
            calendar.allowsMultipleSelection = true
            calendar.today = nil
            counter.center = self.view.center
            counter.textAlignment = .center
            getCounter()
            initDates()
            initEntry()
        }
    }

    func initDates() {
        if HabitsTableViewController.datesDict.habitDates[self.title!] != nil {
            print("exist")
            self.dates = HabitsTableViewController.datesDict.habitDates[self.title!]!
            print(self.dates)
            for date in self.dates {
                print(date)
                calendar.select(date)
            }
        } else {
            print("don't exist")
            HabitsTableViewController.datesDict.habitDates[self.title!] = self.dates
        }
    }
    
    func getCounter() {
        let currentPageDate = calendar.currentPage
        let currMonth = Calendar.current.component(.month, from: currentPageDate)
        let currYear = Calendar.current.component(.year, from: currentPageDate)
        count = HabitsTableViewController.db.get(month: currMonth, year: currYear, from: self.title!)
        print(count)
        counter.text = String(count)
    }
    
    func initEntry() {
        let today = Date()
        let todayComponents = CalendarViewController.unpack(date: today)
        if HabitsTableViewController.db.inTable(month: todayComponents.month!, year: todayComponents.year!, from: self.title!) == false {
            HabitsTableViewController.db.insert(month: todayComponents.month!, year: todayComponents.year!, count: 0, into: self.title!)
        }
    }
    
    func didEndDecelerating(calendar: FSCalendar) {
        getCounter()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let selected = CalendarViewController.unpack(date: date)
        let currMonth = Calendar.current.component(.month, from: calendar.currentPage)
        let selectedCount = HabitsTableViewController.db.get(month: selected.month!, year: selected.year!, from: self.title!) + 1
        HabitsTableViewController.db.update(month: selected.month!, year: selected.year!, count: selectedCount, into: self.title!)
        if currMonth == selected.month {
            count = selectedCount
        }
        counter.text = String(count)
        //PERSIST
        dates.append(date)
        HabitsTableViewController.datesDict.habitDates[self.title!] = dates
        HabitsTableViewController.archiver.saveData()
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let deselected = CalendarViewController.unpack(date: date)
        let currMonth = Calendar.current.component(.month, from: calendar.currentPage)
        let deselectedCount = HabitsTableViewController.db.get(month: deselected.month!, year: deselected.year!, from: self.title!) - 1
        HabitsTableViewController.db.update(month: deselected.month!, year: deselected.year!, count: deselectedCount, into: self.title!)
        if currMonth == deselected.month {
            count = deselectedCount
        }
        counter.text = String(count)
        dates = dates.filter() { $0 != date}
        HabitsTableViewController.datesDict.habitDates[self.title!] = dates
        HabitsTableViewController.archiver.saveData()
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        if CalendarViewController.isSelectable(date: date) {
            return true
        } else {
            return false
        }
    }
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        if CalendarViewController.isSelectable(date: date) {
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
    
    static func isSelectable(date: Date) -> Bool {
        let today = Date()
        let todayComponents = Calendar.current.dateComponents([Calendar.Component.month, Calendar.Component.year, Calendar.Component.day], from: today)
        let selectedComponents = Calendar.current.dateComponents([Calendar.Component.month, Calendar.Component.year, Calendar.Component.day], from: date)
        let linearDates = todayComponents.month! >= selectedComponents.month!
            && todayComponents.day! >= selectedComponents.day!
            && todayComponents.year! >= selectedComponents.year!
        let newYear = todayComponents.year! > selectedComponents.year!
        if (linearDates || newYear) {
            return true
        }
        return false
    }
    
    static func unpack(date: Date) -> DateComponents {
        return Calendar.current.dateComponents([Calendar.Component.month, Calendar.Component.year, Calendar.Component.day], from: date)
    }
}

