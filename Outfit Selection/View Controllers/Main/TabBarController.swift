//
//  TabBarController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 24.02.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    // MARK: - Stored Properties
    /// The set of brand tags previously selected by the user
    var selectedBrands = BrandManager.shared.selectedBrands
    
    // MARK: - Computed Properties
    /// True if brand selection has changed
    var haveBrandsChanged: Bool {
        BrandManager.shared.selectedBrands != selectedBrands
    }
    
    /// True if gender has been changed by the user
    var hasGenderChanged: Bool {
        // Find profile view controller and its stored gender
        guard let shownGender = findViewController(ofType: ProfileViewController.self)?.shownGender else { return false }
        return Gender.current != shownGender
    }
    
    // MARK: - Inherited Properties
    override var selectedViewController: UIViewController? {
        get { super.selectedViewController }
        set {
            // Switch the tab to the new view controller
            super.selectedViewController = newValue
            
            // Check for brands / gender change and reload
            reloadItems()
        }
    }
    
    // MARK: - Custom Methods
    /// Pop to progress view controller without conditions
    func popToProgress() {
        // Save currently selected index
        navigationController?.findViewController(ofType: ProgressViewController.self)?.selectedTabBarIndex = selectedIndex
        
        // Pop to previous (progress) view controller
        navigationController?.popViewController(animated: true)
    }
    
    /// Reload the items if brands selection or gender have changed
    func reloadItems() {
        // Don't do anything if there are no changes in brands or gender
        guard haveBrandsChanged || hasGenderChanged else { return }
        
        // Start reloading the items
        NetworkManager.shared.reloadItems(for: Gender.current) { _ in }
        
        // If gender has been changed avoid extra checks
        if !hasGenderChanged {
            // Don't pop if we have changed to profile view controller
            guard let navigationController = selectedViewController as? UINavigationController else { return }
            guard let firstViewController = navigationController.viewControllers.first else { return }
            guard !(firstViewController is ProfileViewController) else { return }
        }
        
        // Pop to progress view controller
        popToProgress()
    }
    
    // MARK: - Inherited Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set tab bar icon colors
        UITabBar.appearance().tintColor = #colorLiteral(red: 66 / 255, green: 66 / 255, blue: 66 / 255, alpha: 1)
        UITabBar.appearance().unselectedItemTintColor = #colorLiteral(red: 66 / 255, green: 66 / 255, blue: 66 / 255, alpha: 0.5)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide navigation bar
        navigationController?.isNavigationBarHidden = true
    }
}
