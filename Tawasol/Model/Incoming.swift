

import Foundation
import MessageKit


class Incoming {
    
    var messageViewController : MessagesViewController
    
    init (messageViewController : MessagesViewController){
        self.messageViewController = messageViewController
    }
    
    func creatMKMessage (localMessage: LocalMessage) -> MKMessage {
        let mkMessage = MKMessage(message: localMessage)
        
        return mkMessage
    }
    
}
