//
//  UsersViewController.swift
//  Echo
//
//  Created by Denis Ogun on 19/06/2016.
//  Copyright © 2016 Denis Ogun. All rights reserved.
//

import UIKit

class UsersViewController: UITableViewController, DataSourceProtocol {
    
    lazy var dataSource = UserDataSource()
    
    override func viewDidLoad() {
        self.dataSource.delegate = self
    }
    
    // MARK: Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.getAllUsers().count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let user = dataSource.getAllUsers()[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath)
        cell.textLabel?.text = "\(user.firstName) \(user.lastName)"
        
        return cell
    }
    
    // MARK : Data Source Protocol
    
    func dataSourceDidUpdate() {
        self.tableView.reloadData()
    }
}
