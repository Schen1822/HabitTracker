//
//  Date.swift
//  HabitTracker
//
//  Created by Steven C on 1/3/21.
//

import Foundation

class HabitDate:Hashable{
    var month: Int
    var year: Int
    
    init (month:Int, year:Int) {
        self.month = month
        self.year = year
    }
    
    func equals(_ date: HabitDate) -> Bool {
        return self.month == date.month && self.year == date.year
    }
    
    static func == (lhs: HabitDate, rhs: HabitDate) -> Bool {
        return lhs.month == rhs.month && lhs.year == rhs.year
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(month)
        hasher.combine(year)
    }
    
}
