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
        imagePick()
    }
}




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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
