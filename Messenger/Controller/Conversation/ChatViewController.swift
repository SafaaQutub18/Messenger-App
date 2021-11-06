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
    public var text:String
}
//// sender model
struct Sender: SenderType {
    public var photoURL: String? // extend with photo URL
    public var senderId: String
    public var displayName: String
}

class ChatViewController: MessagesViewController  {
    var m : Message?
    
  
    private func safeEmail(userEmail : String) -> String {
        var safeEmail = userEmail.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail.lowercased()
    }
  
    public var otherUserEmail: String?
    public var conversationId: String?
    public var isNewConversation = true
    public var messages = [Message]()
    
    private var selfSender: Sender? {
        guard let email = UserDefaults.standard.value(forKey: UserKeyName.email) as? String else {
                // we cache the user email
                return nil
        }
        
        let safeEmail = DatabaseManger.shared.safeEmail(userEmail: email)
        return Sender(photoURL: "", senderId: safeEmail, displayName: "Me")
    }
    
    // creating a new conversation, there is no identifier
    override func viewDidLoad() {
        super.viewDidLoad()
            messagesCollectionView.messagesDataSource = self
            messagesCollectionView.messagesLayoutDelegate = self
            messagesCollectionView.messagesDisplayDelegate = self
            messageInputBar.delegate = self
    }
    
     override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
         messageInputBar.inputTextView.becomeFirstResponder()
         
//         if let conversationId = conversationId {
//             listenForMessages(id:conversationId, shouldScrollToBottom: true)
//         }
     }
    
    func insertMessage(messegeText : String ){
        let message_Id = createMessageId()
        
        if let self_Sender = selfSender , let messageId = message_Id  {
            let message =  Message(sender: self_Sender, messageId: messageId, sentDate: Date(), kind: .text(messegeText), text: messegeText)
        messages.append(message)
        print(message)
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToLastItem()

//
        guard let conversationId = conversationId, let name = self.title else {
                    return
            }
                // append to existing conversation data
        print("مدري وش ذا" + name)
            DatabaseManger.shared.sendMessage(to: conversationId, name: name, text: messegeText, newMessage: message) { success in
                if success {
                    print("message sent")
                }else {
                    print("failed to send")
                }
            }
        }
    }
       
//         func listenForMessages(id: String, shouldScrollToBottom: Bool) {
//               DatabaseManger.shared.getAllMessagesForConversation(with: id) { [weak self] result in
//                   switch result {
//                   case .success(let messages):
//                       print("success in getting messages: \(messages)")
//                       guard !messages.isEmpty else {
//                           print("messages are empty")
//                           return
//                       }
//                       self?.messages = messages
//
//                       DispatchQueue.main.async {
//                           self?.messagesCollectionView.reloadDataAndKeepOffset()
//
//                           if shouldScrollToBottom {
//                               self?.messagesCollectionView.scrollToLastItem()
//                           }
//                       }
//
//                   case .failure(let error):
//                       print("failed to get messages: \(error)")
//                   }
//               }
//           }
}

extension ChatViewController :  InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
            print("sending \(text)")
        insertMessage(messegeText: text)

        // Save the message to the Firestore database.
      //  save(message)

        // 3
        inputBar.inputTextView.text = ""
    }
    
    private func createMessageId() -> String? {
            // date, otherUserEmail, senderEmail, randomInt possibly
            // capital Self because its staticcopy
        
        guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String else {
                    return nil
                }
            
        let dateString = Self.dateFormatter.string(from: Date())
        
        let newIdentifier = "\(otherUserEmail!)_\(currentUserEmail)_\(dateString)"
        
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
    // 4
    func messageTopLabelAttributedText( for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
      let name = message.sender.displayName
      return NSAttributedString(
        string: name,
        attributes: [
          .font: UIFont.preferredFont(forTextStyle: .caption1),
          .foregroundColor: UIColor(white: 0.3, alpha: 1)
        ])
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
