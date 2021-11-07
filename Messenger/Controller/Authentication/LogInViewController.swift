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
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "space back 70p.png")!)
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //if the user exesit: 
        if Auth.auth().currentUser?.uid != nil {
            goToConversationsVC()
        }
    }
    @IBAction func logInButton(_ sender: UIButton) {
        if let email = emailTF.text ,let pass = passwordTF.text {
        userLogInAuthntication(email: email, password: pass)
        }
    }
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        let registrationCV = storyboard?.instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController
       
        self.navigationController?.pushViewController(registrationCV, animated: true)
        //self.present(registrationCV, animated: true , completion: nil)
    }
    
}

extension LogInViewController : RegisterDelegate{
    
    func registerSuccesful() {
        DispatchQueue.main.async {
            self.goToConversationsVC()
        }
       
    }
    
    
    func userLogInAuthntication(email: String , password: String){
        // Firebase Login
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { authResult, error in
            
          /*  guard let strongSelf = self else {
                   return
               }*/
            guard let result = authResult, error == nil else {
                print("Failed to log in user with email \(self.emailTF!.text! )")
                return
            }
            let user = result.user
            print("logged in user: \(user)")
            
            self.saveInUserDefult(c_userEmail:email ,c_userId: result.user.uid )
            
            
            // if this succeeds, dismiss
              //  strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            
           
        })
    }
    
    func saveInUserDefult(c_userEmail: String, c_userId : String){
        
        DefaultManager.saveValues(value: c_userEmail, valueType: .email)
        DefaultManager.saveValues(value: c_userId, valueType: .userId)
        
        //get current user name:
        DatabaseManger.shared.searchUser(email: c_userEmail, completion: { result in
            switch result {
                case .success(let c_user):
                if let userName = c_user[UserKeyName.username] as? String {
                    DefaultManager.saveValues(value: userName, valueType: .userName)
                }
                    
                case .failure(let error):
                    print("failed fetch name\(error)")
            }
               
            })
        self.goToConversationsVC()
        }
        
    func goToConversationsVC(){
        
         let conversationVC = storyboard?.instantiateViewController(identifier: "ConversationViewController") as! ConversationsViewController
            self.navigationController?.pushViewController(conversationVC , animated: true)
    }
}
