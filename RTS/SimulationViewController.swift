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
    @IBOutlet weak var simulationProgressView: UIProgressView!
    @IBOutlet weak var simulationProgressLabel: UILabel!
    @IBOutlet weak var resultsButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    // Follow counter and update progress view and label.
    var dummyCounter:Int = 0 {
        didSet {
            let fractionalProgress = Float(dummyCounter) / 100.0
            let animated = dummyCounter != 0
            simulationProgressView.setProgress(fractionalProgress, animated: animated)
            simulationProgressLabel.text = ("\(dummyCounter) %")
            if dummyCounter == 100 {
                resultsButton.enabled = true
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set title
        title = "Simulation"
        
        // Initially set the temporary boom label to empty text.
        // Make the results button disabled.
        resultsButton.enabled = false
        // Set the progress view to 0.
        simulationProgressView.setProgress(0, animated: true)
        simulationProgressLabel.text = ""
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
    @IBAction func startDummySimulation(sender: UIButton) {
        simulationProgressLabel.text = "0 %"
        self.dummyCounter = 0
        for _ in 0..<100 {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                sleep(1)
                dispatch_async(dispatch_get_main_queue(), {
                    self.dummyCounter++
                    return
                })
            })
        }
        startButton.enabled = false
        //resultsButton.enabled = true
    }
    
    
}
