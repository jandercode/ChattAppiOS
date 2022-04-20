//
//  StorageManager.swift
//  ChattAppRealm
//
//  Created by Luca Salmi on 2022-04-13.
//

import Foundation
import Firebase
import SwiftUI

class StorageManager: ObservableObject{
    let storage = Storage.storage()
    //storage reference for default image
    let defaultUserImageKey = "defaultimg"
    
    
    
    func upload(image: UIImage, id: String){
        
        let storageRef = storage.reference().child("images/\(id)")
        
        
        // Resize the image to 200px in height with a custom extension
        let targetSize = CGSize(width: 100, height: 100)

        // Compute the scaling ratio for the width and height separately
        let widthScaleRatio = targetSize.width / image.size.width
        let heightScaleRatio = targetSize.height / image.size.height

        // To keep the aspect ratio, scale by the smaller scaling ratio
        let scaleFactor = min(widthScaleRatio, heightScaleRatio)

        // Multiply the original image’s dimensions by the scale factor
        // to determine the scaled image size that preserves aspect ratio
        let _ = CGSize(
            width: image.size.width * scaleFactor,
            height: image.size.height * scaleFactor
        )

        // Convert the image into JPEG and compress the quality to reduce its size
        let data = image.jpegData(compressionQuality: 0.2)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        if let data = data {
                storageRef.putData(data, metadata: metadata) { (metadata, error) in
                        if let error = error {
                                print("Error while uploading file: ", error)
                        }

                        if let metadata = metadata {
                                print("Metadata: ", metadata)
                        }
                }
        }
        
    }
    
    
    func listAllImages(){
        
        let storageRef = storage.reference().child("images")
        
        storageRef.listAll { (result, error) in
                if let error = error {
                        print("Error while listing all files: ", error)
                }

                for item in result.items {
                        print("Item in images folder: ", item)
                }
        }
    }
    
    func listItem(name: String){
        // Create a reference
        let storageRef = storage.reference().child("images/\(name)")

        // Create a completion handler - aka what the function should do after it listed all the items
        let handler: (StorageListResult, Error?) -> Void = { (result, error) in
            if let error = error {
                print("error", error)
            }

            let item = result.items
            print(item)
        }

        // List the items
        storageRef.list(maxResults: 1, completion: handler)
    }
    
    func loadChatProfilePics(){
        
        let allUsers = FirestoreContactDao.firestoreContactDao.registeredUsers
        
            for user in allUsers{
                    
                let imageRef = storage.reference().child("images/\(user.id)")
                imageRef.getData(maxSize: 1*1024*1024){ data, error in
                    
                    if let _ = error{
                        
                        UserManager.imageArray[user.id] = UIImage(imageLiteralResourceName: "profile-pic")
                        
                    }else{
                        
                        UserManager.imageArray[user.id] = UIImage(data: data!)!
                        print(UserManager.imageArray.count)
                        
                    }
                }
                print("loading done!!")
            }
    }
    
    
    
    
    func loadImageFromStorage(id: String){
        
        let imageRef = storage.reference().child("images/\(id)")
        
        imageRef.getData(maxSize: 1*1024*1024){ data, error in
            
            if let _ = error{
                
                    UserManager.userManager.userImage = UIImage(systemName: "person.circle")
                
                
            }else{
                
                    UserManager.userManager.userImage = UIImage(data: data!)
                
            }
        }
    }
    
    func loadImageFromStorageToArray(id: String){
        
        let imageRef = storage.reference().child("images/\(id)")
        
        imageRef.getData(maxSize: 1*1024*1024){ data, error in
            
            if let _ = error{
                
                    UserManager.imageArray[id] = UIImage(systemName: "person.circle")
                
                
            }else{
                
                    UserManager.imageArray[id] = UIImage(data: data!)
                
            }
        }
    }

        // You can use the listItem() function above to get the StorageReference of the item you want to delete
    func deleteItem(item: StorageReference) {
        item.delete { error in
            if let error = error {
                print("Error deleting item", error)
            }
        }
    }
    
}