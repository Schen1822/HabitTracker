//
//  DBHelper.swift
//  HabitTracker
//
//  Created by Steven C on 1/3/21.
//

import Foundation
import SQLite3

class DBHelper {
    init() {
        db = openDatabase()
    }
    
    let dbPath: String = "countsDB.sqlite3"
    var db: OpaquePointer?
    
    func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
            return nil
        } else {
            print("opened database")
            return db
        }
    }
    
    func createTable(named name:String) {
        let createTableString = "CREATE TABLE IF NOT EXISTS '\(name)'(month INTEGER,year INTEGER,count INTEGER);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("" + name + " table created")
            } else {
                print("table not created")
            }
        } else {
            print("CREATE TABLE statement could not be created")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func read(from table:String) -> [HabitDate:Int] {
        let queryStatementString = "SELECT * FROM '\(table)';"
        var queryStatement: OpaquePointer? = nil
        var dict:[HabitDate:Int] = [:]
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let m = sqlite3_column_int(queryStatement, 0)
                let y = sqlite3_column_int(queryStatement, 1)
                let c = sqlite3_column_int(queryStatement, 2)
                let curr:HabitDate = HabitDate(month: Int(m),  year: Int(y))
                dict[curr] = Int(c)
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return dict
    }
    
    func insert(month:Int, year:Int, count:Int, into table:String) {
        let habits = read(from: table)
        let date = HabitDate(month: month, year: year)
        if habits[date] != nil {
            return
        } else {
            let insertStatementString = "INSERT INTO '\(table)' VALUES (?, ?, ?);"
            var insertStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                sqlite3_bind_int(insertStatement, 1, Int32(month))
                sqlite3_bind_int(insertStatement, 2, Int32(year))
                sqlite3_bind_int(insertStatement, 3, Int32(count))
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    print("Successfully inserted row.")
                } else {
                    print("Could not insert row.")
                }
            } else {
                print("INSERT statement could not be prepared.")
            }
            sqlite3_finalize(insertStatement)
        }
    }
    
    func get(month: Int, year: Int, from table: String)-> Int {
        let habits = read(from: table)
        let date = HabitDate(month: month, year: year)
        if habits[date] != nil {
            return habits[date]!
        } else {
            insert(month: month, year: year, count: 0, into: table)
            return 0
        }
    }
    
    func inTable(month: Int, year: Int, from table: String)-> Bool {
        let habits = read(from: table)
        let date = HabitDate(month: month, year: year)
        if habits[date] != nil {
            return true
        } else {
            return false
        }
    }
    
    func update(month: Int, year: Int, count: Int, into table: String) {
        //let updateStatementString = "UPDATE \(table) SET count = \(count) WHERE month = \(month) AND year = \(year);"
        let updateStatementString = "UPDATE '\(table)' SET count = \(count) WHERE month = \(month) AND year = \(year);"
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("successful update")
            } else {
                print("bad update")
            }
        } else {
            print("Update could not be prepared")
        }
        sqlite3_finalize(updateStatement)
    }
    
    func deleteTable(_ table: String) {
        let deleteStatementString = "DROP TABLE IF EXISTS '\(table)'"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("successful delete")
            } else {
                print("bad delete")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
}
