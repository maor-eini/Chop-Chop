//
//  ViewController.swift
//  chopchop
//
//  Created by Maor Eini on 01/02/2017.
//  Copyright © 2017 Maor Eini. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {

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
        
        loginInputViewController?.passwordTextField.isSecureTextEntry = true
        self.errorMessage.isHidden = true
    }
    
    @IBAction func handleLoginRegisterChange(_ sender: Any) {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
            submitButton.setTitle(title, for: .normal)
        if title == "Login" {
            //loginInputViewController?.nameTextField.isHidden = true
            loginInputViewController?.nameTextField.isEnabled = false
            loginInputViewController?.nameTextField.placeholder = ""
        }
        else {
            loginInputViewController?.nameTextField.isEnabled = true
            loginInputViewController?.nameTextField.placeholder = "Name"
        }
        
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
        
        ChopchopAuthService.registerUser(name: name, email: email, password: password) {
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
        
        ChopchopAuthService.signInUser(name: "", email: email, password: password) { result in
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

