//
//  ProfileViewController.swift
//  Messenger
//
//  Created by administrator on 27/10/2021.
//

import UIKit
import FirebaseAuth
class ProfileViewController: UIViewController {

    @IBOutlet weak var imageProfileBt: UIButton!
    @IBOutlet weak var logOutBt: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    var user_name: String?
    var delegate : profileDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //logOutBt.layer.cornerRadius = 120
        //logOutBt.layer.masksToBounds = true
        
        imageProfileBt.layer.cornerRadius = 30
        imageProfileBt.layer.masksToBounds = true
        
        nameLabel.text = user_name

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func logOutPressed(_ sender: UIButton) {
    
    UserDefaults.standard.removeObject(forKey: UserKeyName.userObj)
        do {
            UserDefaults.standard.removeObject(forKey: UserKeyName.userObj)
            try FirebaseAuth.Auth.auth().signOut()
            DispatchQueue.main.async {
                self.delegate?.logOutSuccesful()
                self.navigationController?.popViewController(animated: true)
            }
           }
           catch {
           }
    }
    
    @IBAction func backToConversations(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    


}
protocol profileDelegate {
    func logOutSuccesful()
}
