//
//  ConversationViewController.swift
//  Messenger
//
//  Created by administrator on 27/10/2021.
//

import UIKit
import FirebaseAuth

class ConversationsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var conversations = [Conversation]()
    let currentUserEmail = UserDefaults.standard.value(forKey: UserKeyName.email) as? String
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set the background
        self.title = "Chat"
        tableView.dataSource = self
        tableView.delegate = self
        
        //fetchConversations()
        }
    
          override func viewDidAppear(_ animated: Bool) {
              super.viewDidAppear(animated)
              validateAuth()
              fetchConversations()
              
          }
    
    @IBAction func addConversationButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "New Friend *_*",
                                      message: "Add a new Friend",
                                      preferredStyle: .alert)
        
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
        do {
            try FirebaseAuth.Auth.auth().signOut()
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
            
           }
           catch {
           }
    }
    
}

extension ConversationsViewController {
    
    func addNewConversation(reciverInfo : [String: Any]){
        // create conv. id  :
        
        if let reciverEmail = reciverInfo[UserKeyName.email] as? String, let reciverName = reciverInfo[UserKeyName.username] as? String{
      //  let currentUserEmail = UserDefaults.standard.value(forKey: UserKeyName.email) as! String
            let conversationID = DatabaseManger.shared.safeEmail(userEmail: currentUserEmail!) + "_" + DatabaseManger.shared.safeEmail(userEmail: reciverEmail)
            
       // let senderId = UserDefaults.standard.value(forKey: UserKeyName.userId) as! String
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
        let currentEmail = DatabaseManger.shared.safeEmail(userEmail: currentUserEmail!)
        DatabaseManger.shared.getAllConversations(for: currentEmail) { result in
            switch result {
                case .success(let convArray):
                self.conversations = convArray
                print(self.conversations[0].other_user_name)
                    print("successfully get conversation models")
                case .failure(let error):
                    print("failed to get convos T__T \(error)")
            }
            self.tableView.reloadData()
        }
        }
}
extension ConversationsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath)
        cell.textLabel?.text = conversations[indexPath.row].other_user_name
        cell.accessoryType = .disclosureIndicator
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
}


