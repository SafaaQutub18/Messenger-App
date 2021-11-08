//
//  ConversationViewController.swift
//  Messenger
//
//  Created by administrator on 27/10/2021.
//

import UIKit
import FirebaseAuth

class ConversationsViewController: UIViewController , profileDelegate{
    

    @IBOutlet weak var imageProfileButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var friendProfileImage : UIImage?
    var profileImage : UIImage?
    private var conversations = [Conversation]()
    
    var currentUserEmail = DefaultManager.getValues(valueType: .email)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageProfileButton.layer.cornerRadius = 20
        imageProfileButton.layer.masksToBounds = true
        // set the background
        self.title = "Chat"
        tableView.dataSource = self
        tableView.delegate = self
        
        self.navigationController?.navigationBar.isHidden = true
        //fetchConversations()
        }
    
          override func viewDidAppear(_ animated: Bool) {
              super.viewDidAppear(animated)
              validateAuth()
              self.navigationController?.navigationBar.isHidden = true
              fetchProfileImage()
              fetchConversations()
          }
    
    @IBAction func addConversationButton(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "New Friend *_*", message: "Add a new Friend",preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        
        let saveAction = UIAlertAction(title: "Add", style: .default){
            
            _ in
             let emailTextField = alert.textFields![0] // take the value of the first text field
            if let email = emailTextField.text{
                
                DatabaseManger.shared.searchUser(email: email) { result in
                    switch result {
                        case .success(let newFriend):
                        self.addNewConversation(reciverInfo : newFriend)
                            print(newFriend)
                            print("successfully got conversation models")
                        case .failure(let error):
                            print("failed to get convos \(error)")
                    }
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func validateAuth(){
              // current user is set automatically when you log a user in
        if FirebaseAuth.Auth.auth().currentUser == nil {
            // present login view controller
            self.navigationController?.popViewController(animated: true)
              }
    }
    
    @IBAction func logOutButton(_ sender: UIButton) {
        
        
              let profileVC = storyboard?.instantiateViewController(identifier: "ProfileViewController") as! ProfileViewController
              guard let name = DefaultManager.getValues(valueType: .userName) else{return}
              
        profileVC.user_name = name
              
            profileVC.delegate = self
              self.navigationController?.pushViewController(profileVC , animated: true)        
    }

    func logOutSuccesful() {
        self.navigationController?.popViewController(animated: true)
        }
}

extension ConversationsViewController {
    
    func addNewConversation(reciverInfo : [String: Any]){
        // check for friend profile :
        if let imagePath = reciverInfo[UserKeyName.profileImageURL] as? String {
            prepareFriendImage(urlImage: imagePath )
            }
        // create conv. id  :
        
        if let reciverEmail = reciverInfo[UserKeyName.email] as? String, let reciverName = reciverInfo[UserKeyName.username] as? String , let currentEmail = currentUserEmail {
      
            
            let conversationID = DatabaseManger.shared.safeEmail(userEmail: currentEmail) + "_" + DatabaseManger.shared.safeEmail(userEmail: reciverEmail)
            
       
            DispatchQueue.main.async {
                let newConversation = Conversation(conversationId: conversationID, other_user_email: reciverEmail, other_user_name: reciverName/*, senderID: senderId*/)
                self.conversations.append(newConversation)
                self.tableView.reloadData()
                
                DatabaseManger.shared.insertNewConv(with: newConversation) { isStord in
                    if isStord == true {
                        print("conversation strord in fb successfully")
                    }
                    else{print("error")}
                }
                
            }
        }
    }
    
    private func fetchConversations(){
        print("inside fetch")
        guard let userEmail = currentUserEmail else{return}
        
        let currentEmail = DatabaseManger.shared.safeEmail(userEmail: userEmail)
        
        DatabaseManger.shared.getAllConversations(for: currentEmail) { result in
            switch result {
                case .success(let convArray):
                self.conversations = convArray
                print(self.conversations[0].other_user_name)
                    print("successfully get conversation models")
                case .failure(let error):
                    print("empty or failed to get convos T__T \(error)")
            }
            self.tableView.reloadData()
        }
        }
    
    private func fetchProfileImage(){
        
        guard let userEmail = currentUserEmail else{return}
        let currentEmail = DatabaseManger.shared.safeEmail(userEmail: userEmail)
        //get current user name:
        DatabaseManger.shared.searchUser(email: currentEmail, completion: { result in
            switch result {
            case .success(let c_user):
               
                if let path = c_user[UserKeyName.profileImageURL] as? String {
                    DefaultManager.saveValues(value: path, valueType: .profileImageURL)
                if let profile_Image = StorageManager.shared.downloadURL(for: path) {
                    self.profileImage = profile_Image
                    self.imageProfileButton.setImage(profile_Image, for: .normal)
                }
                }
            case .failure(let error):
                print("failed get image\(error)")
                return
                }
        })
    }
    func prepareFriendImage(urlImage : String){
        
        if let profile_Image = StorageManager.shared.downloadURL(for: urlImage) {
            self.friendProfileImage = profile_Image
            
        }
    }
}
extension ConversationsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ConvTableViewCell
       // cell.accessoryType = .disclosureIndicator
        
        cell.friendNameLabel.text = conversations[indexPath.row].other_user_name
        
        guard let frind_Image = friendProfileImage else{return cell}
        cell.frindPicture = frind_Image
        
        return cell
    }
    
    // when user taps on a cell, we want to push the chat screen onto the stack
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            
            let chatVC = storyboard?.instantiateViewController(identifier: "ChatViewController") as! ChatViewController
            chatVC.title = conversations[indexPath.row].other_user_name
            
            // send data :
        
            chatVC.otherUserEmail = conversations[indexPath.row].other_user_email
            chatVC.conversationId = conversations[indexPath.row].conversationId
            self.navigationController?.pushViewController(chatVC , animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}


