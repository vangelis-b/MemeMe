//
//  ViewController.swift
//  MemeMe
//
//  Created by Vangelis Bouzoukas on 4/7/20.
//  Copyright © 2020 Vangelis Bouzoukas. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    // MARK: Properties
    
    
    private let topTextDefaultValue = "TOP"
    private let bottomTextDefaultValue = "BOTTOM"
    private let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 36)!,
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.strokeWidth: -2
    ]
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Subscribe to keyboard notifications, to raise the view when necessary.
        subscribeToKeyboardNotifications()
        
        // Disable the share button when there's no image to share.
        shareButton.isEnabled = imageView.image != nil
        
        // Disable the camera button if the camera is not available.
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        // Apply custom text styling to the top and bottom text.
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        // Align top and bottom text to the center.
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
        
        // Set delegates
        topTextField.delegate = self
        bottomTextField.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    // MARK: Actions
    
    @IBAction func shareMeme(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {
            [weak self] (activityType, completed, returnedItems, activityError) in
            if completed {
                self?.save(memedImage)
            }
            
            activityViewController.dismiss(animated: true, completion: nil)
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func resetMemeEditor(_ sender: Any) {
        shareButton.isEnabled = false
        imageView.image = nil
        topTextField.text = topTextDefaultValue
        bottomTextField.text = bottomTextDefaultValue
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickAnImage(.camera)
    }
    
    @IBAction func pickAnImageFromPhotoLibrary(_ sender: Any) {
        pickAnImage(.photoLibrary)
    }
    
    // MARK: Private Methods
    
    func generateMemedImage() -> UIImage {
        // Hide navigation bar and toolbar.
        navigationBar.isHidden = true
        toolbar.isHidden = true
        
        // Render view to an image.
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show navigation bar and toolbar again.
        navigationBar.isHidden = false
        toolbar.isHidden = false
        
        return memedImage
    }
    
    func save(_ memedImage: UIImage) {
        // Create the meme.
        _ = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: memedImage)
        dismiss(animated: true, completion: nil)
    }
    
    private func pickAnImage(_ sourceType: UIImagePickerController.SourceType) -> Void {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc private func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isEditing, view.frame.origin.y == 0 {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc private func keyboardWillHide() {
        if bottomTextField.isEditing, view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
    
    private func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        
        return keyboardSize.cgRectValue.height
    }
    
    private func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    private func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: Text Field Delegate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == topTextDefaultValue || textField.text == bottomTextDefaultValue {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
    
    // MARK: Image Picker Delegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            
            // Enable the share button when there's an image.
            shareButton.isEnabled = imageView.image != nil
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

