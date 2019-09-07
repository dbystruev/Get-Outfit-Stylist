//
//  ViewController+Actions.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 19/06/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - Actions
extension OutfitViewController {
    @IBAction func addButtonPressed(sender: UIBarButtonItem) {
        selectedAction = .add
        setEditing(!isEditing, animated: true)
    }
    
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        setEditing(false, animated: true)
        guard let view = navigationController?.view else { return }
        
        scrollViews.clearBorders()
        let possibleScreenshot = getScreenshot(of: view)
        scrollViews.restoreBorders()
        
        guard let screenshot = possibleScreenshot else { return }
        
        let activityController = UIActivityViewController(activityItems: [screenshot], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = sender.customView
        present(activityController, animated: true)
    }
    
    @IBAction func insideButtonPressed(_ sender: UIButton) {
        selectedButtonIndex = buttons.firstIndex(of: sender)
        setEditing(false, animated: false)
        
        switch selectedAction {
            
        case .add:
//            let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.image"], in: .import)
//            documentPicker.allowsMultipleSelection = true
//            documentPicker.delegate = self
//            present(documentPicker, animated: true)
            let sourceTitles: [UIImagePickerController.SourceType: String] = [
                .camera: "📷",
                .photoLibrary: "🖼"
            ]
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            
            let cancel = UIAlertAction(title: "⛔️", style: .cancel)
            let alert = UIAlertController(title: "Image Source", message: nil, preferredStyle: .actionSheet)
            alert.addAction(cancel)
            
            for (source, title) in sourceTitles {
                guard UIImagePickerController.isSourceTypeAvailable(source) else { continue }
                let action = UIAlertAction(title: title, style: .default) { _ in
                    imagePicker.sourceType = source
                    self.present(imagePicker, animated: true)
                }
                alert.addAction(action)
            }
            present(alert, animated: true)
            
        case .trash:
            guard let scrollViewIndex = selectedButtonIndex else { return }
            guard scrollViewIndex < scrollViews.count else { return }
            let scrollView = scrollViews[scrollViewIndex]
            guard 1 < scrollView.count else { return }
            let indexToDelete = scrollView.currentIndex
            let deletingLastItem = indexToDelete == scrollView.count - 1
            let indexToShow = deletingLastItem ? indexToDelete - 1 : indexToDelete + 1
            
            scrollView.scrollToElement(withIndex: indexToShow) { completed in
                scrollView.deleteImage(withIndex: indexToDelete)
            }
            
        default:
            break
        }

    }
    
    @objc func trashButtonPressed(_ sender: UIBarButtonItem) {
        selectedAction = .trash
        setEditing(!isEditing, animated: true)
        return
    }
    
    @objc func diceButtonPressed(_ sender: UIBarButtonItem) {
        setEditing(false, animated: true)
        scrollViews.forEach {
            if !$0.isPinned {
                $0.scrollToRandomElement()
            }
        }
    }
}
