//
//  DetailViewController.swift
//  Echo
//
//  Created by Denis Ogun on 20/06/2016.
//  Copyright © 2016 Denis Ogun. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {

    var currentUser : User?
    @IBOutlet weak var datePicker: UIDatePicker!
    private var shouldShowDatePicker = false

    override func viewWillAppear(animated: Bool) {
        print("Current user is \(self.currentUser)")
        self.title = self.currentUser?.fullName
        
        if ((self.currentUser?.dateOfBirth) != nil) {
            self.datePicker.date = self.currentUser!.dateOfBirth!
        }
    }
    

    private func toggleDatePickerVisibility() {
        self.shouldShowDatePicker = !self.shouldShowDatePicker
        
        UIView.transitionWithView(self.tableView, duration: 0.2, options: .TransitionCrossDissolve, animations: {
            self.tableView.reloadData()
            }, completion: nil)
    }
    
    private func indexPathIsDateRow(indexPath : NSIndexPath) -> Bool {
        if indexPath.row == 2 && indexPath.section == 0 {
            return true
        }
        
        return false
    }
    
    private func indexPathIsDatePickerRow(indexPath : NSIndexPath) -> Bool {
        if indexPath.row == 3 && indexPath.section == 0 {
            return true
        }
        
        return false
    }
    
    // MARK: Table View
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPathIsDateRow(indexPath) {
            self.toggleDatePickerVisibility()
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.shouldShowDatePicker == false && indexPathIsDatePickerRow(indexPath) {
            return 0
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
}
