//
//  Users.swift
//  Get Outfit Stylist
//
//  Created by Denis Bystruev on 18.01.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import Foundation

typealias Users = [User]

extension Users {
    /// Notification to send when users are updated from the server
    static let updatedNotification = Notification.Name(rawValue: "Users.updatedNotification")
    
    /// All users loaded from the server
    static var all: Users = [] {
        didSet {
            NotificationCenter.default.post(name: Users.updatedNotification, object: nil)
        }
    }
}
