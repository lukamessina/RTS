//
//  UtopViewController.swift
//  RTS
//
//  Created by Luca Messina on 18/02/16.
//  Copyright © 2016 KTH Royal Institute of Technology. All rights reserved.
//

import UIKit

class UtopViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    @IBOutlet weak var rampSlider: UISlider!
    @IBOutlet weak var rampSliderLabel: UILabel!
    @IBOutlet weak var transientDurationSlider: UISlider!
    @IBOutlet weak var transientDurationLabel: UILabel!
    @IBOutlet weak var reactivityInsertionTextField: UITextField!
    @IBOutlet weak var reactivityInsertionRangeLabel: UILabel!
    
    let reactivityInsertionMinimumValue = 0.0
    let reactivityInsertionMaximumValue = 10.0
    
    var userSettings: UserSettings!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Handle the text field’s user input through delegate callbacks.
        reactivityInsertionTextField.delegate = self
        
        // Set title
        title = "UTOP parameters"
        
        // Load saved user settings.
        userSettings = loadUserSettings()

        // Set default parameter values and range labels.
        setDefaultParameterValues()
        reactivityInsertionRangeLabel.text = "Range: [ \(Int (reactivityInsertionMinimumValue)), \(Int (reactivityInsertionMaximumValue)) ]"
        
    }
    
    // Set default parameter settings.
    func setDefaultParameterValues () {
        userSettings.reactivityInsertionFractionBeta = userSettings.defaultReactivityInsertionFractionBeta
        reactivityInsertionTextField.text = "\(userSettings.reactivityInsertionFractionBeta!)"
        userSettings.rampInterval = 1
        rampSlider.value = 1
        rampSliderLabel.text = "1 s"
        userSettings.transientDuration = 1
        transientDurationSlider.value = 1
        transientDurationLabel.text = "1 s"
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
    
    // When finished editing, check if input value is inside limits; otherwise, reset the default value.
    func textFieldDidEndEditing(textField: UITextField) {
        
        userSettings.reactivityInsertionFractionBeta = Double (reactivityInsertionTextField.text!)
        
        if userSettings.reactivityInsertionFractionBeta < reactivityInsertionMinimumValue || userSettings.reactivityInsertionFractionBeta > reactivityInsertionMaximumValue {
            reactivityInsertionTextField.text = String (userSettings.defaultReactivityInsertionFractionBeta)
            print("Value out of range")
        }
        
    }

    // MARK: - Navigation

    // Pass the selected type of accident to the SimulationViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Save the user settings
        saveUserSettings()
    }
    
    
    // MARK: Actions
    
    // Control ramp interval slider movements.
    @IBAction func rampSliderValueChanged(sender: UISlider) {
        let currentSliderValue = Double(round(10*sender.value))/10
        userSettings.rampInterval = currentSliderValue
        rampSliderLabel.text = "\(currentSliderValue) s"
    }
    
    // Control transient duration slider movements.
    @IBAction func transientDurationSliderValueChanged(sender: UISlider) {
        // let currentSliderValue = Int(round(sender.value/100)*100)
        let currentSliderValue = Int(sender.value)
        userSettings.transientDuration = Double(currentSliderValue)
        transientDurationLabel.text = "\(currentSliderValue) s"
    }

    // Reset default parameter values if button is pressed.
    @IBAction func reapplySetDefaultParameterValues(sender: UIButton) {
        setDefaultParameterValues()
    }
    
    // MARK: NSCoding
    
    // Save the user settings
    func saveUserSettings() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(userSettings, toFile: UserSettings.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save user settings...")
        }
    }
    
    func loadUserSettings() -> UserSettings {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(UserSettings.ArchiveURL.path!) as! UserSettings
    }
    
}
