//
//  ViewController.swift
//  Karma
//
//  Created by Kevin Tan on 4/1/17.
//  Copyright © 2017 Green Bruins. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITextFieldDelegate {
    
    let limitLength = 25
    
    @IBOutlet var enterButton: UIButton!
    @IBOutlet var goButton: UIButton!
    @IBOutlet var queryTextField: UITextField!
    
    ///////////////////////////////////////////////////////////////////////////
    //  Methods
    ///////////////////////////////////////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        queryTextField.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressedGo(_ sender: UIButton) {
        
        
        
    }
    
    ///////////////////////////////////////////////////////////////////////////
    //  Text Field Delegate
    ///////////////////////////////////////////////////////////////////////////
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        guard let text = textField.text else { return true }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        return newLength <= limitLength // Bool

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return false // We do not want UITextField to insert line-breaks.
        
    }
    
    ///////////////////////////////////////////////////////////////////////////
    //  Segues
    ///////////////////////////////////////////////////////////////////////////
    
    @IBAction func unwindToHomeView(segue: UIStoryboardSegue) {
        
    }

}

