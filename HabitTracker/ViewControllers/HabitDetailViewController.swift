//
//  HabitDetailViewController.swift
//  HabitTracker
//
//  Created by Steven C on 12/31/20.
//

import UIKit

class HabitDetailViewController: UIViewController {

    @IBOutlet var habitName: UITextField!
    var name:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "doneSegue" {
            name = habitName.text!
        }
    }
  
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
