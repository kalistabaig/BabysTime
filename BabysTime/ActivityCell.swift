//
//  ActivityCell.swift
//  BabysTime
//
//  Created by Kalista Baig on 2019-06-18.
//  Copyright © 2019 Kalista Baig. All rights reserved.
//

import UIKit

class ActivityCell: UITableViewCell {
    
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var activity: Activity! {
        didSet{
            logoLabel.text = activity.activityLogo
            titleLabel.text = activity.activityTitle
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a"
            timeLabel.text = formatter.string(from: activity.time)
        }
    }

  
    
    
}
