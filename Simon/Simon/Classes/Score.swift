//
//  Score.swift
//  Simon
//
//  Created by Zohar Bergman on 19/07/2018.
//  Copyright © 2018 Zohar Bergman. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Score : NSManagedObject {
    static let NAME = "name"
    static let POINTS = "points"
    
    @NSManaged var name : String!
    @NSManaged var points : NSNumber!
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    @discardableResult
    func save() -> Bool {
        var isSaved = false
        do {
            try self.managedObjectContext?.save()
            isSaved = true
        } catch {
            print("Error: failed to save score (\(self)) in Core Data: \(error)")
        }
        
        return isSaved
    }
    
    func remove() -> Bool {
        self.managedObjectContext?.delete(self)
        
        return true
    }
    
    override var description: String {
        return "name: \(name ?? "none"), points: \(points)"
    }
    
    static func saveScore(name : String, points : Int) {
        let score = createScoreEntity()
        score.setValue(name, forKey: NAME)
        score.setValue(points, forKey: POINTS)
        score.save()
    }
    
    static fileprivate var managedContext: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext
    }
    
    static func createScoreEntity() -> Score {
        let entity = NSEntityDescription.entity(forEntityName: "Score", in: managedContext)
        return Score(entity: entity!, insertInto: managedContext)
    }
    
    static func fetchData(limit : Int = 10) -> [Score]? {
        var fetchedScores : [Score]? = nil
        let scoresFetchedRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Score")
        
        // Setting the limit
        scoresFetchedRequest.fetchLimit = limit
        
        // Setting sorts
        let pointsSort = NSSortDescriptor(key: POINTS, ascending:false)
        
        scoresFetchedRequest.sortDescriptors = [pointsSort]
        
        do {
            fetchedScores = try Score.managedContext.fetch(scoresFetchedRequest) as? [Score]
        } catch {
        }
        
        return fetchedScores
    }
}

