//
//  DatabaseManager.swift
//  Messenger
//
//  Created by administrator on 31/10/2021.
//



import Foundation
import FirebaseDatabase
import MessageKit
// singleton creation below
// final - cannot be subclassed
final class DatabaseManger {
    public var userDefault = UserDefaults.standard
    
    static let shared = DatabaseManger()
    
    // reference the database below
    
    private let database = Database.database().reference()
    
    // create a simple write function
    
    
    public func safeEmail(userEmail : String) -> String {
        var safeEmail = userEmail.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}
extension DatabaseManger {
    
    // have a completion handler because the function to get data out of the database is asynchrounous so we need a completion block
    
  
    
    public func insertUser(with user: User,userID: String, completion: @escaping (Bool) -> Void){
        let email = user.safeEmail.lowercased()
        let userDict : [String : String] = [UserKeyName.email:email,UserKeyName.username:user.userName]
        //let userObj = [userID:userDict]
           // adding completion block here so once it's done writing to database, we want to upload the image
           
           // once user object is creatd, also append it to the user's collection
        
        database.child(UserKeyName.users).child(email).setValue(userDict) { error, _ in
               guard error  == nil else {
                   print("failed to write to database")
                   completion(false)
                   return
               }
            self.database.child(UserKeyName.users).child(email).observeSingleEvent(of: .value, with:  { Snapshot in
                completion(true)
            }) {error in
                print("something wrong in insertUser func.")
                completion(false)
                
            }
            
          /*  self.database.child(UserKeyName.users).observeSingleEvent(of: .value) { snapshot in
                           // snapshot is not the value itself
                           if var usersCollection = snapshot.value as? [[String: String]] {
                               // if var so we can make it mutable so we can append more contents into the array, and update it
                               // append to user dictionary
                               
                               usersCollection.append(userDict)
                               
                               self.database.child(UserKeyName.users).setValue(usersCollection) { error, _ in
                                   guard error == nil else {
                                       completion(false)
                                       return
                                   }
                                   completion(true)
                               }
                               
                           }else{
                               // create that array
                               let newCollection: [[String: String]] = [userDict]
                               
                               self.database.child(UserKeyName.users).setValue(newCollection) { error, _ in
                                   guard error == nil else {
                                       completion(false)
                                       return
                                   }
                                   completion(true)
                               }
                   }
               }*/
           }
       }
    
/*
    public func getAllUsers(completion: @escaping (Result<[[String: String]], Error>) -> Void){
           database.child(UserKeyName.users).observeSingleEvent(of: .value) { snapshot in
               guard let value = snapshot.value as? [[String: String]] else {
                   completion(.failure(DatabaseError.failedToFetch))
                   return
               }
               completion(.success(value))
               
           }
       }
    public func getUserData(for userId: String , completion: @escaping (Result<[String:String] , Error>) -> Void ) {
        database.child(UserKeyName.email).child(UserKeyName.username).observeSingleEvent(of: .value ) { snapshot in
            guard let userDict = snapshot.value as? [ String:String ] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(userDict))
        }
    }
 */
    public func searchUser(email : String ,completion: @escaping (Result<[String: Any], Error>) -> Void){
         print("emaaaaaaaaaaaaaale : "+safeEmail(userEmail: email))
        database.child(UserKeyName.users).child(safeEmail(userEmail: email)).observeSingleEvent(of: .value ) { snapshot in
             guard let userDict = snapshot.value as? [ String:Any ] else {
                 completion(.failure(DatabaseError.failedToFetch))
                 return
             }
             completion(.success(userDict))
         }
         
     }

       public enum DatabaseError: Error {
           case failedToFetch
       }
   }

extension DatabaseManger {
    
