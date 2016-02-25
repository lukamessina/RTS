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
    @IBOutlet weak var reactorSummaryLabel: UILabel!
    @IBOutlet weak var dopplerSummaryLabel: UILabel!
    @IBOutlet weak var coolantSummaryLabel: UILabel!
    @IBOutlet weak var radialSummaryLabel: UILabel!
    @IBOutlet weak var axialSummaryLabel: UILabel!
    @IBOutlet weak var accidentTypeSummaryLabel: UILabel!
    @IBOutlet weak var accidentDescriptionSummaryLabel: UILabel!
    
    @IBOutlet weak var simulationProgressView: UIProgressView!
    @IBOutlet weak var simulationProgressLabel: UILabel!
    @IBOutlet weak var resultsButton: UIButton!
    @IBOutlet weak var startSimulationButton: UIButton!
    
    var userSettings: UserSettings!
    var results = Observables()
    
    // Follow counter and update progress view and label.
    var dummyCounter:Int = 0 {
        didSet {
            let fractionalProgress = Float(dummyCounter) / 100.0
            // let animated = dummyCounter != 0
            simulationProgressView.setProgress(fractionalProgress, animated: true)
            simulationProgressLabel.text = ("\(dummyCounter) %")
            if dummyCounter == 100 {
                resultsButton.enabled = true
            }
        }
    }
    
    var totalNumberSteps: Int!
    var numberSteps:Int = 0 {
        didSet {
            let fractionalProgress = Float(numberSteps) / Float(totalNumberSteps)
            // let animated = numberSteps != 0
            simulationProgressView.setProgress(fractionalProgress, animated: true)
            simulationProgressLabel.text = ("\(Int(fractionalProgress*100)) %")
            if numberSteps == totalNumberSteps {
                resultsButton.enabled = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set title
        title = "Simulation"
        
        // Load saved user settings.
        userSettings = loadUserSettings()
        
        // Initially set the temporary boom label to empty text.
        // Make the results button disabled.
        resultsButton.enabled = false
        // Set the progress view to 0.
        simulationProgressView.setProgress(0, animated: true)
        simulationProgressLabel.text = ""
        
        // Prepare and show the simulation summary.
        buildSimulationSummaryLabels()
    
    }

    // Build up the simulation summary.
    func buildSimulationSummaryLabels() {

        reactorSummaryLabel.text = "Reactor: \(userSettings.selectedReactor)"
        dopplerSummaryLabel.text = "Doppler constant: \(userSettings.reactivityCoefficients[0]) pcm"
        coolantSummaryLabel.text = "coolant coefficient: \(userSettings.reactivityCoefficients[1]) pcm/K"
        radialSummaryLabel.text = "radial coefficient: \(userSettings.reactivityCoefficients[2]) pcm/K"
        axialSummaryLabel.text = "axial coefficient: \(userSettings.reactivityCoefficients[3]) pcm/K"
        
        // !!! These labels have to be updated with the actual saved data!!!
        switch userSettings.accidentType {
        
        case 1:
            accidentTypeSummaryLabel.text = "Transient type: UTOP for \(userSettings.transientDuration) s"
            accidentDescriptionSummaryLabel.text = "introducing \(userSettings.reactivityInsertionFractionBeta!) β-effective (β=267.1 pcm) in \(userSettings.rampInterval) s"
        case 2:
            accidentTypeSummaryLabel.text = "Transient type: ULOHS for \(userSettings.transientDuration) s"
            accidentDescriptionSummaryLabel.text = "reducing SG power removal by \(userSettings.steamGeneratorPowerLoss!)% in \(userSettings.rampInterval) s"
        case 3:
            accidentTypeSummaryLabel.text = "Transient type: overcooling for \(userSettings.transientDuration) s"
            accidentDescriptionSummaryLabel.text = "removing \(userSettings.reactivityReduction!) pcm of reactivity in \(userSettings.rampInterval) s with \(userSettings.numberFailedSteamGeneratorsOvercooling!) SG still in operation"
        default:
            break
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Pass results to the resultsViewController
        let resultsViewController = segue.destinationViewController as! ResultsViewController
        resultsViewController.results = results
    }
    
    // MARK: Actions
    /*
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
    */
    
    @IBAction func runSimulator(sender: UIButton) {
        
        // Define reactor object
        let reactor = Reactor()

        // Pass user-defined settings to the simulator
        reactor.status = userSettings.accidentType
        reactor.reactivityInsertion = userSettings.reactivityInsertionFractionBeta! * reactor.betaEffective
        reactor.steamGeneratorPowerLossFraction = userSettings.steamGeneratorPowerLoss!/100
        reactor.reactivityReduction = userSettings.reactivityReduction! * pcm
        reactor.numberFailedSteamGeneratorsOvercooling = userSettings.numberFailedSteamGeneratorsOvercooling!
        reactor.rampInterval = userSettings.rampInterval
        reactor.transientDuration = userSettings.transientDuration
        reactor.dopplerCoefficient = userSettings.reactivityCoefficients[0] * pcm
        reactor.coolantReactivityCoefficient = userSettings.reactivityCoefficients[1] * pcm
        reactor.radialReactivityCoefficient = userSettings.reactivityCoefficients[2] * pcm
        reactor.axialReactivityCoefficient = userSettings.reactivityCoefficients[3] * pcm
        
        // Set other parameters.
        reactor.printingTimeStep = 1e-3
        reactor.hydraulicTimeStep = 1e-1
        /* reactor.transientDuration = 3.0 */
        totalNumberSteps = 10  // This has to be done in a smarter way
        let deltaTime = reactor.transientDuration! / Double(totalNumberSteps)
        reactor.transientDuration = deltaTime * Double(totalNumberSteps!)
        
        // Adjust graphic view
        startSimulationButton.enabled = false
        simulationProgressView.setProgress(0, animated: true)
        simulationProgressLabel.text = ("0 %")
        
        // Run simulation on a separate thread
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            for i in 1...self.totalNumberSteps {
                reactor.runTransient( Double(i-1) * deltaTime, maxTime: Double(i) * deltaTime)
                dispatch_async(dispatch_get_main_queue(), {
                    self.numberSteps++
                    // print("Finished!")
                    })
            }
            dispatch_async(dispatch_get_main_queue(), {
                // Save results
                self.results = reactor.output
                return
                })
            
            })
        
        print("Fuel temperature: \(reactor.plutoniumZirconiumNitride.centerAverageTemperature) K")
        
    }
    
    // MARK: NSCoding
    
    func loadUserSettings() -> UserSettings {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(UserSettings.ArchiveURL.path!) as! UserSettings
    }
    
}
