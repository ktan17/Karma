//
//  ViewController.swift
//  Karma
//
//  Created by Kevin Tan on 4/1/17.
//  Copyright © 2017 Green Bruins. All rights reserved.
//

import UIKit
import CoreData

class ResultViewController: UIViewController {
    
    var query: String!
    var wordArray = [String]()
    var isMaterialAnException: Bool = false
    var materialStatus: Int = 5
    var materialFact: String = ""
    
    @IBOutlet var resultLabel: UILabel!
    
    ///////////////////////////////////////////////////////////////////////////
    //  Methods
    ///////////////////////////////////////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultLabel.text = "You typed in: " + query
    
        let lowercaseQuery = query.lowercased()
    
        var tempWord: String = ""
        
        var k = 0
        for char in lowercaseQuery.characters {
            
            k += 1
            if k == lowercaseQuery.characters.count - 1 {
                
                if char != " " {
                    tempWord += String(char)
                    wordArray.append(tempWord)
                }
                
                else if tempWord.characters.count != 0 {
                    wordArray.append(tempWord)
                }
                
                break
                
            }
            
            if char == " " {
                
                if tempWord.characters.count != 0 {
                    wordArray.append(tempWord)
                    tempWord = ""
                }
                
                continue
                
            }
            
            tempWord += String(char)
            
        }
        
        var managedObjectContext: NSManagedObjectContext!
        getManagedObjectContext(managedObjectContext: &managedObjectContext)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TrashItem")
        
        do {
            
            var k: Int = 0
            let fetchedItems = try managedObjectContext.fetch(fetchRequest) as! [TrashItem]
            
            for word in wordArray {
            
                if let index = fetchedItems.index(where: { $0.name == word} ) {
                    
                    // found match...
                    isMaterialAnException = fetchedItems[index].exceptions
                    
                    // checking exceptions
                    if (isMaterialAnException)
                    {
                        // check if any of the following entered words align with exceptions
                    } else
                    {
                        // make sure that only one material is inputted
                        
                        // set result based on numeric id value of material
                    }
                    
                    break
                }
                
                k += 1
            }
            
        } catch {
            
            fatalError("Failed to fetch trash items: \(error)")
            
        }
        
        //displayResult() // in
        // TODO: Iterate through Type Array (array of all of the trashtypes (0-4)) to determine if the query is recyclable, trash, etc.
        
        // Display what it is on the screen
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

