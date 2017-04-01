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
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

