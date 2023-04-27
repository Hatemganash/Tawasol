

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct User:Codable {
    
    var id : String
    var username : String
    var email : String
    var pushID : String
    var avatarLink : String
    var status : String
    
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
