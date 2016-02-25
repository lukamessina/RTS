//
//  ResultsViewController.swift
//  RTS
//
//  Created by Luca Messina on 18/02/16.
//  Copyright © 2016 KTH Royal Institute of Technology. All rights reserved.
//

import UIKit
import MessageUI

class ResultsViewController: UIViewController, MFMailComposeViewControllerDelegate {

    // MARK: Properties
    
    @IBOutlet weak var backToHomeButton: UIButton!
    
    @IBOutlet weak var powerMaxLabel: UILabel!
    @IBOutlet weak var reactivityMaxLabel: UILabel!
    @IBOutlet weak var fuelTemperatureMaxLabel: UILabel!
    @IBOutlet weak var claddingTemperatureMaxLabel: UILabel!
    @IBOutlet weak var leadCoreTemperatureMaxLabel: UILabel!
    @IBOutlet weak var leadPrimaryTemperatureMaxLabel: UILabel!
    
    var userEmailAddress: String!
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    var results: Observables!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set title
        title = "Results"
        
        // Load the user email address.
        if let savedEmailAddress = self.userDefaults.valueForKey("userEmailAddress") {
            userEmailAddress = savedEmailAddress as! String
        }
        else {
            userEmailAddress = ""
        }

        // Print labels with correct maximum and minimum values.
        fetchMaximumMininumValues()

    }
    
    // Print labels with correct maximum and minimum values.
    func fetchMaximumMininumValues() {
        let maxPower = round(100*results.power.maxElement()!*100)/100
        let maxPowerTime = results.time[results.power.indexOf(results.power.maxElement()!)!]
        let minPower = round(100*results.power.minElement()!*100)/100
        let minPowerTime = results.time[results.power.indexOf(results.power.minElement()!)!]
        powerMaxLabel.text = "Power max: \(maxPower) % after \(maxPowerTime) s, min: \(minPower) % after \(minPowerTime)"
        
        let maxReactivity = round(100*results.reactivity.maxElement()!)/100
        let maxReactivityTime = results.time[results.reactivity.indexOf(results.reactivity.maxElement()!)!]
        let minReactivity = round(100*results.reactivity.minElement()!)/100
        let minReactivityTime = results.time[results.reactivity.indexOf(results.reactivity.minElement()!)!]
        reactivityMaxLabel.text = "Reactivity max: \(maxReactivity) pcm after \(maxReactivityTime) s, min: \(minReactivity) pcm after \(minReactivityTime)"
        
        let maxFuelTemperature = round(100*results.fuelCenterTemperature.maxElement()!)/100
        let maxFuelTemperatureTime = results.time[results.fuelCenterTemperature.indexOf(results.fuelCenterTemperature.maxElement()!)!]
        fuelTemperatureMaxLabel.text = "Fuel temperature max: \(maxFuelTemperature) K after \(maxFuelTemperatureTime) s"
        
        let maxCladdingTemperature = round(100*results.claddingInnerTemperature.maxElement()!)/100
        let maxCladdingTemperatureTime = results.time[results.claddingInnerTemperature.indexOf(results.claddingInnerTemperature.maxElement()!)!]
        claddingTemperatureMaxLabel.text = "Cladding temperature max: \(maxCladdingTemperature) K after \(maxCladdingTemperatureTime) s"
        
        let maxCoreCoolantTemperature = round(100*results.coolantOutletTemperature.maxElement()!)/100
        let maxCoreCoolantTemperatureTime = results.time[results.coolantOutletTemperature.indexOf(results.coolantOutletTemperature.maxElement()!)!]
        let minCoreCoolantTemperature = round(100*results.coolantInletTemperature.minElement()!)/100
        let minCoreCoolantTemperatureTime = results.time[results.coolantInletTemperature.indexOf(results.coolantInletTemperature.minElement()!)!]
        leadCoreTemperatureMaxLabel.text = "Core lead temperature max: \(maxCoreCoolantTemperature) K after \(maxCoreCoolantTemperatureTime) s, min: \(minCoreCoolantTemperature) K after \(minCoreCoolantTemperatureTime) s"
        
        let maxPrimarySystemCoolantTemperature = round(100*results.coolantHotlegTemperature.maxElement()!)/100
        let maxPrimarySystemCoolantTemperatureTime = results.time[results.coolantHotlegTemperature.indexOf(results.coolantHotlegTemperature.maxElement()!)!]
        let minPrimarySystemCoolantTemperature = round(100*results.coolantColdlegTemperature.minElement()!)/100
        let minPrimarySystemCoolantTemperatureTime = results.time[results.coolantColdlegTemperature.indexOf(results.coolantColdlegTemperature.minElement()!)!]
        leadPrimaryTemperatureMaxLabel.text = "Primary system temperature max: \(maxPrimarySystemCoolantTemperature) K after \(maxPrimarySystemCoolantTemperatureTime) s, min \(minPrimarySystemCoolantTemperature) K after \(minPrimarySystemCoolantTemperatureTime) s"
        
    }

    /*
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    */

    func configuredMailComposeViewController () -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
    
        mailComposerVC.setToRecipients([userEmailAddress])
        mailComposerVC.setSubject("Simulation results")
        mailComposerVC.setMessageBody("Hello!\n\nYou have new results in the attached file", isHTML: false)
        // mailComposerVC.addAttachmentData(results, mimeType: "application/vnd.ms-excel", fileName: "simulation_results")
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail. Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        switch result {
        case MFMailComposeResultCancelled:
            print("Cancelled email")
        case MFMailComposeResultSent:
            print("Mail sent")
        default:
            break
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MFMailComposeViewControllerDelegate


    // MARK: - Navigation

    // Implement unwind segue to the beginning of the app
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if backToHomeButton === sender {
            // Do any cleaning needed when getting back to the beginning
            print("Back to home view")
        }
        // Get the new view controller using segue.destinationViewController.
        
        // Pass the selected object to the new view controller.
    }

    // MARK: Actions
    
    // Send results by email
    @IBAction func sendResultsByEmail(sender: UIButton) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        }
        else {
            self.showSendMailErrorAlert()
        }
    }
    
}
