//
//  ArchiverHelper.swift
//  HabitTracker
//
//  Created by Steven C on 1/7/21.
//

import Foundation

class ArchiverHelper {
    init() {}
    
    func loadData() -> Bool {
        let data = UserDefaults.standard.value(forKey: "persistedDict")
        if data == nil {
            return false
        }
        do {
            let unarchived = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data as! Data) as! [String:[Date]]
            HabitsTableViewController.datesDict.habitDates = unarchived
            print("successful unarchiving")
            return true
        } catch {
            print("error unarchiving")
            return false
        }
    }
    
    func saveData() {
        do {
            print(HabitsTableViewController.datesDict.habitDates)
            let data = try NSKeyedArchiver.archivedData(withRootObject: HabitsTableViewController.datesDict.habitDates, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: "persistedDict")
            print("successful archiving")
        } catch {
            print("error archiving")
        }
    }
}
