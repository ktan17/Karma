
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
        statusLabel.adjustsFontSizeToFitWidth = true
    
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
                    materialStatus = Int16(fetchedItems[index].type)
                    materialFact = fetchedItems[index].comment!
                    
                    // checking exceptions
                    if isMaterialAnException && wordArray.count > 1
                    {
                        
                        switch fetchedItems[index].name! {
                            
                        case "cardboard":
                            let cardboardRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CardboardItem")
                            let cardboardItems = try managedObjectContext.fetch(cardboardRequest) as! [CardboardItem]
                            for words in wordArray {
                                
                                if let index2 = cardboardItems.index(where: { $0.modifier == words } ) {
                                    
                                    materialStatus = Int16(cardboardItems[index2].type)
                                    materialFact = cardboardItems[index2].comment!
                                    
                                }
                                
                            }
                            break
                            
                        case "glass":
                            let glassRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GlassItem")
                            let glassItems = try managedObjectContext.fetch(glassRequest) as! [GlassItem]
                            for words in wordArray {
                                
                                if let index2 = glassItems.index(where: { $0.modifier == words } ) {
                                    
                                    materialStatus = Int16(glassItems[index2].type)
                                    materialFact = glassItems[index2].comment!
                                    
                                }
                                
                            }
                            break
                            
                        case "paper":
                            let paperRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PaperItem")
                            let paperItems = try managedObjectContext.fetch(paperRequest) as! [PaperItem]
                            for words in wordArray {
                                
                                if let index2 = paperItems.index(where: { $0.modifier == words } ) {
                                    
                                    materialStatus = Int16(paperItems[index2].type)
                                    materialFact = paperItems[index2].comment!
                                    
                                }
                                
                            }
                            break
                            
                        case "plastic":
                            let plasticRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PlasticItem")
                            let plasticItems = try managedObjectContext.fetch(plasticRequest) as! [PlasticItem]
                            for words in wordArray {
                                
                                if let index2 = plasticItems.index(where: { $0.modifier == words } ) {
                                    
                                    materialStatus = Int16(plasticItems[index2].type)
                                    materialFact = plasticItems[index2].comment!
                                    
                                }
                                
                            }
                            break
                            
                        case "metal":
                            let metalRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MetalItem")
                            let metalItems = try managedObjectContext.fetch(metalRequest) as! [MetalItem]
                            for words in wordArray {
                                
                                if let index2 = metalItems.index(where: { $0.modifier == words } ) {
                                    
                                    materialStatus = Int16(metalItems[index2].type)
                                    materialFact = metalItems[index2].comment!
                                    
                                }
                                
                            }
                            break
                            
                        default:
                            break
                            
                        }
                        
                    }
                    
                    else
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
                self.trashTalk2.text = fact
                break
            
            case 1:
                self.statusLabel.text = "COMPOSTABLE"
                self.trashTalk2.text = fact
                break
        
            case 2:
                self.statusLabel.text = "TRASH"
                
                let img = UIImage(named: "forrest-dump-sad.png")
                forrestDump.image = img
                
                self.trashTalk2.text = fact
                break
       
            case 3:
                self.statusLabel.text = "E-WASTE"
                self.trashTalk2.text = fact
                break
            
            case 4:
                self.statusLabel.text = "REUSABLE"
                self.trashTalk2.text = fact
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

