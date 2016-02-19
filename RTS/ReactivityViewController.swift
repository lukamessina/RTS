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
    
    var dopplerCoefficient: Double?
    let dopplerDefaultValue = 0.0
    let dopplerMinimumValue = -0.2
    let dopplerMaximumValue = 0.2
    var coolantCoefficient: Double?
    let coolantDefaultValue = -0.43
    let coolantMinimumValue = -2.0
    let coolantMaximumValue = 2.0
    var radialCoefficient: Double?
    let radialDefaultValue = -1.54
    let radialMinimumValue = -2.0
    let radialMaximumValue = 2.0
    var axialCoefficient: Double?
    let axialDefaultValue = -0.70
    let axialMinimumValue = -2.0
    let axialMaximumValue = 2.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        dopplerTextField.delegate = self
        coolantTextField.delegate = self
        radialTextField.delegate = self
        axialTextField.delegate = self

        // Set title
        title = "Set reactivity parameters"
        // Set default values for text fields and suggest ranges.
        setDefaultReactivityCoefficients()
        dopplerTextField.text = "\(dopplerCoefficient!)"
        dopplerRangeLabel.text = "Range: [ \(dopplerMinimumValue), \(dopplerMaximumValue) ]"
        coolantTextField.text = "\(coolantCoefficient!)"
        coolantRangeLabel.text = "Range: [ \(coolantMinimumValue), \(coolantMaximumValue) ]"
        radialTextField.text = "\(radialCoefficient!)"
        radialRangeLabel.text = "Range: [ \(radialMinimumValue), \(radialMaximumValue) ]"
        axialTextField.text = "\(axialCoefficient!)"
        axialRangeLabel.text = "Range: [ \(axialMinimumValue), \(axialMaximumValue) ]"
    }
    
    func setDefaultReactivityCoefficients() {
        dopplerCoefficient = dopplerDefaultValue
        coolantCoefficient = coolantDefaultValue
        radialCoefficient = radialDefaultValue
        axialCoefficient = axialDefaultValue
    }
    
    // MARK: UITextFieldDelegate

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }

    // When finished editing, check if input value is inside limits; otherwise, reset the default value.
    func textFieldDidEndEditing(textField: UITextField) {
        
        dopplerCoefficient = Double (dopplerTextField.text!)
        coolantCoefficient = Double (coolantTextField.text!)
        radialCoefficient = Double (radialTextField.text!)
        axialCoefficient = Double (axialTextField.text!)
        
        if dopplerCoefficient >= dopplerMinimumValue && dopplerCoefficient <= dopplerMaximumValue {
            print("\(dopplerCoefficient!)")
        }
        else {
            dopplerTextField.text = String (dopplerDefaultValue)
            print("Value out of range")
        }
        
        if coolantCoefficient >= coolantMinimumValue && coolantCoefficient <= coolantMaximumValue {
            print("\(coolantCoefficient!)")
        }
        else {
            coolantTextField.text = String (coolantDefaultValue)
            print("Value out of range")
        }
        
        if radialCoefficient >= radialMinimumValue && radialCoefficient <= radialMaximumValue {
            print("\(radialCoefficient!)")
        }
        else {
            radialTextField.text = String (radialDefaultValue)
            print("Value out of range")
        }
        
        if axialCoefficient >= axialMinimumValue && axialCoefficient <= axialMaximumValue {
            print("\(axialCoefficient!)")
        }
        else {
            axialTextField.text = String (axialDefaultValue)
            print("Value out of range")
        }
        
    }
    
    /*
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
}
