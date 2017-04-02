// TODO: CHECK THAT HANNAH HAS CORRECT VERSION
//  AppDelegate.swift
//  Karma
//
//  Created by Kevin Tan on 4/1/17.
//  Copyright © 2017 Green Bruins. All rights reserved.
//

import UIKit
import CoreData

extension String {
    
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1", "TRUE":
            return true
        case "False", "false", "no", "0", "FALSE":
            return false
        default:
            return nil
        }
    }
    
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let defaults = UserDefaults.standard
        let isPreloaded = defaults.bool(forKey: "isPreloaded")
        if !isPreloaded {
            removeData()
            loadDataFromCSV(file: "trash-data", material: "Trash")
            loadDataFromCSV(file: "cardboard", material: "Cardboard")
            loadDataFromCSV(file: "glass", material: "Glass")
            loadDataFromCSV(file: "paper", material:  "Paper")
            loadDataFromCSV(file: "plastic", material: "Plastic")
            loadDataFromCSV(file: "metal", material: "Metal")
            defaults.set(true, forKey: "isPreloaded")
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
    
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Database")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func loadDataFromCSV(file: String, material: String) {
        
        // Load file
        guard let filepath = Bundle.main.path(forResource: file, ofType: "csv") else {
            print("Failed to open database file")
            exit(1)
        }
        
        // Get contents
        do {
            let contents = try String(contentsOfFile: filepath)
            createDatabase(data: contents, material: material)
        } catch {
            print("File Read Error for file \(filepath)")
            return
        }
        
    }
    
    func removeData () {
        // Remove the existing items
        var managedObjectContext: NSManagedObjectContext!
        getManagedObjectContext(managedObjectContext: &managedObjectContext)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TrashItem")
        
        do {
            let fetchedItems = try managedObjectContext.fetch(fetchRequest) as! [TrashItem]
            
            for item in fetchedItems {
                
                managedObjectContext.delete(item)
                
            }
            
        } catch {
            
            fatalError("Failed to fetch trash items: \(error)")
            
        }
        
    }
    
    func createDatabase(data: String, material: String) {
        
        let delimiter = ","
        let lines: [String] = data.components(separatedBy: NSCharacterSet.newlines) as [String]
        
        var items = [(name: String, trashType: Int, comment: String, exceptions: Bool)]()
        var materialItems = [(modifier: String, trashType: Int, comment: String)]()
        
        var managedObjectContext: NSManagedObjectContext!
        getManagedObjectContext(managedObjectContext: &managedObjectContext)
        
        for line in lines {
            
            if line == "" {
                continue
            }
            
            var values: [String]
            values = line.components(separatedBy: delimiter)
            
            if material == "Trash" {
            
                let nextItem = (values[0], Int(values[1])!, values[2], values[3].toBool()!)
                items.append(nextItem)
                
            }
            
            else {
                
                let nextItem = (values[0], Int(values[1])!, values[2])
                materialItems.append(nextItem)
                
            }
            
        }
        
        switch material {
            
        case "Trash":
            for item in items {
                
                let nextEntry = NSEntityDescription.insertNewObject(forEntityName: "TrashItem", into: managedObjectContext) as! TrashItem
                nextEntry.name = item.name
                nextEntry.type = Int16(item.trashType)
                nextEntry.comment = item.comment
                nextEntry.exceptions = item.exceptions
                
            }
            
        case "Cardboard":
            for item in materialItems {
                
                let nextEntry = NSEntityDescription.insertNewObject(forEntityName: "CardboardItem", into: managedObjectContext) as! CardboardItem
                nextEntry.modifier = item.modifier
                nextEntry.type = Int16(item.trashType)
                nextEntry.comment = item.comment
                
            }
            
        case "Cardboard":
            for item in materialItems {
                
                let nextEntry = NSEntityDescription.insertNewObject(forEntityName: "CardboardItem", into: managedObjectContext) as! CardboardItem
                nextEntry.modifier = item.modifier
                nextEntry.type = Int16(item.trashType)
                nextEntry.comment = item.comment
                
            }
            
            
        
        }

        do {
            
            try managedObjectContext.save()
            
        } catch {
            
            print("insert error: \(error.localizedDescription)")
            
        }
    
    }

}

