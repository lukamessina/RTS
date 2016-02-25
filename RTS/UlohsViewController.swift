//
//  UlohsViewController.swift
//  RTS
//
//  Created by Luca Messina on 18/02/16.
//  Copyright © 2016 KTH Royal Institute of Technology. All rights reserved.
//

import UIKit

class UlohsViewController: UIViewController, UITextFieldDelegate {

    // MARK: Properties
    
    @IBOutlet weak var rampSlider: UISlider!
    @IBOutlet weak var rampSliderLabel: UILabel!
    @IBOutlet weak var transientDurationSlider: UISlider!
    @IBOutlet weak var transientDurationLabel: UILabel!
    @IBOutlet weak var fractionSteamGeneratorLossTextField: UITextField!
    @IBOutlet weak var fractionSteamGeneratorLossRangeLabel: UILabel!
    
    let fractionSteamGeneratorLossMinimumValue = 0.0
    let fractionSteamGeneratorLossMaximumValue = 100.0
    
    var userSettings: UserSettings!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Handle the text field's user input through delegate callbacks.
        fractionSteamGeneratorLossTextField.delegate = self
        
        // Load saved user settings.
        userSettings = loadUserSettings()

        // Set title
        title = "ULOHS parameters"
        // Set default parameter values and range labels.
        setDefaultParameterValues()
        fractionSteamGeneratorLossRangeLabel.text = "Range: [ \(Int (fractionSteamGeneratorLossMinimumValue)), \(Int (fractionSteamGeneratorLossMaximumValue)) ]"
    }

    // Set default parameter settings. 
    func setDefaultParameterValues() {
        userSettings.steamGeneratorPowerLoss = userSettings.defaultSteamGeneratorPowerLoss
        fractionSteamGeneratorLossTextField.text = "\(userSettings.steamGeneratorPowerLoss!)"
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
        
        userSettings.steamGeneratorPowerLoss = Double (fractionSteamGeneratorLossTextField.text!)
        
        if userSettings.steamGeneratorPowerLoss < fractionSteamGeneratorLossMinimumValue || userSettings.steamGeneratorPowerLoss > fractionSteamGeneratorLossMaximumValue {
            fractionSteamGeneratorLossTextField.text = String (userSettings.defaultSteamGeneratorPowerLoss)
            print("Value out of range")
        }
        
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Save user settings.
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
    @IBAction func DurationSliderValueChanged(sender: UISlider) {
        //let currentSliderValue = Int(round(sender.value/100)*100)
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
