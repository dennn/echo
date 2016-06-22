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
    
    private func indexPathForCellType(type : CellType) -> NSIndexPath? {
        if type == .DateRow {
            return NSIndexPath(forRow: 2, inSection: 0)
        }
        
        return nil
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
                let cell = tableView.dequeueReusableCellWithIdentifier("datePickerCell", forIndexPath: indexPath) as! DatePickerCell
                cell.datePicker?.addTarget(self, action: #selector(DetailViewController.dateChanged(_:)), forControlEvents: .ValueChanged)
                
                if (self.currentUser?.dateOfBirth != nil) {
                    cell.datePicker?.date = self.currentUser!.dateOfBirth!
                }
                return cell
            
            case .DateRow:
                let cell = tableView.dequeueReusableCellWithIdentifier("dateRowCell", forIndexPath: indexPath)
                cell.detailTextLabel?.text = stringFromDate(self.currentUser!.dateOfBirth!)
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
        
        if cellType == .DatePicker {
            if self.shouldShowDatePicker == false {
                return 0
            } else {
                return 218
            }
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "User Details"
        } else if section == 1 {
            return "Medication"
        }
        
        return nil
    }
    
    // MARK: Utility
    
    func stringFromDate(date : NSDate) -> String {
        let dateString = NSDateFormatter.localizedStringFromDate(date, dateStyle: .MediumStyle, timeStyle: .NoStyle)
        
        return dateString
    }
    
    func dateChanged(datePicker : UIDatePicker) {
        self.currentUser?.dateOfBirth = datePicker.date
        self.tableView.reloadData()
    }
    
}
