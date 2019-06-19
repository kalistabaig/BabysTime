//
//  ActivityViewController.swift
//  BabysTime
//
//  Created by Kalista Baig on 2019-06-18.
//  Copyright © 2019 Kalista Baig. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController, UITableViewDataSource {
    
    var activities: [Activity] = []

    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "babyActivity") as! ActivityCell
        let activity = activities[indexPath.row]
        cell.activity = activity
        return cell
        
    }
    
    
    
    @IBOutlet weak var activityTable: UITableView! {
        didSet{
            activityTable.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activities = [
            Activity(time: Date(), activityLogo: "🍼", activityTitle: "Feeding Time"),
            Activity(time: Date(), activityLogo: "💩", activityTitle: "Took a Crap"),
            Activity(time: Date(), activityLogo: "😴", activityTitle: "DoDo Time")
        ]
        activityTable.reloadData()
        // Do any additional setup after loading the view.
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
