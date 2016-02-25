//
//  ReactivityViewController.swift
//  RTS
//
//  Created by Luca Messina on 18/02/16.
//  Copyright © 2016 KTH Royal Institute of Technology. All rights reserved.
//

import UIKit

class ReactivityViewController: UIViewController, UITextFieldDelegate {

    // MARK: Properties
    @IBOutlet weak var dopplerTextField: UITextField!
    @IBOutlet weak var dopplerRangeLabel: UILabel!
    @IBOutlet weak var coolantTextField: UITextField!
    @IBOutlet weak var coolantRangeLabel: UILabel!
    @IBOutlet weak var radialTextField: UITextField!
    @IBOutlet weak var radialRangeLabel: UILabel!
    @IBOutlet weak var axialTextField: UITextField!
    @IBOutlet weak var axialRangeLabel: UILabel!
    
    var selectedReactor: String?
    var userEmailAddress: String? 
    var userSettings: UserSettings!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        dopplerTextField.delegate = self
        coolantTextField.delegate = self
        radialTextField.delegate = self
        axialTextField.delegate = self

        // Set title
        title = "Set reactivity parameters"
        
        // Create the user settings object
        print("Selected reactor is \(selectedReactor!).")
        userSettings = UserSettings (reactorName: selectedReactor!)
        print("I confirm that selected reactor is \(userSettings.selectedReactor)")
        
        // Save user email address
        userSettings.userEmailAddress = userEmailAddress!
        print("User email address: \(userSettings.userEmailAddress)")
        
        // Set default values for text fields and suggest ranges.
        setDefaultReactivityCoefficients()
        dopplerRangeLabel.text = "Range: [ \(Int (userSettings.defaultReactivityMinimumValues[0])), \(Int (userSettings.defaultReactivityMaximumValues[0])) ]"
        coolantRangeLabel.text = "Range: [ \(Int (userSettings.defaultReactivityMinimumValues[1])), \(Int (userSettings.defaultReactivityMaximumValues[1])) ]"
        radialRangeLabel.text = "Range: [ \(Int (userSettings.defaultReactivityMinimumValues[2])), \(Int (userSettings.defaultReactivityMaximumValues[2])) ]"
        axialRangeLabel.text = "Range: [ \(Int (userSettings.defaultReactivityMinimumValues[3])), \(Int (userSettings.defaultReactivityMaximumValues[3])) ]"

    }
    
    func setDefaultReactivityCoefficients() {
        
        userSettings.reactivityCoefficients = userSettings.defaultReactivityCoefficients
        dopplerTextField.text = "\(userSettings.reactivityCoefficients[0])"
        coolantTextField.text = "\(userSettings.reactivityCoefficients[1])"
        radialTextField.text = "\(userSettings.reactivityCoefficients[2])"
        axialTextField.text = "\(userSettings.reactivityCoefficients[3])"

    }
    
    // MARK: UITextFieldDelegate

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }

    // When finished editing, store the values after checking if input value is inside limits; otherwise, reset the default value.
    func textFieldDidEndEditing(textField: UITextField) {
 
        userSettings.reactivityCoefficients = [ Double (dopplerTextField.text!)!, Double (coolantTextField.text!)!, Double (radialTextField.text!)!, Double (axialTextField.text!)!]
        
        if userSettings.reactivityCoefficients[0] < userSettings.defaultReactivityMinimumValues[0] || userSettings.reactivityCoefficients[0] > userSettings.defaultReactivityMaximumValues[0] {
            dopplerTextField.text = String (userSettings.defaultReactivityCoefficients[0])
        }
        
        if userSettings.reactivityCoefficients[1] < userSettings.defaultReactivityMinimumValues[1] || userSettings.reactivityCoefficients[1] > userSettings.defaultReactivityMaximumValues[1] {
            coolantTextField.text = String (userSettings.defaultReactivityCoefficients[1])
        }
        
        if userSettings.reactivityCoefficients[2] < userSettings.defaultReactivityMinimumValues[2] || userSettings.reactivityCoefficients[2] > userSettings.defaultReactivityMaximumValues[2] {
            radialTextField.text = String (userSettings.defaultReactivityCoefficients[2])
        }
        
        if userSettings.reactivityCoefficients[3] < userSettings.defaultReactivityMinimumValues[3] || userSettings.reactivityCoefficients[3] > userSettings.defaultReactivityMaximumValues[3] {
            axialTextField.text = String (userSettings.defaultReactivityCoefficients[3])
        }

    }
    
    /*
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    */

    // MARK: Actions
    
    // Set default values for the reactivity coefficients
    @IBAction func setDefaultReactivityValues(sender: UIButton) {
        setDefaultReactivityCoefficients()
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Save the user settings
        saveUserSettings()
        // Pass the selected object to the new view controller.
    }

    // MARK: NSCoding
    
    // Save the user settings
    func saveUserSettings() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(userSettings, toFile: UserSettings.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save user settings...")
        }
    }
    
}
