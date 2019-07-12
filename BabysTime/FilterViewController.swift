//
//  FilterViewController.swift
//  BabysTime
//
//  Created by Kalista Baig on 2019-07-11.
//  Copyright © 2019 Kalista Baig. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Variables
    var selectedBabyActionClosure: (([BabyAction]) -> Void)!
    let database: DatabaseProtocol = Database.shared
    var filteredActions: [BabyAction] = []
    
    //Actions
    @IBAction func doneAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        self.selectedBabyActionClosure(filteredActions)
    }
    
    //outlets
    
    @IBOutlet weak var babyActionTable: UITableView!{
        didSet{
            babyActionTable.dataSource = self
            babyActionTable.delegate = self
        }
    }
    
    //model for babyActions filter table
    var babyActions: [BabyAction] {
        return database.getBabyActions()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
// MARK: - UITableViewDataSource
extension FilterViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return babyActions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "babyAction", for: indexPath)
        cell.textLabel?.text = babyActions[indexPath.row].logo
        return cell
        
    }
}

// MARK: - UITableViewDelegate
extension FilterViewController{
    //Table view function for selected row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        if (cell.accessoryType == .checkmark){
            cell.accessoryType = .none
            filteredActions.removeAll { (babyAction) -> Bool in
                babyActions[indexPath.row].logo == babyAction.logo
            }
        }else{
            cell.accessoryType = .checkmark
            filteredActions.append(babyActions[indexPath.row])
        }
        
    }
}
