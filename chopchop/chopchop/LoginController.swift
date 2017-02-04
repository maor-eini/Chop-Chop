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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
