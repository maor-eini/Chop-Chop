//
//  ViewController.swift
//  chopchop
//
//  Created by Maor Eini on 01/02/2017.
//  Copyright © 2017 Maor Eini. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    @IBOutlet weak var loginRegisterSegmentedControl: UISegmentedControl! = {
        let sc = UISegmentedControl(items: ["Login","Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false;
        
        return sc
    }()
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var inputContainerView: UIView! = {
        let view = UIView()
        
        view.backgroundColor = UIColor.gray
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.white
        
        setupInputContainerView()
        
        view.addSubview(inputContainerView)
    }
    
    func setupInputContainerView() {
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputContainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

