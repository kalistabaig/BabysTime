//
//  ActivityViewController.swift
//  BabysTime
//
//  Created by Kalista Baig on 2019-06-18.
//  Copyright © 2019 Kalista Baig. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //model for table with activities
    var activities: [Activity] = []
    var newItemNum: Int = -1

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    @IBOutlet weak var activityTable: UITableView! {
        didSet{
            activityTable.dataSource = self
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "babyActivity") as! ActivityCell
        let activity = activities[indexPath.row]
        cell.activity = activity
        return cell
        
    }
    
    //model for emoji collection
    var emojisForActivities = "🍼💩😴🧷🤮".map {String($0)} // array of emoji strings mapped to an array of string, maps takes a collection turns it to an array and exectute the closure on each item

    @IBOutlet weak var emojiCollectionView: UICollectionView!{
        didSet{
            emojiCollectionView.dataSource = self
            emojiCollectionView.delegate = self
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojisForActivities.count
    }
    
    private var font: UIFont{
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.preferredFont(forTextStyle: .body).withSize(64.0))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath)
        if let emojiCell = cell as? EmojiCollectionViewCell{
            let text = NSAttributedString(string: emojisForActivities[indexPath.item], attributes: [.font:font])
            emojiCell.label.attributedText = text
        }
        return cell
    }
 
    @IBOutlet weak var timePicker: UIDatePicker!
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if newItemNum > -1 {
            collectionView.cellForItem(at: IndexPath(row: newItemNum, section: 0))?.contentView.backgroundColor = UIColor.clear
        }
        newItemNum = indexPath.item
        collectionView.cellForItem(at: indexPath)?.contentView.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        
        
        let newActivity = Activity(time: timePicker.date, activityLogo: emojisForActivities[newItemNum], activityTitle: "Diaper Change")
        activities.insert(newActivity, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        activityTable.insertRows(at: [indexPath], with: UITableView.RowAnimation.right)
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
