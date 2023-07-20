
import Foundation
import Firebase



func restartChat(chatRoomId : String , memberIds :[String]){
    // Dowenload users using member ids
    
    FUserListner.shared.dowenloadUsersFromFirestore(withIds: memberIds) { allUsers in
        if allUsers.count > 0 {
            createChatRooms(chatRoomId: chatRoomId, users: allUsers)
        }
    }
    
    
}


func startChat (sender : User , reciever : User) -> String {
    var chatRoomId = ""
    let value = sender.id.compare(reciever.id).rawValue
    
    chatRoomId = value < 0 ? (sender.id + reciever.id) : (reciever.id + sender.id)
    createChatRooms(chatRoomId : chatRoomId , users: [sender , reciever])
    
    
    return chatRoomId
}


func createChatRooms (chatRoomId : String , users : [User] ){
    // if user has already chatroom we will not create
    
    var usersToCreateChatFor:[String]
    usersToCreateChatFor = []
    
    for user in users {
        usersToCreateChatFor.append(user.id)
    }
    FirestoreReferance(.Chat).whereField(KChatRoomID , isEqualTo: chatRoomId).getDocuments { querySnapShot, error in
        guard let snapshot = querySnapShot else { return }
        
        if !snapshot.isEmpty {
            for chatData in snapshot.documents  {
                let currentChat = chatData.data() as Dictionary
                
                if let currentUserId = currentChat[KSenderID] {
                    if usersToCreateChatFor.contains(currentUserId as! String){
                        usersToCreateChatFor.remove(at: usersToCreateChatFor.firstIndex(of: currentUserId as! String)!)
                    }
                }
            }
        }

        for userId in usersToCreateChatFor {
            
            let senderUser = userId == User.currentId ? User.currentUser! : getRecieverFrom(users: users)
            
            let receiverUser = userId == User.currentId ? getRecieverFrom(users: users) : User.currentUser!
            
            let chatRoomObject = ChatRoom(id: UUID().uuidString, chatRoomId: chatRoomId, senderId: senderUser.id, senderName: senderUser.username, receiverId: receiverUser.id, receiverName: receiverUser.username, date: Date(), memberIds: [senderUser.id , receiverUser.id], lastMessage: "", unreadCounter: 0, avatarLink: receiverUser.avatarLink)
            
            // TODO: - Save Chat To Firebase
            
            FChatRoomListner.shared.saveChatRoom(chatRoomObject)

            
            
            
        }
        
        
    }
}


func getRecieverFrom (users :[User]) -> User {
    var allUsers = users
    
    allUsers.remove(at: allUsers.firstIndex(of:User.currentUser!)!)
    
    return allUsers.first!
}
