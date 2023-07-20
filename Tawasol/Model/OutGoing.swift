
import Foundation
import UIKit
import FirebaseFirestoreSwift
import Gallery

class OutGoing {
    
    class func sendMessage(chatId : String , text : String? , photo : UIImage? , Video : Video? , audio : String? , audioDuration : Float = 0.0 ,location:String? , memberIds : [String]) {
        
       // Create local message from the data we have
        let currentUser = User.currentUser
        
        let message = LocalMessage ()
        message.id = UUID().uuidString
        message.chatRoomId = chatId
        message.senderId = currentUser!.id
        message.senderName = currentUser!.username
        message.senderInitials = String (currentUser!.username.first!)
        message.date = Date()
        message.status = KSent
        
        
        // check message type
        if text != nil {
            sendText(message : message , text : text! , memberIds : memberIds)
        }
        
        if photo != nil {
            // TODO: - Func  to Send Photo

        }
        if Video != nil {
            // TODO: - Func  to Send Video

        }
        if location != nil {
            // TODO: - Func  to Send location

        }
        if audio != nil {
            // TODO: - Func  to Send audio

        }
        
        
        // save message locally
        // save message to firestore
        
        // TODO: - Send Notification
        
        // TODO: - Update ChatRoom


    }
    
    class func saveMessage (message : LocalMessage , memberIds : [String]) {
        
        RealmManager.shared.save(message)
        
        for memberId in memberIds {
            FMSGListner.shared.addMessage(message, memberId: memberId)
        }
    }
    
}

func sendText (message : LocalMessage , text : String , memberIds : [String]) {
    message.message = text
    message.type = KTEXT
    
    OutGoing.saveMessage(message: message, memberIds: memberIds)
    
}
