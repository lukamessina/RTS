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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Set title
        title = "Results"
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
        
        mailComposerVC.setToRecipients(["messina@kth.se"])
        mailComposerVC.setSubject("Simulation results")
        mailComposerVC.setMessageBody("Hello!\n\nYou have new results in the attached file", isHTML: false)
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
