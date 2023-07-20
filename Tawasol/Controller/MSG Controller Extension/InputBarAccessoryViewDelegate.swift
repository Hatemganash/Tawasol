
import Foundation
import InputBarAccessoryView

extension MSGViewController : InputBarAccessoryViewDelegate  {
    
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        print("typing" , text)
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        send(text: text, photo: nil, video: nil, location: nil, audio: nil)
        messageInputBar.inputTextView.text = ""
        messageInputBar.invalidatePlugins()

    }
    
}
