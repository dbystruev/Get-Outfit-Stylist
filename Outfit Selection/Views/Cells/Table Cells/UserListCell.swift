//
//  UserListCell.swift
//  Get Outfit Stylist
//
//  Created by Denis Bystruev on 21.01.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import SDWebImage
import UIKit

class UserListCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    // MARK: - Static Constants
    public static let height: CGFloat = 100

    // MARK: - Public Methods
    public func configureContent(with user: User) {
        let roundCornerTransformer = SDImageRoundCornerTransformer(
            radius: .infinity,      // changed to half of the width or height
            corners: .allCorners,
            borderWidth: 2,
            borderColor: ColorCompatibility.label
        )
        avatarImageView.sd_setImage(
            with: user.pictureURL,
            placeholderImage: nil,
            context: [.imageTransformer: roundCornerTransformer]
        )
        genderLabel.text = user.gender.description
        userNameLabel.text = user.name
    }

}
