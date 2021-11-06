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
            
            self.saveInUserDefult(c_userEmail:email ,c_userPass: password, c_userId: result.user.uid )
            self.goToConversationsVC()
            
            // if this succeeds, dismiss
              //  strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            
           
        })
    }
    
    func saveInUserDefult(c_userEmail: String, c_userPass : String , c_userId : String){
        UserDefaults.standard.set(c_userEmail, forKey: UserKeyName.email)
        UserDefaults.standard.set(c_userPass, forKey: UserKeyName.password)
        UserDefaults.standard.set(c_userId, forKey: UserKeyName.userId)
        
        //get current user name:
        DatabaseManger.shared.searchUser(email: c_userEmail, completion: { result in
            switch result {
                case .success(let c_user):
                print("userr name : dbbbbbbbbbbbbbbbb \(c_user[UserKeyName.username]!)")
                    UserDefaults.standard.set(c_user[UserKeyName.username], forKey: UserKeyName.username)
                case .failure(let error):
                    print("failed mmmmmmmmmmmmmmmmmm\(error)")
            }
               
            })
        }
        
       
                                         
    
    func goToConversationsVC(){
        
         let conversationVC = storyboard?.instantiateViewController(identifier: "ConversationViewController") as! ConversationsViewController
            self.navigationController?.pushViewController(conversationVC , animated: true)
        //conversationVC!.modalPresentationStyle = .fullScreen
        //present(conversationVC!, animated: false)
           
        
    }
}
