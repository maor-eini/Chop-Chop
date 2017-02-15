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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.lightGray
        
        setupInputContainerView()
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
        
        guard let email = loginInputViewController?.emailTextField.text,
            let password = loginInputViewController?.passwordTextField.text,
            let name = loginInputViewController?.nameTextField.text else {
            print("Form Is Not Valid !")
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            
            if error != nil {
                print(error as Any)
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            //succesfully authenticated user
            let ref = FIRDatabase.database().reference(fromURL: "https://chopchop-8be92.firebaseio.com/")
            let usersReference = ref.child("users").child(uid)
            let values = ["name": name, "email": email]
            usersReference.updateChildValues(values) { (err, ref) in
                
                if err != nil {
                    print(err as Any)
                    return
                }
                
                print("User Saved")
            }
        })
    }
    
    func setupLoginRegisterSegmenetedControl() {
        
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

