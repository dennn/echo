//
//  EditableTableCell.swift
//  Echo
//
//  Created by Denis Ogun on 20/06/2016.
//  Copyright © 2016 Denis Ogun. All rights reserved.
//

import UIKit

class EditableTableCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var cellTextField : UITextField?
    @IBOutlet weak var cellLabel : UILabel?
    
    func configure(value : String?, description : String) {
        cellLabel!.text = value
        cellTextField?.text = description
        cellTextField?.delegate = self
        cellTextField?.userInteractionEnabled = false
    }
    
    func activateTextField() {
        self.cellTextField?.userInteractionEnabled = true
        self.cellTextField?.becomeFirstResponder()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.cellTextField?.userInteractionEnabled = false
    }
}
