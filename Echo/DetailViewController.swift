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
    case UserCell
    case Medication
    case Other
}

enum UserCellRows : Int {
    case FirstName = 0
    case LastName = 1
    case Email = 2
}

class DetailViewController: UITableViewController, DataSourceProtocol {

    var currentUser : User?
    private var shouldShowDatePicker = false
    var userDataSource : UserDataSource?
    var medicationDataSource : MedicationDataSource?

    override func viewWillAppear(animated: Bool) {
        print("Current user is \(self.currentUser)")
        self.title = self.currentUser?.fullName
        self.medicationDataSource = MedicationDataSource()
        self.medicationDataSource?.delegate = self
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
                case 0, 1, 2:
                    return .UserCell
                
                case 3:
                    return .DateRow
                
                case 4:
                    return .DatePicker
                
                default:
                    return .Medication
            }
        } else if indexPath.section == 1 {
            return .Medication
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
            case .UserCell:
                let informationCellRow = UserCellRows(rawValue: indexPath.row)
                
                let cell = tableView.dequeueReusableCellWithIdentifier("userCell", forIndexPath: indexPath) as! UserDataCell
                if informationCellRow == .FirstName {
                    cell.configure(self.currentUser?.firstName, cellType: informationCellRow!)
                } else if informationCellRow == .LastName {
                    cell.configure(self.currentUser?.lastName, cellType: informationCellRow!)
                } else if informationCellRow == .Email {
                    cell.configure(self.currentUser?.email, cellType: informationCellRow!)
                }
                
                // Listen for when an event ends
                cell.textField?.addTarget(self, action: #selector(self.textChanged(_:)), forControlEvents: .EditingChanged)
                
                return cell
            
            case .DatePicker:
                let cell = tableView.dequeueReusableCellWithIdentifier("datePickerCell", forIndexPath: indexPath) as! DatePickerCell
                cell.datePicker?.addTarget(self, action: #selector(self.dateChanged(_:)), forControlEvents: .ValueChanged)
                cell.datePicker?.date = self.currentUser!.dateOfBirth
                return cell
            
            case .DateRow:
                let cell = tableView.dequeueReusableCellWithIdentifier("dateRowCell", forIndexPath: indexPath)
                cell.detailTextLabel?.text = self.currentUser?.dateOfBirthString
                return cell
           
            default:
                let cell = UITableViewCell(style: .Default, reuseIdentifier: "normalCell")
                if indexPath.section == 1 {
                    let medication = self.medicationDataSource?.getMedicationForID(indexPath.row)
                    cell.textLabel?.text = medication?.name
                    if self.currentUser?.medicationList.contains(medication!.id!) == true {
                        cell.accessoryType = .Checkmark
                    }
                }
                return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cellType = cellTypeForIndexPath(indexPath)
        if cellType == .DateRow {
            self.toggleDatePickerVisibility()
        } else if cellType == .UserCell {
            let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! UserDataCell
            cell.activateTextField()
        } else if cellType == .Medication {
            let medication = self.medicationDataSource?.getMedicationForID(indexPath.row)
            let cell = self.tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell!
            if cell.accessoryType == UITableViewCellAccessoryType.Checkmark {
                cell.accessoryType = .None
                self.currentUser?.medicationList.remove(medication!.id!)
            } else {
                cell.accessoryType = .Checkmark
                self.currentUser?.medicationList.insert(medication!.id!)
            }
            self.userDataSource!.saveUser(self.currentUser!)
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
        if section == 0 {
            return 5
        } else if section == 1 {
            return self.medicationDataSource!.getAllMedications().count
        }
        
        return 0
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
    
    func dateChanged(datePicker : UIDatePicker) {
        self.currentUser?.dateOfBirth = datePicker.date
        self.userDataSource!.saveUser(self.currentUser!)

        self.tableView.reloadData()
    }
    
    func textChanged(textField : UITextField) {
        let cellType = UserCellRows(rawValue: textField.tag)!
        
        switch (cellType) {
            case UserCellRows.FirstName:
                self.currentUser?.firstName = textField.text!
            
            case UserCellRows.LastName:
                self.currentUser?.lastName = textField.text!
       
            case UserCellRows.Email:
                self.currentUser?.email = textField.text!
        }
        
        self.userDataSource!.saveUser(self.currentUser!)
    }
    
    func dataSourceDidUpdate() {
        self.tableView.reloadData()
    }
}