 // conversations
    public func insertNewConv(with conv: Conversation, completion: @escaping (Bool) -> Void){
        //get currnt user name:
        
        let currentName = UserDefaults.standard.value(forKey: UserKeyName.username)
        let currentEmail = safeEmail(userEmail: UserDefaults.standard.value(forKey: UserKeyName.email) as! String)
        let otherUserEmail = safeEmail(userEmail: conv.other_user_email)
        
        // fetch current user
        self.database.child(UserKeyName.users).child("\(currentEmail)").observeSingleEvent(of: .value) { [weak self] snapshot in
            // what we care about is the conversation for this user
            guard var userNode = snapshot.value as? [String: Any] else {
                // we should have a user
                completion(false)
                print("user not found")
                return
            }
        
        let newConversationDict: [String:Any] = [
            ConversationKey.conversationId : conv.conversationId,
            ConversationKey.other_user_email : conv.other_user_email,
            ConversationKey.other_user_name : conv.other_user_name,
            ConversationKey.messagesaArray: [] ]
            //
        let recipient_newConversationDict: [String:Any] = [
            ConversationKey.conversationId : conv.conversationId ,
            ConversationKey.other_user_email: currentEmail, // us, the sender email
            ConversationKey.other_user_name: currentName!,  // self for now, will cache later
            ConversationKey.messagesaArray: [] ]
        
        // update recipient conversation entry
            self?.database.child(UserKeyName.users).child("\(otherUserEmail)/conversations").observeSingleEvent(of: .value) { [weak self] snapshot in
                        // if there other conversations
                if var conversations = snapshot.value as? [[String: Any]] {
                    // append
                    conversations.append(recipient_newConversationDict)
                    self?.database.child(UserKeyName.users).child("\(otherUserEmail)/conversations").setValue(conv.conversationId)
                }
            //
                else {
                    // reciepient user doesn't have any conversations, we create them
                    // create
                    self?.database.child(UserKeyName.users).child("\(otherUserEmail)/conversations").setValue([recipient_newConversationDict])
                        }
                    }
            // update current user conversation entry
                       
            if var conversations = userNode["conversations"] as? [[String: Any]] {
                    // conversation array exits for current user, you should append
                
                    // points to an array of a dictionary with quite a few keys and values
                    // if we have this conversations pointer, we would like to append to it
                           
                    conversations.append(newConversationDict)
                           
                           userNode["conversations"] = conversations // we appended a new one
                           
                    self?.database.child(UserKeyName.users).child("\(currentEmail)").setValue(userNode) { [weak self] error, _ in
                               guard error == nil else {
                                   completion(false)
                                   return
                               }
                        
                    //self?.finishCreatingConversation(name: name, conversationID: conversationId, firstMessage: firstMessage, completion: completion)
                           }
                }else {
                           // create this conversation
                           // conversation array doesn't exist
                           
                           userNode["conversations"] = [
                               newConversationDict
                           ]
                           
                    self?.database.child(UserKeyName.users).child("\(currentEmail)").setValue(userNode) { [weak self] error, _ in
                               guard error == nil else {
                                   completion(false)
                                   return
                               }
                             //  self?.finishCreatingConversation(name: name, conversationID: conversationId, firstMessage: firstMessage, completion: completion)
                           }
                           
                       }
                       
                   }
                   
    }
    public func getAllConversations(for email: String, completion: @escaping (Result<[Conversation], Error>) -> Void) {
        print("inside getAllConv: " +  email)
        database.child(UserKeyName.users).child("\(email)/conversations").observeSingleEvent(of: .value )  { snapshot in
               // new conversation created? we get a completion handler called
               guard let value = snapshot.value as? [[String:Any]] else {
                   completion(.failure(DatabaseError.failedToFetch))
                   return
               }
               let conversations: [Conversation] = value.compactMap { dictionary in
                   guard let conversationId = dictionary[ConversationKey.conversationId] as? String,
                         let name = dictionary[ConversationKey.other_user_name] as? String,
                         let otherUserEmail = dictionary[ConversationKey.other_user_email] as? String else {
                       //  let latestMessage = dictionary["latest_message"] as? [String: Any],
                       // let date = latestMessage["date"] as? String,
                       //  let message = latestMessage["message"] as? String,
                       //  let isRead = latestMessage["is_read"] as? Bool else {
                       return nil
                   }
                   
                   // create model
                   
                 //  let latestMessageObject = LatestMessage(date: date, text: message, isRead: isRead)
                   
                   return Conversation(conversationId: conversationId, other_user_email: otherUserEmail, other_user_name: name)
                   //Conversation(conversationId: conversationId, other_user_email: name, other_user_email: otherUserEmail , latestMessage: latestMessageObject)
               }
               
               completion(.success(conversations))
               
           }
       }
    
}

extension DatabaseManger{
    
    // messages functions :
    
    public func sendMessage(to conversationId: String, name: String,text:String, newMessage: Message, completion: @escaping (Bool) -> Void) {
        
        let currentName = UserDefaults.standard.value(forKey: UserKeyName.username)
        let currentEmail = safeEmail(userEmail: UserDefaults.standard.value(forKey: UserKeyName.email) as! String)
        let conversationID = safeEmail(userEmail: conversationId)
        
        let newMessageEntry: [String: Any] = [
                        "id": newMessage.messageId,
                        "type": newMessage.text,
                        "content": newMessage.text,
                        "date": newMessage.sentDate,
                        "sender_email": currentEmail,
                       // "is_read": false,
                        "name": name,
        ]
        let value: [String:Any] = ["messages": [newMessageEntry]]
        
        database.child("\(conversationID)").setValue(value) { error, _ in
                  guard error == nil else {
                      completion(false)
                      return
                  }
                  completion(true)
              }
        
        self.database.child("\(conversationID)/messages").observeSingleEvent(of: .value) { [weak self] snapshot in
                    
                    guard let strongSelf = self else {
                        return
                    }
                    
                    guard var currentMessages = snapshot.value as? [[String: Any]] else {
                        completion(false)
                        return
                    }
            print("كرنت ماسج  \(currentMessages) as! String")
    
        
    }
}
}
