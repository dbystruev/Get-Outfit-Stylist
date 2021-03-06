//
//  WishlistButton.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 30.08.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class WishlistButton: UIButton {
    // MARK: - Stored Properties
    /// Will contain self, if this is `add to wishlist` button
    /// Will contain `add to wishlist` button, if this is dislike button
    /// Will change when dislike button is tapped
    var addToWishlistButton: UIButton?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addToWishlistButton = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addToWishlistButton = self
    }
    
    // MARK: - Methods
    /// Called when add to wishlist button is tapped
    /// - Parameter item: the item on which the add to wishlist button is tapped
    func addToWishlistButtonTapped(for item: Item) {
        if Wishlist.contains(item) == true {
            dislikeButtonTapped(for: item)
        } else {
            isSelected = true
            setLastEmotionToItems()
            Wishlist.add(item)
        }
    }
    
    /// Configure the view of wishlist button depending on item being in wishlist
    /// - Parameter item: the item this wishlist button is attached to
    func configure(for item: Item) {
        isSelected = Wishlist.contains(item)
    }
    
    /// Called when dislike button is tapped
    /// - Parameter item: the item on which the dislike button is tapped
    func dislikeButtonTapped(for item: Item) {
        addToWishlistButton?.isSelected = false
        setLastEmotionToItems()
        Wishlist.remove(item)
    }
    
    /// Set last emotion in wish list to items
    func setLastEmotionToItems() {
        // Set most recent like/dislike to item
        Wishlist.tabSuggested = .item
    }
}
