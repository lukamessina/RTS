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
    
    var reactivityInsertion: Double?
    let reactivityInsertionDefaultValue = 0.2
    let reactivityInsertionMinimumValue = 0.0
    let reactivityInsertionMaximumValue = 1.0
    var rampInterval: Double?
    var transientDuration: Double?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Handle the text field’s user input through delegate callbacks.
        reactivityInsertionTextField.delegate = self
        
        // Set title
        title = "UTOP parameters"
        // Set default parameter values
        setDefaultParameterValues()
        reactivityInsertionTextField.text = "\(reactivityInsertion!)"
        reactivityInsertionRangeLabel.text = "Range: [ \(reactivityInsertionMinimumValue), \(reactivityInsertionMaximumValue) ]"
    }
    
    // Default parameter settings
    func setDefaultParameterValues () {
        reactivityInsertion = reactivityInsertionDefaultValue
        rampInterval = 1
        rampSlider.value = 1
        rampSliderLabel.text = "1 s"
        transientDuration = 1800
        transientDurationSlider.value = 1800
        transientDurationLabel.text = "1800 s"
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
        
        reactivityInsertion = Double (reactivityInsertionTextField.text!)
        
        if reactivityInsertion >= reactivityInsertionMinimumValue && reactivityInsertion <= reactivityInsertionMaximumValue {
            print("\(reactivityInsertion!)")
        }
        else {
            reactivityInsertionTextField.text = String (reactivityInsertionDefaultValue)
            print("Value out of range")
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Actions
    @IBAction func rampSliderValueChanged(sender: UISlider) {
        let currentSliderValue = Double(round(10*sender.value))/10
        rampInterval = currentSliderValue
        rampSliderLabel.text = "\(currentSliderValue) s"
    }
    
    @IBAction func transientDurationSliderValueChanged(sender: UISlider) {
        let currentSliderValue = Int(round(sender.value/100)*100)
        transientDuration = Double(currentSliderValue)
        transientDurationLabel.text = "\(currentSliderValue) s"
    }

}
