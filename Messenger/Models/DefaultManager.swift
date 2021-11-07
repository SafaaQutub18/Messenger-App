//
//  DefaultManager.swift
//  Messenger
//
//  Created by administrator on 07/11/2021.
//

import Foundation

enum ValueType : String{
    case email
    case userId
    case userName
    case profileImageURL
}

class DefaultManager{
    
    static func saveValues(value : String, valueType : ValueType ){
       let pref = UserDefaults.standard
        
        if var userObj = pref.value(forKey: UserKeyName.userObj) as? [String:Any]{
            userObj[valueType.rawValue] = value
            pref.set(userObj, forKey: UserKeyName.userObj)
            print(value)

        }
        else {
            let userObj = [valueType.rawValue : value]
            pref.set(userObj, forKey: UserKeyName.userObj)
        }
        pref.synchronize()
}
    
    static func getValues(valueType : ValueType) -> String? {
        let pref = UserDefaults.standard
        if let userObj = pref.value(forKey:UserKeyName.userObj) as? [String:Any]{
            if let value = userObj[valueType.rawValue] as? String {
                return value
            }
        }
        return nil
    }
    

}

