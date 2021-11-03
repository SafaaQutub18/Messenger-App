//
//  NewConversationViewController.swift
//  Messenger
//
//  Created by administrator on 27/10/2021.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import FirebaseAuth
//// message model
struct Message: MessageType {
    
    public var sender: SenderType // sender for each message
    public var messageId: String // id to de duplicate
    public var sentDate: Date // date time
    public var kind: MessageKind //
}
//// sender model
struct Sender: SenderType {
    public var photoURL: String? // extend with photo URL
    public var senderId: String
    public var displayName: String
}

class ChatViewController: MessagesViewController  {
  
    private func safeEmail(userEmail : String) -> String {
        var safeEmail = userEmail.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
  
    public var otherUserEmail: String?
    private var conversationId: String?
    public var isNewConversation = false
    private var messages = [Message]()
    
    private var selfSender: Sender? {
        guard let userId = Auth.auth().currentUser?.uid else {
               // we cache the user email
               return nil
           }
           return Sender(photoURL: "", senderId: userId, displayName: "Me")
       }
//
//    init(with email: String, id: String?) {
//           self.conversationId = id
//           self.otherUserEmail = email
//           super.init(nibName: nil, bundle: nil)
//
//    }
//
//        // creating a new conversation, there is no identifier

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "space back 30p.png")!)
        
            messagesCollectionView.messagesDataSource = self
            messagesCollectionView.messagesLayoutDelegate = self
            messagesCollectionView.messagesDisplayDelegate = self
            messageInputBar.delegate = self
    }
    
    func insertMessage(messegeText : String ){
        let message_Id = createMessageId()
        
        if let self_Sender = selfSender , let messageId = message_Id  {
        let message =  Message(sender: self_Sender, messageId: messageId, sentDate: Date(), kind: .text(messegeText))
        messages.append(message)
        print(message)
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToLastItem()

//            if isNewConversation {
//                       // create convo in database
//                       // message ID should be a unique ID for the given message, unique for all the message
//                       // use random string or random number
//                       DatabaseManger.shared.createNewConversation(with: otherUserEmail, name: self.title ?? "User", firstMessage: message) { [weak self] success in
//                           if success {
//                               print("message sent")
//                               self?.isNewConversation = false
//                           }else{
//                               print("failed to send")
//                           }
//                       }
//
//                   }else {
//                       guard let conversationId = conversationId, let name = self.title else {
//                           return
//                       }
        }
        
    }
    
}

extension ChatViewController :  InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
            print("sending \(text)")
        insertMessage(messegeText: text)
            
        }
    
    private func createMessageId() -> String? {
            // date, otherUserEmail, senderEmail, randomInt possibly
            // capital Self because its staticcopy
        
        guard let userId = Auth.auth().currentUser?.uid else {
               // we cache the user email
               return nil
           }
            
            let dateString = Self.dateFormatter.string(from: Date())
        
        let newIdentifier = "\(otherUserEmail ?? "15")_\(userId)_\(dateString)"
        
        
            print("created message id: \(newIdentifier)")
            return newIdentifier
            
        }
    public static var dateFormatter: DateFormatter = {
           let formatter = DateFormatter()
           formatter.dateStyle = .medium
           formatter.timeStyle = .long
           formatter.locale = .current
           return formatter
       }()
    }

extension ChatViewController : MessagesDataSource  {
    
    func currentSender() -> SenderType {
        return Sender(senderId: "12", displayName: "")
    }
    //return the message for the given index path.
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]    }
    
    //Each message takes up a section in the collection view.
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        messages.count
    }
}

extension ChatViewController: MessagesDisplayDelegate {
  // 1
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
          return isFromCurrentSender(message: message) ?
        UIColor(red: 0.85, green: 0.58, blue: 0.64, alpha: 1.00):
        UIColor(red: 0.83, green: 0.77, blue: 0.98, alpha: 1.00)
        }

  // 2
  func shouldDisplayHeader(
    for message: MessageType,
    at indexPath: IndexPath,
    in messagesCollectionView: MessagesCollectionView
  ) -> Bool {
    return false
  }

  // 3
  func configureAvatarView(
    _ avatarView: AvatarView,
    for message: MessageType,
    at indexPath: IndexPath,
    in messagesCollectionView: MessagesCollectionView
  ) {
    avatarView.isHidden = true
  }

  // 4
  func messageStyle(
    for message: MessageType,
    at indexPath: IndexPath,
    in messagesCollectionView: MessagesCollectionView
  ) -> MessageStyle {
    let corner: MessageStyle.TailCorner =
      isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
    return .bubbleTail(corner, .curved)
  }
}

extension ChatViewController: MessagesLayoutDelegate {
  // 1
  func footerViewSize(
    for message: MessageType,
    at indexPath: IndexPath,
    in messagesCollectionView: MessagesCollectionView
  ) -> CGSize {
    return CGSize(width: 0, height: 8)
  }

  // 2
  func messageTopLabelHeight(
    for message: MessageType,
    at indexPath: IndexPath,
    in messagesCollectionView: MessagesCollectionView
  ) -> CGFloat {
    return 20
  }
}



//

//
