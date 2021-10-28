//
//  ViewController.swift
//  Messenger
//
//  Created by administrator on 27/10/2021.
//

import UIKit

class LogInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "space background.png")!)
        
        

    }
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        let registrationCV = storyboard?.instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController
       
        //self.navigationController?.pushViewController(registrationCV, animated: true)
        self.present(registrationCV, animated: true , completion: nil)
        
    }
    
}

