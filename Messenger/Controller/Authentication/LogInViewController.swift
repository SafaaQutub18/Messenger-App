//
//  ViewController.swift
//  Messenger
//
//  Created by administrator on 27/10/2021.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "space background.png")!)
    }
    
    @IBAction func logInButton(_ sender: UIButton) {
        userLogInAuthntication()
    }
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        let registrationCV = storyboard?.instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController
       
        //self.navigationController?.pushViewController(registrationCV, animated: true)
        self.present(registrationCV, animated: true , completion: nil)
    }
    
}

extension LogInViewController {
    
    func userLogInAuthntication(){
        // Firebase Login
        FirebaseAuth.Auth.auth().signIn(withEmail: emailTF!.text!, password: passwordTF!.text!, completion: { [weak self] authResult, error in
            
            guard let strongSelf = self else {
                   return
               }
            guard let result = authResult, error == nil else {
                print("Failed to log in user with email \(self?.emailTF!.text! ?? "email is empty")")
                return
            }
            let user = result.user
            print("logged in user: \(user)")
            // if this succeeds, dismiss
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
           
        })
    }
}
