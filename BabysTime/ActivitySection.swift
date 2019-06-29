//
//  BabyActionSection.swift
//  BabysTime
//
//  Created by Kalista Baig on 2019-06-24.
//  Copyright © 2019 Kalista Baig. All rights reserved.
//

import Foundation

class ActivitySection {
    
    var date: Date
    var activities: [Activity]
    
    init(date: Date, activities: [Activity] ) {
        self.date = date
        self.activities = activities
    }
    
}
