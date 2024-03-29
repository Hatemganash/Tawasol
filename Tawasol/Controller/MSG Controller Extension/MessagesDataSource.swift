

import Foundation
import MessageKit

extension MSGViewController : MessagesDataSource {
    
    func currentSender() -> MessageKit.SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return mkMessages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return mkMessages.count
    }
    
    // MARK: - Cell top labels
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        
        if indexPath.section % 3 == 0 {
            
            let showLoadMore = false
            let text = showLoadMore ? "Pull To Load More" : MessageKitDateFormatter.shared.string(from: message.sentDate)

            let font = showLoadMore ? UIFont.systemFont(ofSize: 13) : UIFont.boldSystemFont(ofSize: 10)
            let color = showLoadMore ? UIColor.systemBlue : UIColor.darkGray
            
            return NSAttributedString(string: text , attributes: [.font : font , .foregroundColor : color])
        }
        return nil
    }
    // MARK: - Cell bottom labels
    
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        if isFromCurrentSender(message: message) {
            let message = mkMessages[indexPath.section]
            let status = indexPath.section == mkMessages.count - 1 ? message.status + " " + message.readDate.time() : ""
            
            let font = UIFont.boldSystemFont(ofSize: 10)
            let color = UIColor.darkGray
            
            return NSAttributedString(string: status , attributes: [.font : font , .foregroundColor : color])
        }
        return nil

    }
    // MARK: - message bottom labels
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section != mkMessages.count - 1 {
            
            let font = UIFont.boldSystemFont(ofSize: 10)
            let color = UIColor.darkGray
            return NSAttributedString(string: message.sentDate.time(), attributes: [.font : font , .foregroundColor : color] )
        }
        return nil

    }
    
}
