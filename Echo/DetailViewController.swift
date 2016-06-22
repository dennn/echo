//
//  DetailViewController.swift
//  Echo
//
//  Created by Denis Ogun on 20/06/2016.
//  Copyright © 2016 Denis Ogun. All rights reserved.
//

import UIKit

enum CellType {
    case DateRow
    case DatePicker
    case InformationCell
    case Other
}

class DetailViewController: UITableViewController {

    var currentUser : User?
    private var shouldShowDatePicker = false

    override func viewWillAppear(animated: Bool) {
        print("Current user is \(self.currentUser)")
        self.title = self.currentUser?.fullName
        
        if ((self.currentUser?.dateOfBirth) != nil) {
     //       self.datePicker?.date = self.currentUser!.dateOfBirth!
        }
    }
    
    // MARK: Date Picker

    private func toggleDatePickerVisibility() {
        self.shouldShowDatePicker = !self.shouldShowDatePicker
        
        UIView.transitionWithView(self.tableView, duration: 0.2, options: .TransitionCrossDissolve, animations: {
            self.tableView.reloadData()
            }, completion: nil)
    }
    
    private func cellTypeForIndexPath(indexPath : NSIndexPath) -> CellType {
        if indexPath.section == 0 {
            switch (indexPath.row) {
                case 0, 1:
                    return .InformationCell
                
                case 2:
                    return .DateRow
                
                case 3:
                    return .DatePicker
                
                default:
                    return .Other
            }
        }
        
        return .Other
    }
    
    // MARK: Table View
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellType = cellTypeForIndexPath(indexPath)
    
        switch (cellType) {
            case .InformationCell:
                let cell = tableView.dequeueReusableCellWithIdentifier("editableCell", forIndexPath: indexPath) as! EditableTableCell
                if indexPath.row == 0 {
                    cell.configure("Full Name", description: (self.currentUser?.fullName)!)
                } else if indexPath.row == 1 {
                    cell.configure("Email", description: (self.currentUser?.email)!)
                }
                return cell
            
            case .DatePicker:
                let cell = tableView.dequeueReusableCellWithIdentifier("datePickerCell", forIndexPath: indexPath)
                return cell
           
            default:
                let cell = UITableViewCell(style: .Default, reuseIdentifier: "normalCell")
                return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cellType = cellTypeForIndexPath(indexPath)
        if cellType == .DateRow {
            self.toggleDatePickerVisibility()
        } else if cellType == .InformationCell {
            let cell = self.tableView .cellForRowAtIndexPath(indexPath) as! EditableTableCell
            cell.activateTextField()
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cellType = cellTypeForIndexPath(indexPath)

        if self.shouldShowDatePicker == false && cellType == .DatePicker {
            return 0
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
}
