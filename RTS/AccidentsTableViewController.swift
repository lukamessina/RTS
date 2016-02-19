//
//  AccidentsTableViewController.swift
//  RTS
//
//  Created by Luca Messina on 18/02/16.
//  Copyright © 2016 KTH Royal Institute of Technology. All rights reserved.
//

import UIKit

class AccidentsTableViewController: UITableViewController {

    // MARK: Properties
    
    var accidentList = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load list of accidents
        loadAccidentList()
    }
    
    // Define list of accidents
    func loadAccidentList() {
        let accidentName1 = "UTOP (Unprotected Transient of Power)"
        let accidentName2 = "ULOHS (Unprotected Loss of Heat Sink)"
        let accidentName3 = "Overcooling accident"
        accidentList += [accidentName1, accidentName2, accidentName3]
    }
    
    /*
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    */
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows.
        return accidentList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "AccidentsTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! AccidentsTableViewCell

        // Place the proper accident name in the cell
        let accident = accidentList[indexPath.row]
        cell.accidentLabel.text = accident

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Activate the segue corresponding to each accident
        let selectedAccident = indexPath.row + 1
        print("User selected accident \(selectedAccident)")
        switch indexPath.row {
        case 0:
            performSegueWithIdentifier("showUtopViewController", sender: self)
        case 1:
            performSegueWithIdentifier("showUlohsViewController", sender: self)
        case 2:
            performSegueWithIdentifier("showOvercoolingViewController", sender: self)
        default:
            print("There should not be other cases")
        }
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
