//
//  RegistrationViewController.swift
//  Messenger
//
//  Created by administrator on 27/10/2021.
//

import UIKit

class RegistrationViewController: UIViewController {

    @IBOutlet weak var userImageBt: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // circle button
        userImageBt.layer.cornerRadius = userImageBt.frame.width/2
        userImageBt.layer.masksToBounds = true
    }
    
    @IBAction func userImageButton(_ sender: UIButton) {
        presentPhotoActionSheet()
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


