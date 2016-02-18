//
//  SimulationViewController.swift
//  RTS
//
//  Created by Luca Messina on 18/02/16.
//  Copyright © 2016 KTH Royal Institute of Technology. All rights reserved.
//

import UIKit

class SimulationViewController: UIViewController {

    
    // MARK: Properties
    @IBOutlet weak var temporaryBoomLabel: UILabel!
    @IBOutlet weak var resultsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initially set the temporary boom label to empty text.
        temporaryBoomLabel.text = ""
        // Make the results button disabled.
        resultsButton.enabled = false
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
    
    // MARK: Actions
    
    @IBAction func showTemporaryBoom(sender: UIButton) {
        // Visualize temporary boom label
        temporaryBoomLabel.text = "BOOM!"
        // Enable results button
        resultsButton.enabled = true
        
        }
    
}
