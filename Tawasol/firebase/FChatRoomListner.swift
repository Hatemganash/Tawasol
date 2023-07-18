
import Foundation
import Firebase

class FChatRoomListner {
    
    static let shared = FChatRoomListner()
    private init () {}
    
    func saveChatRoom (_ chatRoom : ChatRoom) {
        do {
          try FirestoreReferance(.Chat).document(chatRoom.id).setData(from: chatRoom)

            
        } catch {
            
            print("No Able To Save Document" , error.localizedDescription)
            
        }
        
    }
    // MARK: - Delete Func
    
    func deleteChatRoom(_ chatRoom : ChatRoom){
        FirestoreReferance(.Chat).document(chatRoom.id).delete()
    }
    
    
    
    // MARK: - Dowenload all chat Rooms
    
    func dowenloadChatRooms (completion : @escaping(_ allFirebaseChatRooms: [ChatRoom])->Void){
        
        FirestoreReferance(.Chat).whereField(KSenderID , isEqualTo:  User.currentId).addSnapshotListener { snapShot, error in
            var chatRooms:[ChatRoom] = []
            
            guard let documents = snapShot?.documents else {
                print("no documents found")
                return
            }
            
            let allFirebaseChatRooms = documents.compactMap { snapShot -> ChatRoom? in
                return try? snapShot.data(as: ChatRoom.self)
            }
            
            for chatRoom in allFirebaseChatRooms {
                if chatRoom.lastMessage != "" {
                    chatRooms.append(chatRoom)
                }
            }
            
            chatRooms.sort (by: { $0.date! > $1.date! })
            completion (chatRooms)
        }
        
    }
    
    
}

