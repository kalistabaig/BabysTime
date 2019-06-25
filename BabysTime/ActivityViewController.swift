//
//  ActivityViewController.swift
//  BabysTime
//
//  Created by Kalista Baig on 2019-06-18.
//  Copyright © 2019 Kalista Baig. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
     @IBOutlet weak var addButton: UIButton!
    
    //model for table with activities
    var activities: [Activity] = []
    var newItemNum: Int = -1 {
        didSet{
            addButton.isEnabled =  newItemNum >= 0 && newItemNum < actions.count
        }
    }

   
    
    @IBOutlet weak var activityTable: UITableView! {
        didSet{
            activityTable.dataSource = self
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].activities.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter.string(from: sections[section].date)
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "babyActivity") as! ActivityCell
        let activity = sections[indexPath.section].activities[indexPath.row]
        cell.activity = activity
        return cell
        
    }
    
    //model for emoji collection
    var sections: [ActivitySection] = []
    
    var actions = [BabyAction(logo: "🍼", title: "Milk"),
                   BabyAction(logo: "💩", title: "Poo"),
                   BabyAction(logo: "😴", title: "DoDo"),
                   BabyAction(logo: "🧷", title: "Diaper"),
                   BabyAction(logo: "🤮", title: "Barf")
    ]
    @IBOutlet weak var emojiCollectionView: UICollectionView!{
        didSet{
            emojiCollectionView.dataSource = self
            emojiCollectionView.delegate = self
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actions.count
    }
    
    private var font: UIFont{
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.preferredFont(forTextStyle: .body).withSize(64.0))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath)
        if let emojiCell = cell as? EmojiCollectionViewCell{
            let text = NSAttributedString(string: actions[indexPath.item].logo, attributes: [.font:font])
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
    
    fileprivate func getDate(_ newActivity: Activity) -> Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.day, .month, .year], from: newActivity.time)
        return calendar.date(from: dateComponents)!
    }
    
    @IBAction func addButtonAction(_ sender: UIButton) {
        let babyAction = actions[newItemNum]
        let newActivity = Activity(time: timePicker.date, babyAction: babyAction)
        let date = getDate(newActivity)
        
        let sectionForDate = sections.first { (section) -> Bool in
            return section.date == date
        }
        if let sectionForDate = sectionForDate{ //if the sectin exists add the new activity to that sections activity array
            sectionForDate.activities.append(newActivity) // if the section doesnt exists i.e. its a new day then create a section for the activity and add the new actifity to the new sections' list of activities
            let sectionIndex = sections.firstIndex{ $0.date == sectionForDate.date }!
            let indexPath = IndexPath(row: sectionForDate.activities.count-1, section: sectionIndex)
            activityTable.insertRows(at: [indexPath], with: UITableView.RowAnimation.right)
        
        } else {
            let newSection = ActivitySection(date: date, activities: [newActivity])
            sections.append(newSection)
            activityTable.insertSections(IndexSet(arrayLiteral: sections.count-1), with: UITableView.RowAnimation.fade)
        }
        
        return
        

        var largestIndex = activities.endIndex
        
        for index in 0..<activities.count{
            if newActivity.time > activities[index].time{
                largestIndex = index
                break
            }
        }
        
        activities.insert(newActivity, at: largestIndex)
        let indexPath = IndexPath(row: largestIndex, section: 0)
        activityTable.insertRows(at: [indexPath], with: UITableView.RowAnimation.right)
        activityTable.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: true)
    }
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        activities = [
//            Activity(time: Date(), babyAction: BabyAction(logo: "🍼", title: "Feeding Time")),
//            Activity(time: Date(), babyAction: BabyAction(logo: "😴", title: "DoDo time")),
//            Activity(time: Date(), babyAction: BabyAction(logo: "💩", title: "Took a Crap"))
//
//        ]
//        activityTable.reloadData()
        addButton.isEnabled = false
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
