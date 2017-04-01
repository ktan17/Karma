//
//  ViewController.swift
//  Karma
//
//  Created by Kevin Tan on 4/1/17.
//  Copyright © 2017 Green Bruins. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    var query: String!
    @IBOutlet var resultLabel: UILabel!
    
    ///////////////////////////////////////////////////////////////////////////
    //  Methods
    ///////////////////////////////////////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultLabel.text = "You typed in: " + query
    
        let lowercaseQuery = query.lowercased()
        
        var wordArray = [String]()
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
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

