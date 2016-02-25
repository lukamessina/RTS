//
//  OvercoolingViewController.swift
//  RTS
//
//  Created by Luca Messina on 18/02/16.
//  Copyright © 2016 KTH Royal Institute of Technology. All rights reserved.
//

import UIKit

class OvercoolingViewController: UIViewController, UITextFieldDelegate {

    // MARK: Properties
    
    @IBOutlet weak var failedSteamGeneratorSlider: UISlider!
    @IBOutlet weak var failedSteamGeneratorSliderLabel: UILabel!
    @IBOutlet weak var rampSlider: UISlider!
    @IBOutlet weak var rampSliderLabel: UILabel!
    @IBOutlet weak var transientDurationSlider: UISlider!
    @IBOutlet weak var transientDurationSliderLabel: UILabel!
    @IBOutlet weak var reactivityReductionTextField: UITextField!
    @IBOutlet weak var reactivityReductionRangeLabel: UILabel!
    
    let reactivityReductionMinimumValue = -5000.0
    let reactivityReductionMaximumValue = 0.0
    
    var userSettings: UserSettings!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the text field delegate
        reactivityReductionTextField.delegate = self
        
        // Load saved user settings.
        userSettings = loadUserSettings()

        // Set title
        title = "Overcooling parameters"
        // Set default parameter values and range labels.
        setDefaultParameterValues()
        reactivityReductionRangeLabel.text = "Range: [ \(Int (reactivityReductionMinimumValue)), \(Int (reactivityReductionMaximumValue)) ]"
    }
    
    // Set default parameter settings.
    func setDefaultParameterValues() {
        userSettings.reactivityReduction = userSettings.defaultReactivityReduction
        reactivityReductionTextField.text = "\(userSettings.reactivityReduction!)"
        userSettings.numberFailedSteamGeneratorsOvercooling = 1
        failedSteamGeneratorSlider.value = 1
        failedSteamGeneratorSliderLabel.text = "1"
        userSettings.rampInterval = 1
        rampSlider.value = 1
        rampSliderLabel.text = "1 s"
        userSettings.transientDuration = 1
        transientDurationSlider.value = 1
        transientDurationSliderLabel.text = "1 s"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
        
    }
    
    // When finished editing, check if input value is inside limits; otherwise, reset the default value.
    func textFieldDidEndEditing(textField: UITextField) {
        
        userSettings.reactivityReduction = Double (reactivityReductionTextField.text!)
        
        if userSettings.reactivityReduction < reactivityReductionMinimumValue || userSettings.reactivityReduction > reactivityReductionMaximumValue {
            reactivityReductionTextField.text = String (userSettings.defaultReactivityReduction)
            print("Value out of range")
        }
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Save the user settings.
        saveUserSettings()
    }

    // MARK: Actions
    
    // Control failed steam generator slider movements.
    @IBAction func failedSteamGeneratorSliderValueChanged(sender: UISlider) {
        let currentSliderValue = Int (round(sender.value))
        userSettings.numberFailedSteamGeneratorsOvercooling = currentSliderValue
        failedSteamGeneratorSliderLabel.text = "\(currentSliderValue)"
    }
    
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
        transientDurationSliderLabel.text = "\(currentSliderValue) s"
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
