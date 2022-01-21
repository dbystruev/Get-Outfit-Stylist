//
//  UserListViewController+UITableViewDataSource.swift
//  Get Outfit Stylist
//
//  Created by Denis Bystruev on 21.01.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

extension UserListViewController: UITableViewDataSource {
    /// Called to get the number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userList.count
    }
    
    /// Called for each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Obtain the reusable cell from table view
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserListCell.reuseId) else {
            debug("ERROR: Can't find cell with reuse ID \(UserListCell.reuseId)")
            return UITableViewCell()
        }
        
        // Make sure the cell is user list cell
        guard let userListCell = cell as? UserListCell else {
            debug("ERROR: Can't cast \(cell) to \(UserListCell.self)")
            return cell
        }
        
        // Check if the user has not changed
        guard let user = userList[safe: indexPath.row] else {
            debug("ERROR: \(indexPath.row) is outside of 0 ..< \(userList.count)")
            return cell
        }
        
        // Configure user list cell with obtained user
        userListCell.configureContent(with: user)
        return userListCell
    }
    
    
}
