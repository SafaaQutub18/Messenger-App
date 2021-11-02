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
            let vc = ChatViewController()
                    vc.title = "Jenny Smith"
                    vc.navigationItem.largeTitleDisplayMode = .never
                    navigationController?.pushViewController(vc, animated: true)
        }
    
    
   
}


