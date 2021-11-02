
//
//  RegistrationViewController.swift
//  Messenger
//
//  Created by administrator on 27/10/2021.
//

import UIKit
import Firebase

class RegistrationViewController: UIViewController {

    @IBOutlet weak var userImageBt: UIButton!
    
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    var userID = Auth.auth().currentUser?.uid

    var userInfo : User?
    var profileImage : String?
    var delegate : RegisterDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // circle button
        userImageBt.layer.cornerRadius = userImageBt.frame.width/2
        userImageBt.layer.masksToBounds = true
    }
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        let logInCV = storyboard?.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
       
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func userImageButton(_ sender: UIButton) {
        presentPhotoActionSheet()
    }
    @IBAction func createAccountButton(_ sender: UIButton) {
        if let firstName = firstNameTF.text,  let lastName = lastNameTF.text , let email = emailTF.text , let password = passwordTF.text {
            userInfo =  User(userName: firstName + " " +  lastName
                  , userEmail: email
                  , userPassword: password,
                  profileImageURL: ""
                
        )
            if let user = userInfo {
                createUserAccount(userInformation : user)
                
            }
           
        }
    }
}
extension RegistrationViewController {
    func createUserAccount(userInformation: User){
        print(userInformation.userEmail)
        FirebaseAuth.Auth.auth().createUser(withEmail: userInformation.userEmail, password: userInformation.userPassword, completion: { authResult , error  in
            guard let result = authResult, error == nil else {
                print("Error creating user")
                return
            }
            let user = result.user
            print("Created User: \(user)")
            
            // database:
            let userChatObject = ChatAppUser(userName: userInformation.userName , emailAddress: userInformation.userEmail)
            DatabaseManger.shared.insertUser(with: userChatObject) // call test!

            
            // go to conversation view controoler
            self.delegate?.registerSuccesful()
            self.navigationController?.popViewController(animated: true)
            //self.goToConversationsVC()
         })
        
        
}
    func goToConversationsVC(){
        
        if let conversationVC = self.storyboard?.instantiateViewController(identifier: "ConversationViewController") as? ConversationsViewController {
            //self.navigationController?.pushViewController(conversationVC , animated: true)
            conversationVC.modalPresentationStyle = .fullScreen
            self.present(conversationVC, animated: false)
           
        }
    }
}


extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // get results of user taking picture or selecting from camera roll
    func presentPhotoActionSheet(){
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How would you like to select a picture?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
        
        present(actionSheet, animated: true)
    }
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // take a photo or select a photo
        
        // action sheet - take photo or choose photo
        picker.dismiss(animated: true, completion: nil)
        print(info)
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        DispatchQueue.main.async {
            
            self.userImageBt.setImage(selectedImage, for: .normal)
        }

    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
/*
extension RegistrationViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    
    
    func imagePick() {
        let imagePickerVC = UIImagePickerController()
               imagePickerVC.sourceType = .photoLibrary
               imagePickerVC.delegate = self // new
        DispatchQueue.main.async {
            self.present(imagePickerVC, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)

        if let image = info[.originalImage] as? UIImage {
           // selectedImage = image
            DispatchQueue.main.async {
                self.userImageBt.setImage(image, for: .normal)
            }
            }
        
    }
*/
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


protocol RegisterDelegate {
    func registerSuccesful()
}
