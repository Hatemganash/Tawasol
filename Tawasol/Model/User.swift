

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct User:Codable , Equatable {
    
    var id : String
    var username : String
    var email : String
    var pushID : String
    var avatarLink : String
    var status : String
    
    
    static var currentId : String {
        return Auth.auth().currentUser!.uid
    }
    
    static var currentUser : User? {
        if Auth.auth().currentUser != nil {
            
            if let data = userDefaults.data(forKey: kCurrentUser){
                let decoder = JSONDecoder()
                do {
                    let userObject = try decoder.decode(User.self, from: data)
                    return userObject
                } catch {
                    print (error.localizedDescription)
                }
            }
        }
        return nil
    }
    static func == (lhs : User , rhs : User) -> Bool {
        lhs.id == rhs.id
    }
    
}

func saveUserLocally(_ user : User){
    
    let encoder = JSONEncoder()
    do {
        let data = try encoder.encode(user)
        userDefaults.set (data , forKey: kCurrentUser)
    } catch{
        print(error.localizedDescription)
    }
    
    
}

func createDummyUsers(){
    print("creating Dummy users ...")

    let names = ["Kareem Ashraf" , "Ashraf" , "Merna" , "Mahmoud Maged" , "Amira"]
    
    var imageIndex = 1
    var userIndex = 1
    
    for i in 0..<5 {
        let id = UUID().uuidString
        let fileDirectory = "Avatars/" + "_\(id)" + ".jpg"
        FileStorage.uploadImage(UIImage(named: "user\(imageIndex)")!, directory: fileDirectory) { avatarLink in
            let user = User(id: id, username: names[i], email: "user\(userIndex)@mail.com", pushID: "", avatarLink: avatarLink ?? "" , status: "No Status")
            
            userIndex += 1
            FUserListner.shared.saveUserToFirestore(user)
        }
        imageIndex += 1
        if imageIndex == 5 {
            imageIndex = 1
        }
        
    }
    
}
