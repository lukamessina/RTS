//
//  WelcomeViewController.swift
//  RTS
//
//  Created by Luca Messina on 18/02/16.
//  Copyright © 2016 KTH Royal Institute of Technology. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    /*
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    */
    
    // MARK: Action
    
    /*
    @IBAction func activateTapGesture(sender: UITapGestureRecognizer) {
    
        print("You tapped")
        
    }
    */
    
    // Unwind segue to come back from Results scene.
    @IBAction func unwindToWelcomeView(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? ResultsViewController {
            print("Going back to home")
        }
    }
    
    
}

