//
//  Activity.swift
//  BabysTime
//
//  Created by Kalista Baig on 2019-06-18.
//  Copyright © 2019 Kalista Baig. All rights reserved.
//

import Foundation

class Activity: Codable {
    var time: Date
    var babyAction: BabyAction
    
    init(time: Date, babyAction: BabyAction) {
        self.time = time
        self.babyAction = babyAction
    }
}




