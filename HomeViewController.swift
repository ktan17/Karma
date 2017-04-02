//
//  ViewController.swift
//  Karma
//
//  Created by Kevin Tan on 4/1/17.
//  Copyright © 2017 Green Bruins. All rights reserved.
//

import UIKit

extension UIImage {
    
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

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
        
        let img = UIImage(named: "line.png")!.alpha(0.5)
        queryTextField.background = img
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showResult" {
            
            guard let text = queryTextField.text else { return }
            let resultViewController = segue.destination as! ResultViewController
            resultViewController.query = text
            
            queryTextField.text = ""
            
        }
        
    }

}

