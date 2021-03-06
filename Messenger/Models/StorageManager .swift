//
//  StorageManager .swift
//  Messenger
//
//  Created by administrator on 03/11/2021.
//

import Foundation
import FirebaseStorage
import FirebaseAuth
import UIKit
final class StorageManager {
    
    static let shared = StorageManager() // static property so we can get an instance of this storage manager
    
    private let storage = Storage.storage().reference()
    
    // function takes in bytes and add a filename where it should be written to
    // once this has been uploaded, we want to hand back the download URL for the image
    /*
     /images/jmh3434-gmail-com_profile_picture.png - using this storage object
     */
    
    public typealias UploadPictureCompletion = (Result<String, Error>) -> Void // type alias makes things cleaner
    
    /// Uploads picture to firebase storage and returns completion with url string to download
    public func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion){
        // return a string of the download URL
        // if we succeed, return a string, otherwise return error
        
        storage.child("images/profileImage_\(fileName).png").putData(data, metadata: nil) { metadata, error in
            guard error == nil else {
                // failed
                print("failed to upload data to firebase for picture")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            self.storage.child("images/profileImage_\(fileName).png").downloadURL { url, error in
                guard let url = url else {
                    print("Failed to get download url")
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }
                
                let urlString = url.absoluteString
                
                print("download url returned: \(urlString)")
                
                completion(.success(urlString))
            }
        }
        
    }
    
    public func downloadURL(for path: String ) -> UIImage? {
        let url = URL(string:path)
        
          if let data = try? Data(contentsOf: url!)
          {
              let image: UIImage = UIImage(data: data)!
              return image
          }
        return nil
    }
    
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDownloadUrl
    }
}
