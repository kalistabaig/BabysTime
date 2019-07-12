//
//  ActivityViewController.swift
//  BabysTime
//
//  Created by Kalista Baig on 2019-06-18.
//  Copyright © 2019 Kalista Baig. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDelegate {
    
    @IBOutlet weak var addButton: UIButton!
    var filterActions: [BabyAction] = []
    
    @IBAction func filterAction(_ sender: Any) {
        let blurView = UIView(frame: navigationController!.view.bounds)
        blurView.backgroundColor = .black
        blurView.alpha = 0.2
        navigationController!.view.addSubview(blurView)
        guard let filterViewController = storyboard?.instantiateViewController(withIdentifier: "filterView") as? FilterViewController else { return }
        filterViewController.selectedBabyActionClosure = {(babyActions) in
            self.filterActions = babyActions
            self.populateModel()
            self.activityTable.reloadData()
           // print(babyAction?.logo)
            blurView.removeFromSuperview()
            
        }
        filterViewController.modalPresentationStyle = .overCurrentContext
        present(filterViewController, animated: true, completion: nil)
        
    }
    
    
    
    let database: DatabaseProtocol = Database.shared // database object can hold any object that implements the database protocol
    
    //model for table with activities
    //var activities: [Activity] = []
    var newItemNum: Int = -1 {
        didSet{
            addButton.isEnabled =  newItemNum >= 0 && newItemNum < actions.count
        }
    }
   
    @IBOutlet weak var activityTable: UITableView! {
        didSet{
            activityTable.dataSource = self
            activityTable.delegate = self
        }
    }
    
    
    
    //model for emoji collection
    var sections: [ActivitySection] = []
    
    
    
    var actions: [BabyAction] {
        return database.getBabyActions()
    }
    
    @IBOutlet weak var emojiCollectionView: UICollectionView!{
        didSet{
            emojiCollectionView.dataSource = self
            emojiCollectionView.delegate = self
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? actions.count : 1
    }
    
    private var font: UIFont{
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.preferredFont(forTextStyle: .body).withSize(64.0))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell
        if indexPath.section == 1 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddEmojiCell", for: indexPath)
            
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath)
            if let emojiCell = cell as? EmojiCollectionViewCell{
                let text = NSAttributedString(string: actions[indexPath.item].logo, attributes: [.font:font])
                emojiCell.label.attributedText = text
            }
        }
        return cell
    }
 
    @IBOutlet weak var timePicker: UIDatePicker!
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if newItemNum > -1 {
                collectionView.cellForItem(at: IndexPath(row: newItemNum, section: 0))?.contentView.backgroundColor = UIColor.clear
            }
            newItemNum = indexPath.item
            collectionView.cellForItem(at: indexPath)?.contentView.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        } else {
            if let newActionViewController = storyboard?.instantiateViewController(withIdentifier: "NewActionViewController") as? NewActionViewController {
                newActionViewController.selectedBabyActionClosure = {(babyAction) in
                    collectionView.reloadData()
                }
                self.present(newActionViewController, animated: true) {
                    print("finished presenting")
                }
            }
        }
    }
    
    fileprivate func getDate(_ newActivity: Activity) -> Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.day, .month, .year], from: newActivity.time)
        return calendar.date(from: dateComponents)!
    }
    
    @IBAction func addButtonAction(_ sender: UIButton) {
        let babyAction = actions[newItemNum]
        let newActivity = Activity(time: timePicker.date, babyAction: babyAction)
        database.addActivity(newActivity)
        let date = getDate(newActivity)
        
        let sectionForDate = sections.first { (section) -> Bool in
            return section.date == date
        }
        
        if let sectionForDate = sectionForDate{ //if the sectin exists add the new activity to that sections activity array
            let largestIndex = sectionForDate.activities.firstIndex{ newActivity.time > $0.time} ?? sectionForDate.activities.endIndex
            let sectionIndex = sections.firstIndex{ $0.date == sectionForDate.date }!
            sectionForDate.activities.insert(newActivity, at: largestIndex)
            let indexPath = IndexPath(row: largestIndex, section: sectionIndex)
            //activityTable.scrollToRow(at: indexPath, at: .bottom, animated: true)
            activityTable.insertRows(at: [indexPath], with: UITableView.RowAnimation.right)
        } else {
            let newSection = ActivitySection(date: date, activities: [newActivity])
            let largestSectionIndex = sections.firstIndex{newSection.date > $0.date} ?? sections.endIndex
            sections.insert(newSection, at: largestSectionIndex)
            activityTable.insertSections(IndexSet(integer: largestSectionIndex), with: UITableView.RowAnimation.fade)
        }
    }
    
    fileprivate func populateModel() {
        sections.removeAll()
        var activities: [Activity]
        if filterActions.count != 0 {
            activities = database.getActivities(babyActions: filterActions)
        }else{
            activities = database.getActvities()
        }
        
        for activity in activities{
            let date = getDate(activity)
            let sectionForDate = sections.first { (section) -> Bool in
                return section.date == date
            }
            if let sectionForDate = sectionForDate{ //if the sectin exists add the new activity to that sections activity array
                let largestIndex = sectionForDate.activities.firstIndex{ activity.time > $0.time} ?? sectionForDate.activities.endIndex
                sectionForDate.activities.insert(activity, at: largestIndex)
            }else{
                let newSection = ActivitySection(date: date, activities: [activity])
                let largestSectionIndex = sections.firstIndex{newSection.date > $0.date} ?? sections.endIndex
                sections.insert(newSection, at: largestSectionIndex)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.isEnabled = false
        populateModel()
    }
}




// MARK: - UITableViewDatasource Activity Table

extension ActivityViewController {
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
}


// MARK: - UITableViewDelegate Activity Table

extension ActivityViewController {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            self.database.deleteActivity(self.sections[indexPath.section].activities[indexPath.row])
            self.sections[indexPath.section].activities.remove(at: indexPath.row)
            
            if self.sections[indexPath.section].activities.count == 0 {
                self.sections.remove(at: indexPath.section)
                self.activityTable.deleteSections(IndexSet([indexPath.section]), with: .automatic)
            } else {
                self.activityTable.deleteRows(at: [indexPath], with: .automatic)
            }
           
            completion(true)
            
        }
        
        action.image = #imageLiteral(resourceName: "trash-2")
        action.backgroundColor = .red
        return action
    }
}
