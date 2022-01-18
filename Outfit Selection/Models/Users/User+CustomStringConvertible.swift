//
//  User+CustomStringConvertible.swift
//  Get Outfit Stylist
//
//  Created by Denis Bystruev on 18.01.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

extension User: CustomStringConvertible {
    var description: String {
        "\(id) \(gender) \(name) \(sizes) \(pictureURL)"
    }
}
