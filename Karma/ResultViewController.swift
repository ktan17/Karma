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
    var materialStatus: Int16 = 5
    var materialFact: String = ""
    
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var forrestDump: UIImageView!
    @IBOutlet var cloudImg: UIImageView!
    @IBOutlet var trashTalk: UILabel!
    @IBOutlet var trashTalk2: UILabel!

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
            if k == lowercaseQuery.characters.count {
                
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
            
            let fetchedItems = try managedObjectContext.fetch(fetchRequest) as! [TrashItem]
            
            for word in wordArray {
            
                if let index = fetchedItems.index(where: { $0.name == word} ) {
                    
                    // found match...
                    isMaterialAnException = fetchedItems[index].exceptions
                    
                    // checking exceptions
                    if (isMaterialAnException)
                    {
                        // TODO: check if any of the following entered words align with exceptions
                        materialStatus = Int16(fetchedItems[index].type)
                        materialFact = fetchedItems[index].comment!
                    } else
                    {
                        // TODO: make sure that only one material is inputted
                        // TODO: set result based on numeric id value of material
                        
                        materialStatus = Int16(fetchedItems[index].type)
                        materialFact = fetchedItems[index].comment!
                    }
                    
                    break
                }
            }
            
        } catch {
            
            fatalError("Failed to fetch trash items: \(error)")
            
        }
        
        displayResult(status: materialStatus, fact: materialFact)
        // TODO: Iterate through Type Array (array of all of the trashtypes (0-4)) to determine if the query is recyclable, trash, etc.
        
        // Display what it is on the screen
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func displayResult(status: Int16, fact: String)
    {
        switch (status)
        {
            case 0:
                self.statusLabel.text = "RECYCLABLE"
                self.statusLabel.text = fact
                break
            
            case 1:
                self.statusLabel.text = "COMPOSTABLE"
                self.statusLabel.text = fact
                break
        
            case 2:
                self.statusLabel.text = "TRASH"
                self.statusLabel.text = fact
                break
       
            case 3:
                self.statusLabel.text = "E-WASTE"
                self.statusLabel.text = fact
                break
            
            case 4:
                self.statusLabel.text = "REUSABLE"
                self.statusLabel.text = fact
                break
            
            case 5:
                self.statusLabel.text = "No results."
            
                let img = UIImage(named: "forrest-dump-sad.png")
                forrestDump.image = img
                
                trashTalk.isHidden = true
                trashTalk2.isHidden = true
                cloudImg.isHidden = true
                break
            
            default:
                self.statusLabel.text = "God bless Egypt and Canada and India"
                break
        }
    }
    
}

