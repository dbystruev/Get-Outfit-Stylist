//
//  ItemViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 17.11.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController {
    // MARK: - Constants
    /// Maximum width of order button: design screen width (375) - left (16) and right (16) margins
    let maxOrderButtonWidth: CGFloat = 343
    
    // MARK: - Outlets
    @IBOutlet weak var addToWishlistButton: WishlistButton! {
        didSet {
            addShadow(for: addToWishlistButton, cornerRadius: 18)
        }
    }
    
    @IBOutlet weak var dislikeButton: WishlistButton! {
        didSet {
            addShadow(for: dislikeButton, cornerRadius: 20, inset: 10)
            
            // Need to know which button to change when dislike button is tapped
            dislikeButton.addToWishlistButton = addToWishlistButton
        }
    }
    
    @IBOutlet var orderButtonHorizontalConstraints: [NSLayoutConstraint]!
    @IBOutlet weak var imageStackView: UIStackView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var nameLabels: [UILabel]!
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var rightLabelsStackView: UIStackView!
    @IBOutlet weak var topLabelsStackView: UIStackView!
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var trailingStackView: UIStackView!
    @IBOutlet var vendorLabels: [UILabel]!
    
    // MARK: - Stored Properties
    /// First item image
    var image: UIImage?
    
    /// Item model to show
    var item: Item?
    
    /// Item index in Item.all array
    var itemIndex = -1
    
    /// Item url to present at Intermediary view controller
    var url: URL?

    // MARK: - Custom Methods
    /// Add shadow to the layer with given corner radius
    /// - Parameters:
    ///   - view: view to add shadow to
    ///   - cornerRadius: view corner radius to use
    ///   - shadowRadius: shadow radius to use
    ///   - inset: inset for shadow path, 0 be default
    func addShadow(for view: UIView, cornerRadius: CGFloat, inset: CGFloat = 0) {
        let grade: CGFloat = 151 / 255
        let layer = view.layer
        layer.cornerRadius = cornerRadius
        layer.shadowColor = UIColor(red: grade, green: grade, blue: grade, alpha: 0.2).cgColor
        layer.shadowOpacity = 1
        layer.shadowPath = UIBezierPath(roundedRect: view.bounds.insetBy(dx: inset, dy: inset), cornerRadius: cornerRadius).cgPath
        layer.shadowRadius = 10
    }
    
    /// Load item pictures to image view and image stack view
    func loadImages() {
        // Load the first image
        imageView.image = image
        
        // Get the URLs for the second and all other images
        guard let imageURLs = item?.pictures, 1 < imageURLs.count else { return }
        
        // Load images into stack view
        for imageURL in imageURLs.dropFirst() {
            NetworkManager.shared.getImage(imageURL) { image in
                guard let image = image else { return }
                DispatchQueue.main.async {
                    let imageView = UIImageView(image: image)
                    imageView.contentMode = .scaleAspectFit
                    self.imageStackView.addArrangedSubview(imageView)
                }
            }
        }
    }
    
    /// Update UI properties when screen rotates
    /// - Parameter isHorizontal: true in landscape mode, false in portrait
    func updateLayout(isHorizontal: Bool) {
        // Update stack views axis and items' visibility
        rightLabelsStackView.isHidden = !isHorizontal
        topLabelsStackView.isHidden = isHorizontal
        topStackView.axis = isHorizontal ? .horizontal : .vertical
        topStackView.distribution = isHorizontal ? .fillEqually : .fill
        
        // Update order button constraints
        updateOrderButtonConstraints()
    }
    
    /// Makes sure the button width does not exceed ItemViewController.maxOrderButtonWidth
    func updateOrderButtonConstraints() {
        // Calculate order button width if its constraints zeroed
        let orderButtonWidth = trailingStackView.frame.width
        
        // Calculate order button constraints so its width does not exceed maxOrderButtonWidth
        let constant =  orderButtonWidth < maxOrderButtonWidth ? 0 : (orderButtonWidth - maxOrderButtonWidth) / 2
        
        // Assign order button constraints
        orderButtonHorizontalConstraints.forEach { $0.constant = constant }
    }
    
    /// Fill labels with item data
    func updateUI() {
        addToWishlistButton.isSelected = Wishlist.contains(item) ?? false
        let nameWithoutVendor = item?.nameWithoutVendor
        nameLabels.forEach { $0.text = nameWithoutVendor }
        orderButton.isHidden = item?.url == nil
        title = item?.price?.asPrice
        let vendorUppercased = item?.vendor?.uppercased()
        vendorLabels.forEach { $0.text = vendorUppercased }
    }
    
    /// Set last emotion in wish list to items
    func setLastEmotionToItems() {
        // Set most recent like/dislike to item
        Wishlist.itemsTabSuggested = true
    }
    
    // MARK: - Inherited Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "intermediaryViewControllerSegue" else { return }
        let intermediaryViewController = segue.destination as? IntermediaryViewController
        intermediaryViewController?.url = url
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        item = 0 <= itemIndex && itemIndex < Item.all.count ? Item.all[itemIndex] : nil
        loadImages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let frame = view.frame
        updateLayout(isHorizontal: frame.height < frame.width)
    }
}
