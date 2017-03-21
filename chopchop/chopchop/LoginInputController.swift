//
//  LoginInputController.swift
//  chopchop
//
//  Created by Maor Eini on 13/02/2017.
//  Copyright © 2017 Maor Eini. All rights reserved.
//

import UIKit

class LoginInputController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        self.nameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func textFieldReturn(_ sender: UITextField) {
        self.view.endEditing(true);
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
