
import UIKit
import MessageKit
import InputBarAccessoryView
import Gallery
import RealmSwift

class MSGViewController: MessagesViewController {
    
    // MARK: - Vars
    
    private var chatId = ""
    private var recipientId = ""
    private var recipientName = ""
    let refreshController = UIRefreshControl()
    let micButton = InputBarButtonItem()
    let currentUser = MKSender(senderId: User.currentId, displayName: User.currentUser!.username)
    
    let mkMessage : [MKMessage] = []
    
    
    // MARK: - init
    
    init(chatId : String , recipientId : String , recipientName : String){
        super.init(nibName: nil, bundle: nil)
        
        self.chatId = chatId
        self.recipientId = recipientId
        self.recipientName = recipientName
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMSGCollectionView()
        configureMSGInputBar()
        
        
        
    }
    private func configureMSGCollectionView(){
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        
        scrollsToBottomOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        messagesCollectionView.refreshControl = refreshController
    }
    
    private func configureMSGInputBar (){
        messageInputBar.delegate = self
        let attachButton = InputBarButtonItem()
        attachButton.image = UIImage(systemName: "paperclip" , withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        attachButton.setSize(CGSize(width: 30, height: 30), animated: false)
        attachButton.onTouchUpInside { item in
            print("Attaching")
            // TODO: - Attach Action
            
            
        }
        micButton.image = UIImage(systemName: "mic.fill" , withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        micButton.setSize(CGSize(width: 30, height: 30), animated: false)
        
        messageInputBar.setStackViewItems([attachButton], forStack: .left, animated: false)
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        
        // TODO: - Update Mic status
        updateMicButtonStatus(show : false)
        
        
        messageInputBar.inputTextView.isImagePasteEnabled = false
        messageInputBar.backgroundView.backgroundColor = .systemBackground
        messageInputBar.inputTextView.backgroundColor = .systemBackground
        
        
        
        
    }
    
    func updateMicButtonStatus(show : Bool){
        
        if show {
            messageInputBar.setStackViewItems([micButton], forStack: .right, animated: false)
            messageInputBar.setRightStackViewWidthConstant(to: 30, animated: false)
        } else {
            messageInputBar.setStackViewItems([messageInputBar.sendButton], forStack: .right, animated: false)
            messageInputBar.setRightStackViewWidthConstant(to: 55, animated: false)
        }
    }
    
    
    
    
    
    // MARK: - Actions
    
    func send (text : String? , photo : UIImage? , video : Video?,location : String? ,audio:String? , audioDuration : Float = 0.0 ){
        OutGoing.sendMessage(chatId: chatId, text: text, photo: photo, Video: video , audio: audio, location: location, memberIds: [User.currentId,recipientId])
        
       // print(Realm.Configuration.defaultConfiguration.fileURL!)

    }
}


