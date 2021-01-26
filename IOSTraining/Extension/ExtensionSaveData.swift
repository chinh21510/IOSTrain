//
//  ExtensionSaveData.swift
//  IOSTraining
//
//  Created by Chinh Dinh on 1/25/21.
//  Copyright © 2021 Chinh Dinh. All rights reserved.
//

import UIKit
import CoreData
extension UIView {
    func save(movieId: Int, movies: [NSManagedObject]) {
        var movies = movies
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
          NSEntityDescription.entity(forEntityName: "MovieFavorite",
                                     in: managedContext)!
        
        let movie = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // 3
        movie.setValue(movieId, forKeyPath: "movieId")
        
        // 4
        do {
          try managedContext.save()
          movies.append(movie)
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
