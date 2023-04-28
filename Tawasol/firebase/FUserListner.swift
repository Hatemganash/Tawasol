
import Foundation
import Firebase


class FUserListner {
    
    static let shared = FUserListner()
    
    private init () {
        
    }
    
    //MARK: - Register & Login
    
    // MARK: -  Login
    
    func loginUserWith (email : String , password : String , completion : @escaping (_ error : Error? , _ isEmailVerified : Bool)-> Void){
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if error == nil && authResult!.user.isEmailVerified {
                completion(error , true)
                self.downloadUserFromFirestore(userId :authResult!.user.uid)
            }else {
                completion(error , false)
            }
        }
        
    }
    
    // MARK: -  Forget Password
    
    func resetPasswordFor (email : String , completion : @escaping (_ error : Error?)->Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
            
        }
    }
    
    
    // MARK: - LogOut
    
    func logoutCurrentUser(completion : @escaping (_ error : Error?)-> Void){
        
        do {
            try Auth.auth().signOut()
            userDefaults.removeObject(forKey: kCurrentUser)
            userDefaults.synchronize()
            completion(nil)
        } catch let error as NSError {
            completion(error)
        }
        
    }
    
    
    
    // MARK: - Register
    
    func registerUserWith (email :String , password : String , completion : @escaping ( _ error : Error?) -> Void ) {
        Auth.auth().createUser(withEmail: email, password: password) {[self] authResults, error in
            completion(error)
            if error == nil {
                authResults!.user.sendEmailVerification { error in
                    completion(error)
                }
            }
            if authResults?.user != nil {
                let user = User(id: authResults!.user.uid, username: email, email: email, pushID: "" , avatarLink: "", status: "Hey , My Name Is Hatem")
                
                saveUserToFirestore(user)
                saveUserLocally(user)
            }
        }
        
    }
    
    // MARK: - Resend Email
    
    func resendVerficationEmailWith (email : String , completion : @escaping (_ error :Error?)->Void){
        
        Auth.auth().currentUser?.reload(completion: { error in
            Auth.auth().currentUser?.sendEmailVerification(completion: { error in
                completion (error)
            })
        })
        
    }
    
    private func saveUserToFirestore (_ user : User){
        
        do{
            try FirestoreReferance(.User).document(user.id).setData(from : user)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Dowenload user from firestore
    
    private func downloadUserFromFirestore (userId : String){
        FirestoreReferance(.User).document(userId).getDocument { document, error in
            guard let userDocument = document else {
                print("no data found")
                return
            }
            
            let result = Result {
                try? userDocument.data(as: User.self)
                
            }
            switch result {
            case .success(let userObject):
                if let user = userObject {
                    saveUserLocally(user)
                } else {
                    print("Document does not exist")
                }
            case .failure(let error) :
                print("error decoding user",error.localizedDescription)
            }
            
        }
    }
    
}
