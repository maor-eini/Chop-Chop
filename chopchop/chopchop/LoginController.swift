//
//  ViewController.swift
//  chopchop
//
//  Created by Maor Eini on 01/02/2017.
//  Copyright © 2017 Maor Eini. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController, UITextFieldDelegate {

    var loginInputViewController: LoginInputController?
    
    @IBOutlet weak var loginRegisterSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var submitButton: UIButton!

    @IBOutlet weak var inputContainerView: UIView!
    
    @IBOutlet weak var errorMessage: UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.lightGray
        
        setupInputContainerView()
        
        loginInputViewController?.nameTextField.delegate = self
        loginInputViewController?.emailTextField.delegate = self
        loginInputViewController?.passwordTextField.delegate = self
        
        loginInputViewController?.passwordTextField.isSecureTextEntry = true
        
        inputContainerView.frame.origin.y = inputContainerView.frame.origin.y - 50
        
        self.errorMessage.isHidden = true
    }
    
    @IBAction func handleLoginRegisterChange(_ sender: Any) {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
            submitButton.setTitle(title, for: .normal)
        if title == "Login" {
            loginInputViewController?.nameTextField.isEnabled = false
            loginInputViewController?.nameTextField.isHidden = true
            loginInputViewController?.nameTextField.placeholder = ""
            
            //View will slide 20px up
            inputContainerView.frame.origin.y = inputContainerView.frame.origin.y - 50

        }
        else {
            
            //View will slide 20px up
            inputContainerView.frame.origin.y = inputContainerView.frame.origin.y + 50
            
            loginInputViewController?.nameTextField.isEnabled = true
            
            loginInputViewController?.nameTextField.isHidden = false
            loginInputViewController?.nameTextField.placeholder = "Name"
        }
        
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide the keyboard
        textField.resignFirstResponder()
        return true
    }

    @IBAction func endTextFieldEditing(_ sender: Any) {
        self.view.resignFirstResponder()
        self.loginInputViewController?.resignFirstResponder()
        loginInputViewController?.nameTextField.resignFirstResponder()
        loginInputViewController?.emailTextField.resignFirstResponder()
        loginInputViewController?.passwordTextField.resignFirstResponder()
    }
    
    @IBAction func handleAuth(_ sender: Any) {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    func handleRegister(){
 
        guard let email = loginInputViewController?.emailTextField.text,
            let password = loginInputViewController?.passwordTextField.text,
            let name = loginInputViewController?.nameTextField.text else {
                print("Form Is Not Valid !")
                errorMessage.text = "Form Is Not Valid !"
                self.errorMessage.isHidden = false
                return
        }
        
        Model.instance.registerUser(name: name, email: email, password: password) {
            result in
            if result {
                print("Registration Succeeded")
                self.errorMessage.text = ""
                self.errorMessage.isHidden = true
                self.performSegue(withIdentifier: "TabBarSegue", sender: nil)
            } else {
                print("Registration Failed")
                self.errorMessage.text = "Registration Failed"
                self.errorMessage.isHidden = false
            }
        }
    }
    
    
    func handleLogin(){
        
        guard let email = loginInputViewController?.emailTextField.text, let password = loginInputViewController?.passwordTextField.text else {
            errorMessage.text = "Form Is Not Valid !"
            self.errorMessage.isHidden = false
            return
        }
        
        Model.instance.signInUser(name: "", email: email, password: password) { result in
            if (result) {
                print("SignIn Succeeded")
                self.errorMessage.text = ""
                self.errorMessage.isHidden = true
                self.performSegue(withIdentifier: "TabBarSegue", sender: nil)
            }
            else {
                print("SignIn Failed")
                self.errorMessage.text = "SignIn Failed"
                self.errorMessage.isHidden = false
            }
        }  
    }
    
    func setupInputContainerView() {
        loginInputViewController?.nameTextField.isEnabled = false
        loginInputViewController?.nameTextField.placeholder = ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "registerSegue" {
            let linkContainerViewController = segue.destination as! LoginInputController
            loginInputViewController = linkContainerViewController
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

