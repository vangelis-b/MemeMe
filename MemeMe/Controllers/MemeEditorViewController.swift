//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Vangelis Bouzoukas on 4/7/20.
//  Copyright © 2020 Vangelis Bouzoukas. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    // MARK: - Properties
    
    private let topTextDefaultValue = "TOP"
    private let bottomTextDefaultValue = "BOTTOM"
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        setupTextField(textField: topTextField, text: topTextDefaultValue)
        setupTextField(textField: bottomTextField, text: bottomTextDefaultValue)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Subscribe to keyboard notifications in order to raise the view when necessary.
        subscribeToKeyboardNotifications()
        
        shareButton.isEnabled = imageView.image != nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: - Actions
    
    @IBAction func shareMeme(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {
            (activityType, completed, returnedItems, activityError) in
            if completed {
                self.save(memedImage)
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
    
    // MARK: - Private Methods
    
    func generateMemedImage() -> UIImage {
        hideToolbars(true)
        
        // Render view to an image.
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        hideToolbars(false)
        
        return memedImage
    }
    
    func save(_ memedImage: UIImage) {
        // Create the meme.
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: memedImage)
        
        // Add it to the memes array in the Application Delegate.
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        dismiss(animated: true, completion: nil)
    }
    
    func setupTextField(textField: UITextField, text: String) {
        let defaultTextAttributes : [NSAttributedString.Key : Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 36)!,
            .strokeColor: UIColor.black,
            .strokeWidth: -2
        ]
        textField.defaultTextAttributes = defaultTextAttributes
        textField.textAlignment = .center
        textField.text = text
        textField.delegate = self
    }
    
    func hideToolbars(_ hide: Bool) {
        navigationBar.isHidden = hide
        toolbar.isHidden = hide
    }
    
    private func pickAnImage(_ sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc private func keyboardWillShow(_ notification:Notification) {
        // Check if y-coordinate of the frame origin is at position 0 to avoid render issues when using the simulator.
        if bottomTextField.isEditing, view.frame.origin.y == 0 {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc private func keyboardWillHide() {
        view.frame.origin.y = 0
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
    
    // MARK: - Text Field Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == topTextDefaultValue || textField.text == bottomTextDefaultValue {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
    
    // MARK: - Image Picker Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            
            shareButton.isEnabled = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
