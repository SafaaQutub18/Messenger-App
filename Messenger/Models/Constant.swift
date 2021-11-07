//
//  Constant.swift
//  Messenger
//
//  Created by administrator on 03/11/2021.
//

import Foundation


struct User {
    let userName: String
    let userEmail: String
    let userPassword: String
    let profilePictureUrl: String?
    
    // create a computed property safe email
    var safeEmail: String {
        var safeEmail = userEmail.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}

struct Conversation {
    let conversationId : String
    let other_user_email : String
    let other_user_name : String
    //let latest_message: String?
    //let date : Date?
  //  let messages : Message?
    //let senderID : String
}

struct UserKeyName{
    static let email = "email"
    static let password = "password"
    static let userId = "userId"
    static let username = "userName"
    static let profileImageURL = "profile_image_url"
    static let users = "users"
    static let userObj = "userObj"
}
    
struct ConversationKey {
    static let conversation = "conversation"
    static let conversationId = "conversationId"
    static let other_user_email = "other_user_email"
    static let other_user_name = "other_user_name"
    static let messagesaArray = "messagesaArray"
    static let senderID = "senderID"
}
struct MessageKey {
    static let messages = "messages"
    static let sender = "sender"
    static let messageId = "messageId"
    static let sentDate = "sentDate"
    static let kind = "kind"
    static let messageText = "messageText"
    static let senderEmail = "senderEmail"
    static let reciverrName = "reciverrName"
    
}
