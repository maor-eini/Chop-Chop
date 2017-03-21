//
//  UploadPhotoViewController.swift
//  chopchop
//
//  Created by Sapir Levy on 14/02/2017.
//  Copyright © 2017 Maor Eini. All rights reserved.
//

import UIKit
import Firebase
import os.log

class UploadPhotoViewController: UIViewController , UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: Properties
    
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    private var captionText: String!
    
    var feed: FeedItem?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        captionTextField.delegate = self
        doneButton.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === doneButton else {
            os_log("The done button was not pressed", log: .default, type: .debug)
            return
        }
        
        let caption = captionTextField.text ?? ""
        
        let currentDateTime = Date()
        
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        
        // get the date time String from the date object
        formatter.string(from: currentDateTime)
        
        if photoImageView.image != nil {
            
            Model.instance.saveImage(image: photoImageView.image!){(url) in
                
                let userId = Model.instance.currentUser?.id
                let userName = Model.instance.currentUser?.name
                
                let feed = FeedItem(id: "",userId: userId!, author: userName!, date: currentDateTime, imageUrl: url!, location: caption, likesCount: 0, isLikeClicked: false)
                
                Model.instance.addFeedItem(fi: feed)
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        captionText = textField.text
    }
    
    //MARK: Actions
    
    @IBAction func selectImageFromLibrary(_ sender: UITapGestureRecognizer) {
        captionTextField.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Error with photo selected")
        }
        
        self.photoImageView.contentMode = .scaleAspectFit
        self.photoImageView.image = selectedImage
        doneButton.isEnabled = true
        dismiss(animated: true, completion: nil)
    }

}
