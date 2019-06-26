//
//  DatabaseProtocol.swift
//  BabysTime
//
//  Created by Nelson Narciso on 2019-06-26.
//  Copyright © 2019 Kalista Baig. All rights reserved.
//

import Foundation

protocol DatabaseProtocol {
    
    func getActvities() -> [Activity]
    func saveActivity(_ activity: Activity)
    
    func getBabyActions() -> [BabyAction]
    func saveBabyAction(_ babyAction: BabyAction)
    
    func getActivities(babyAction: BabyAction) -> [Activity]
    
}
