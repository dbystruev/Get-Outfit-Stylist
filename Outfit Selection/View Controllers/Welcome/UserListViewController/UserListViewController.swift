//
//  UserListViewController.swift
//  Get Outfit Stylist
//
//  Created by Denis Bystruev on 21.01.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

class UserListViewController: LoggingViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var userListTableView: UITableView!
    
    // MARK: - Stored Properties
    /// The list of users to display in user list table view
    var userList = Users.all {
        didSet {
            DispatchQueue.main.async {
                self.userListTableView.reloadData()
            }
        }
    }

    // MARK: - Methods
    deinit {
        NotificationCenter.default.removeObserver(self, name: Users.updatedNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup data source and delegate
        userListTableView.dataSource = self
        userListTableView.delegate = self
        
        // Catch users updated notification
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(usersUpdated),
            name: Users.updatedNotification,
            object: nil
        )
    }
    
    // MARK: - Actions
    /// Called when users updated notification is in place
    @objc func usersUpdated() {
        userList = Users.all
    }

}
