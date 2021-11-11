//
//  Occasion.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 09.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import Foundation

/// Occasions to create looks for
final class Occasion: Codable {
    
    // MARK: - Stored Properties
    /// Flag showing if occasion is selected by the user
    private var _isSelected = false
    
    /// Category IDs which belong to the occasion
    let categoryIDs: [Int]
    
    /// Occasion corners from top left clockwise with the list of subcategsubcategory IDs in each corner
    var corneredSubcategoryIDs: [[Int]]
    
    /// Occasion gender
    let gender: Gender
    
    /// Occasion label (2nd level name)
    var label: String
    
    /// The name of the occasion
    var name: String
    
    /// Occasion id (for Equatable)
    let id: Int
    
    // MARK: - Computed Properties
    /// Unique flat subcategory IDs for the occasion
    var flatSubcategoryIDs: [Int] {
        corneredSubcategoryIDs.flatMap { $0.map { $0 }}.unique
    }
    
    /// True if occasion is selected, false otherwise. When set, user defaults is updated.
    var isSelected: Bool {
        get { _isSelected }
        set {
            guard _isSelected != newValue else { return }
            _isSelected = newValue
            DispatchQueue.global(qos: .background).async {
                Occasions.saveSelectedOccasions()
            }
        }
    }
    
    /// Occasion name and title togeher
    var title: String { "\(name): \(label)" }
    
    // MARK: - Types
    enum CodingKeys: String, CodingKey {
        case categoryIDs = "category_ids"
        case corneredSubcategoryIDs = "looks"
        case gender
        case id
        case label
        case name
    }
    
    // MARK: - Init
    /// Constructor for occasion
    /// - Parameters:
    ///   - name: the name of the occasion
    ///   - label: occasion label (2nd level name)
    ///   - categoryIDs: category IDs which belong to the occasion
    ///   - isSelected: whether the occasion is selected by the user, false by default
    init(
        _ name: String,
        label: String,
        categoryIDs: [Int],
        gender: Gender,
        looks: [[Int]],
        id: Int,
        isSelected: Bool = false
    ) {
        self._isSelected = isSelected
        self.categoryIDs = categoryIDs
        self.gender = gender
        self.id = id
        self.label = label
        self.corneredSubcategoryIDs = looks
        self.name = name
    }
    
    // MARK: - Methods
    /// Select / deselect this occasion without updating user defaults
    /// - Parameter isSelected: true if should select, false if should unselect
    func selectWithoutSaving(_ isSelected: Bool) {
        _isSelected = isSelected
    }
}
