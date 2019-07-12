//
//  DatabaseProtocol.swift
//  BabysTime
//
//  Created by Nelson Narciso on 2019-06-26.
//  Copyright © 2019 Kalista Baig. All rights reserved.
//

import Foundation

protocol DatabaseProtocol {
    
    static var shared: DatabaseProtocol { get }
    
    func addActivity(_ activity: Activity)
    func deleteActivity(_ activity: Activity)
    func getActvities() -> [Activity]
    func addBabyAction(_ babyAction: BabyAction)
    func getBabyActions() -> [BabyAction]
    func getActivities(babyAction: BabyAction) -> [Activity]
    
}
