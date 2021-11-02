//
//  NewConversationViewController.swift
//  Messenger
//
//  Created by administrator on 27/10/2021.
//

import UIKit
import MessageKit
import InputBarAccessoryView


class ChatViewController: UIViewController {
    
//    public let otherUserEmail: String?
//    private let conversationId: String?
//    public var isNewConversation = false
//   // private var messages = [Message]()

    
//       init(with email: String, id: String?) {
//           self.conversationId = id
//           self.otherUserEmail = email
//           super.init(nibName: nil, bundle: nil)
//           
//           // creating a new conversation, there is no identifier
//       }
//    
//    required init?(coder: NSCoder) {
//           fatalError("init    (coder:) has not been implemented")
//       }
//    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    

}
//extension ChatViewController : MessagesDataSource , MessagesLayoutDelegate, MessagesDisplayDelegate {
//
//    func currentSender() -> SenderType {
//        return Sender(senderId: user.uid, displayName: AppSettings.displayName)
//    }
//
//    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
//        <#code#>
//    }
//
//    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
//        messages.count
//    }
//
//
//}

// message model
struct Message: MessageType {
    
    public var sender: SenderType // sender for each message
    public var messageId: String // id to de duplicate
    public var sentDate: Date // date time
    public var kind: MessageKind //
}
// sender model
struct Sender: SenderType {
    public var photoURL: String? // extend with photo URL
    public var senderId: String
    public var displayName: String
}

