

import Foundation
import FirebaseFirestoreSwift

struct User:Codable {
    
    var id : String
    var username : String
    var email : String
    var pushID : String
    var avatarLink : String
    var status : String
    
    
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
