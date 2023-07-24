
import Foundation
import Firebase
import FirebaseFirestoreSwift

class FMSGListner {
    
    static let shared = FMSGListner()
    var newMessageListner : ListenerRegistration!
    
    private init () {}
    
    func addMessage (_ message : LocalMessage , memberId : String) {
        
        do {
            try FirestoreReferance(.Message).document(memberId).collection(message.chatRoomId).document(message.id).setData(from: message)
        } catch {
            print("error saving messsage to firestore" , error.localizedDescription)
        }
    }
    // MARK: - check for old messages
    
    func checkForOldMessages(_ documentId : String , collectionId : String){
        FirestoreReferance(.Message).document(documentId).collection(collectionId).getDocuments { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                return
            }
            var oldMessages = documents.compactMap { (querySnapShot) -> LocalMessage in
                return try! querySnapShot.data(as: LocalMessage.self)
                
            }
            oldMessages.sorted(by: {$0.date < $1.date})
            for message in oldMessages {
                RealmManager.shared.save(message)
            }
        }
    }
    
    func listenForNewMessages (_ documentId : String , collectionId : String , lastMessageDate : Date) {
        
        newMessageListner = FirestoreReferance(.Message).document(documentId).collection(collectionId).whereField(KDATE, isGreaterThan: lastMessageDate).addSnapshotListener({ (querySnapshot , error) in
            
            guard let snapshot = querySnapshot else {return}
            for change in snapshot.documentChanges {
                if change.type == .added {
                    
                    let result = Result {
                        try? change.document.data(as : LocalMessage.self)
                    }
                    
                    switch result {
                    case .success(let messageObject):
                        if let message = messageObject {
                            if message.senderId != User.currentId {
                                RealmManager.shared.save(message)
                            }
                        }
                        
                    case .failure(let error) :
                        print(error.localizedDescription)
                        
                        
                    }
                    
                }
            }
            
        })
        
    }
    
}
