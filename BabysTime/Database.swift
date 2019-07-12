//
//  Database.swift
//  BabysTime
//
//  Created by Kalista Baig on 2019-07-03.
//  Copyright © 2019 Kalista Baig. All rights reserved.
//

import Foundation

class Database: DatabaseProtocol {
   
    var activities = [Activity]() // time 
    var babyActions = [BabyAction]() // logo title
    
    static var shared: DatabaseProtocol = Database()
    
    init(){
        let defaultBabyActions = [BabyAction(logo: "🍼", title: "Milk"),
                                  BabyAction(logo: "💩", title: "Poo"),
                                  BabyAction(logo: "😴", title: "DoDo"),
                                  BabyAction(logo: "🧷", title: "Diaper"),
                                  BabyAction(logo: "🤮", title: "Barf")
            
        ]
        loadActivities()
        if babyActions.count == 0{
            babyActions = defaultBabyActions
        }
        
    }
    
    func saveActivities(){
        
        do {
            let url = try FileManager.default.url(for: FileManager.SearchPathDirectory.applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("activitiesDatabase.json")
            print("saving to: \(url.absoluteString)")
            let jsonData = try JSONEncoder().encode(activities)
            try jsonData.write(to: url)
        } catch {
            print("error saving: \(error)")
        }
        
    }
    func loadActivities(){
        do {
            let url = try FileManager.default.url(for: FileManager.SearchPathDirectory.applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("activitiesDatabase.json")
            print("loading from: \(url.absoluteString)")
            let jsonData = try Data(contentsOf: url)
            activities = try JSONDecoder().decode([Activity].self, from: jsonData)
        } catch {
            print("error saving: \(error)")
        }
    }
    
    func addActivity(_ activity: Activity) {
        activities.append(activity)
        saveActivities()
    }
    
    func getActvities() -> [Activity] {
        return activities
    }
    
    func deleteActivity(_ activity: Activity){
        activities.removeAll { (babyActivity) -> Bool in
            return activity === babyActivity
        }
        saveActivities()
    }
    
    
    func addBabyAction(_ babyAction: BabyAction) {
        babyActions.append(babyAction)
        
    }
    
    func getBabyActions() -> [BabyAction] {
        return babyActions
    }
    
    func getActivities(babyAction: BabyAction) -> [Activity] {
        let activitiesForAction = activities.filter { (activity) -> Bool in
            return activity.babyAction.logo == babyAction.logo
        }
        return activitiesForAction
    }
    
    
    
}
