//
//  CalendarMeta.swift
//  HabitTracker
//
//  Created by Steven C on 1/6/21.
//

import Foundation

class CalendarMeta {
    static let sharedInstance = CalendarMeta()
    private init() {}
    var habitDates: [String:[Date]] = [:]
}
