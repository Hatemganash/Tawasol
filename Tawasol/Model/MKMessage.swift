
import Foundation
import MessageKit

class MKMessage : NSObject , MessageType  {
   
    var messageId: String
    var kind: MessageKit.MessageKind
    var sentDate: Date
    var mKSender : MKSender
    var sender: MessageKit.SenderType{ return mKSender }
    var senderInitials : String
    var status : String
    var readDate : Date
    var incoming : Bool

    
     init(message : LocalMessage) {
         self.messageId = message.id
         self.mKSender = MKSender(senderId: message.senderId, displayName: message.senderName)
         self.status = message.status
         self.kind = MessageKind.text(message.message)
         self.senderInitials = message.senderInitials
         self.sentDate = message.date
         self.readDate = message.readDate
         self.incoming = User.currentId != mKSender.senderId
         
    }
    
    
    
    
}
