//
//  HabitsTableViewController.swift
//  HabitTracker
//
//  Created by Steven C on 12/31/20.
//

import UIKit

class HabitsTableViewController: UITableViewController {
    let persistTable = UserDefaults.standard
    var habits = [String]()
    var habitPages = [String: CalendarViewController]()
    var newHabit:String = ""
    static var db:DBHelper = DBHelper()
    static var datesDict = CalendarMeta.sharedInstance
    static var archiver:ArchiverHelper = ArchiverHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.view.backgroundColor = UIColor(red: 175.0/255.0, green: 150/255.0, blue: 100.0/255.0, alpha: 1)
        let persistedHabits = persistTable.stringArray(forKey: "table")
        if  persistedHabits != nil {
            print("gotteem")
            habits = persistedHabits!
        }
        HabitsTableViewController.archiver.loadData()
        // Uncomment the following line to preserve selection between presentations
        //self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return habits.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "habitCell", for: indexPath)
        cell.textLabel?.text = habits[indexPath.row]
        cell.contentView.backgroundColor = UIColor(red: 120.0/255.0, green: 100/255.0, blue: 66.0/255.0, alpha: 1)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(red: 120.0/255.0, green: 100/255.0, blue: 66.0/255.0, alpha: 1)
    }
    
    @IBAction func cancel(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func done(segue:UIStoryboardSegue) {
        let habitDetailVC = segue.source as! HabitDetailViewController
        newHabit = habitDetailVC.name
        habits.append(newHabit)
        persistTable.set(habits, forKey: "table")
        print("persisted")
        let newPage:CalendarViewController = self.storyboard?.instantiateViewController(withIdentifier:"CalendarViewController") as! CalendarViewController
        newPage.title = newHabit
        habitPages[newHabit] = newPage
        HabitsTableViewController.db.createTable(named:newHabit)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if habitPages[habits[indexPath.row]] == nil {
            print("this thing: " + habits[indexPath.row])
            let newPage:CalendarViewController = self.storyboard?.instantiateViewController(withIdentifier:"CalendarViewController") as! CalendarViewController
            let newHabit = habits[indexPath.row]
            newPage.title = newHabit
            habitPages[newHabit] = newPage
            //HabitsTableViewController.db.createTable(named:newHabit)
        }
        let next: CalendarViewController = habitPages[habits[indexPath.row]]!
        self.navigationController?.pushViewController(next, animated:true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            HabitsTableViewController.db.deleteTable(habits[indexPath.row])
            HabitsTableViewController.datesDict.habitDates.removeValue(forKey: habits[indexPath.row])
            HabitsTableViewController.archiver.saveData()
            self.habits.remove(at: indexPath.row)
            persistTable.set(habits, forKey: "table")
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
