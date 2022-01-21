//
//  UserListCell.swift
//  Get Outfit Stylist
//
//  Created by Denis Bystruev on 21.01.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

class UserListCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    // MARK: - Static Constants
    public static let height: CGFloat = 100

    // MARK: - Public Methods
    public func configureContent(with user: User) {
        avatarImageView.configure(with: user.pictureURL)
        userNameLabel.text = user.name
    }

}
