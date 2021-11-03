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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set the background
          self.view.backgroundColor = UIColor(patternImage: UIImage(named: "space back 30p.png")!)
        self.title = "Chat"
        
        tableView.dataSource = self
        tableView.delegate = self
 
          }
          override func viewDidAppear(_ animated: Bool) {
              super.viewDidAppear(animated)
            
              validateAuth()
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


extension ConversationsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath)
        cell.textLabel?.text = "Hello World"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    // when user taps on a cell, we want to push the chat screen onto the stack
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            
            let chatVC = storyboard?.instantiateViewController(identifier: "ChatViewController") as! ChatViewController
            chatVC.title = "Jenny Smith"
               self.navigationController?.pushViewController(chatVC , animated: true)
        }
    
    
   
}


