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
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.dataSource.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.dataSource.delegate = nil
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
        cell.textLabel?.text = user.fullName
        
        return cell
    }
    
    // MARK: Transition
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showDetail") {
            let currentRow = self.tableView.indexPathForSelectedRow
            let currentUser = dataSource.getAllUsers()[currentRow!.row]
            let detailVC = segue.destinationViewController as! DetailViewController
            detailVC.currentUser = currentUser
            self.tableView.deselectRowAtIndexPath(currentRow!, animated: true)
        }
    }
    
    // MARK : Data Source Protocol
    
    func dataSourceDidUpdate() {
        self.tableView.reloadData()
    }
}
