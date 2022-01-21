//
//  UserListViewController+UITableViewDelegate.swift
//  Get Outfit Stylist
//
//  Created by Denis Bystruev on 21.01.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

extension UserListViewController: UITableViewDelegate {
    /// Called when the user is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let user = userList[safe: indexPath.row] else {
            debug("ERROR: \(indexPath.row) is outside of 0 ..< \(userList.count)")
            return
        }
        Gender.current = user.gender
        performSegue(withIdentifier: BrandsViewController.segueIdentifier, sender: self)
    }
    
    /// Get the height of the cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UserListCell.height
    }
}
