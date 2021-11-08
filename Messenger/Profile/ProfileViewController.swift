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
    var delegate : profileDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func logOutPressed(_ sender: UIButton) {
    
    UserDefaults.standard.removeObject(forKey: UserKeyName.userObj)
        do {
            UserDefaults.standard.removeObject(forKey: UserKeyName.userObj)
            try FirebaseAuth.Auth.auth().signOut()
            DispatchQueue.main.async {
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
