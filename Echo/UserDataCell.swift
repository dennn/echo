//
//  EditableTableCell.swift
//  Echo
//
//  Created by Denis Ogun on 20/06/2016.
//  Copyright © 2016 Denis Ogun. All rights reserved.
//

import UIKit

class UserDataCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var textField : UITextField?
    @IBOutlet weak var label : UILabel?
    
    func configure(value : String?, cellType : UserCellRows) {
        self.textField?.tag = cellType.rawValue
        switch (cellType) {
            case .FirstName:
                label!.text = "First Name"

            case .LastName:
                label!.text = "Last Name"
            
            case .Email:
                label!.text = "Email"
        }
        
        textField?.text = value
        textField?.delegate = self
        textField?.userInteractionEnabled = false
    }
    
    func activateTextField() {
        self.textField?.userInteractionEnabled = true
        self.textField?.becomeFirstResponder()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.userInteractionEnabled = false
    }
}
