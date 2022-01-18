//
//  User.swift
//  Get Outfit Stylist
//
//  Created by Denis Bystruev on 18.01.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import Foundation

struct User: Codable {
    /// Unique user ID
    let id: Int
    
    /// User's gender
    let gender: Gender
    
    /// User's first and last name
    let name: String
    
    /// User picture URL (avatar)
    let pictureURL: URL
    
    /// User's sizes
    let sizes: [String]
    
    /// The names of user properties in the database
    enum CodingKeys: String, CodingKey {
        case id
        case gender
        case name
        case pictureURL = "picture"
        case sizes
    }
}
