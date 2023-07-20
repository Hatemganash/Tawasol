
import Foundation
import Firebase
import FirebaseFirestoreSwift

class FMSGListner {
    
    static let shared = FMSGListner()
    
    private init () {}
    
    func addMessage (_ message : LocalMessage , memberId : String) {
        
        do {
            try FirestoreReferance(.Message).document(memberId).collection(message.chatRoomId).document(message.id).setData(from: message)
        } catch {
            print("error saving messsage to firestore" , error.localizedDescription)
        }
    }
}
