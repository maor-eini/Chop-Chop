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
    var image : UIImage?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captionTextField.delegate = self
        doneButton.isEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        
        if image != nil {
            Model.instance.saveImage(image: image!) {(url) in
                
                let caption = self.captionTextField.text ?? ""
                let currentDateTime = Date()
                
                // initialize the date formatter and set the style
                let formatter = DateFormatter()
                formatter.timeStyle = .medium
                formatter.dateStyle = .long
                
                // get the date time String from the date object
                formatter.string(from: currentDateTime)
                
                let feedItem = FeedItem(id: "",userId: (Model.instance.currentUser?.id)!, author: (Model.instance.currentUser?.name)!, date: currentDateTime, imageUrl: url!, location: caption, likesCount: 0, isLikeClicked: false)
                
                Model.instance.addFeedItem(fi: feedItem)
                
                self.navigationController!.popViewController(animated: true)
            }
        }else{
            self.navigationController!.popViewController(animated: true)
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
        
        self.photoImageView.image = selectedImage
        image = selectedImage
        
        doneButton.isEnabled = true
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
