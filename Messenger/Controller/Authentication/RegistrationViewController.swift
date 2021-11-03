
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

    var currentUser : User?
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
            currentUser =  User(userName: firstName + " " +  lastName
            , userEmail: email
            , userPassword: password,
            profilePictureUrl: ""
        )
            
                createUserAccount()
                
            
           
        }
    }
}
extension RegistrationViewController {
    func createUserAccount(){
    
        if let c_user = currentUser {
            
        Auth.auth().createUser(withEmail: c_user.userEmail, password: c_user.userPassword, completion: { authResult , error  in
            guard let result = authResult, error == nil else {
                print("Error creating user")
                return
            }
            let user = result.user
            print("Created User: \(user)")
            
            // database:
            DatabaseManger.shared.insertUser(with: c_user , userID: user.uid) { isInserted in
                if isInserted == true {
                    // go to conversation view controoler
                    self.delegate?.registerSuccesful()
                    self.navigationController?.popViewController(animated: true)
                }
                else{ print("error") }
            }
           
           
         })
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



protocol RegisterDelegate {
    func registerSuccesful()
}
