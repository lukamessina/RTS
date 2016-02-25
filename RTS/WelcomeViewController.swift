//
//  WelcomeViewController.swift
//  RTS
//
//  Created by Luca Messina on 18/02/16.
//  Copyright © 2016 KTH Royal Institute of Technology. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController, UITextFieldDelegate {

    // MARK: Properties
    @IBOutlet weak var emailAddressTextField: UITextField!
    
    var userEmailAddress: String!
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    //var selectedReactor: Reactors?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegate for emailAddressTextField.
        emailAddressTextField.delegate = self
        
        // Initialize user email address.
        // userEmailAddress = ""
        
        // Initialize user email address, picking the saved email address if it was previously typed.
        if let savedEmailAddress = self.userDefaults.valueForKey("userEmailAddress") {
            userEmailAddress = savedEmailAddress as! String
            emailAddressTextField.text = userEmailAddress
        }
        else {
            userEmailAddress = ""
        }
    }

    /*
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    */
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    // When finished editing, save the input email address to the userDefaults preferences.
    func textFieldDidEndEditing(textField: UITextField) {
        userEmailAddress = emailAddressTextField.text
        self.userDefaults.setValue(userEmailAddress, forKey: "userEmailAddress")
        self.userDefaults.synchronize()
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showReactivityViewControllerFromElectra" {
            // Define the destination view controller.
            let reactivityViewController = segue.destinationViewController as! ReactivityViewController
            // Pass the selected reactor and the user email address.
            reactivityViewController.selectedReactor = "ELECTRA"
            reactivityViewController.userEmailAddress = userEmailAddress
        }
    }

    // MARK: Actions
    
    // Unwind segue to come back here from Results scene.
    @IBAction func unwindToWelcomeView(sender: UIStoryboardSegue) {
        if let _ = sender.sourceViewController as? ResultsViewController {
            print("Going back to home")
        }
    }
    /*
    // If Sealer is selected, store the choice in property 'selectedReactor'.
    @IBAction func selectedSealerReactor(sender: UITapGestureRecognizer) {
        selectedReactor = .Sealer
    }
    */
    
    // Alert user that Sealer, Alfred, and Myrrha reactors are not yet implemented.
    @IBAction func missingSealerReactorAlertMessage(sender: UITapGestureRecognizer) {
        let alertController = UIAlertController(title: "SORRY!", message: "Sealer reactor is not yet implemented.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func missingAlfredReactorAlertMessage(sender: UITapGestureRecognizer) {
        let alertController = UIAlertController(title: "SORRY!", message: "Alfred reactor is not yet implemented.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    /*
    @IBAction func missingElectraReactorAlertMessage(sender: UITapGestureRecognizer) {
        let alertController = UIAlertController(title: "SORRY!", message: "Electra reactor is not yet implemented.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    */
    
    @IBAction func missingMyrrhaReactorAlertMessage(sender: UITapGestureRecognizer) {
        let alertController = UIAlertController(title: "SORRY!", message: "Myrrha reactor is not yet implemented.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}

