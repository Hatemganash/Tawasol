
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
    
    var mkMessages : [MKMessage] = []
    var allLocalMessges : Results<LocalMessage>!
    let realm = try! Realm()
    var notificationToken : NotificationToken?
    
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
        
        loadMessages()
        listenForNewMessages()
        
    }
    private func configureMSGCollectionView(){
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        
        scrollsToLastItemOnKeyboardBeginsEditing = true
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
        updateMicButtonStatus(show : true)
        
        
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
    // MARK: - Load Messages
    
    private func loadMessages() {
        let predicate = NSPredicate(format: "chatRoomId = %@", chatId)
        
        allLocalMessges = realm.objects(LocalMessage.self).filter(predicate).sorted(byKeyPath: KDATE , ascending: true)
        if allLocalMessges.isEmpty {
            checkForOldMessages() }
        
        notificationToken = allLocalMessges.observe({(change : RealmCollectionChange) in
            switch change{
                
            case .initial:
                self.insertMKMessages()
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem(animated: true)
                
            case .update(_,_, let insertions, _) :
                for index in insertions {
                    self.insertMKMessage(localMessage:self.allLocalMessges[index])
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToLastItem(animated: true)

                }
            case .error(let error):
                print("error on new insertion",error.localizedDescription)
            }
        })
    }
    
    private func insertMKMessage(localMessage : LocalMessage){
        
        let incoming = Incoming(messageViewController: self)
        let mkMessage = incoming.creatMKMessage(localMessage: localMessage)
        self.mkMessages.append(mkMessage)
        
    }
    
    private func insertMKMessages(){
        for localMessage in allLocalMessges {
            insertMKMessage(localMessage: localMessage)
        }
    }
    
    private func checkForOldMessages() {
        FMSGListner.shared.checkForOldMessages(User.currentId, collectionId: chatId)
    }
    private func listenForNewMessages (){
        FMSGListner.shared.listenForNewMessages(User.currentId, collectionId: chatId, lastMessageDate: lastMessageDate())
    }
    
    // MARK: - Helpers
    
    private func lastMessageDate () -> Date{
        
        let lastMessageDate = allLocalMessges.last?.date ?? Date()
        return Calendar.current.date(byAdding: .second,value: 1 , to: lastMessageDate) ?? lastMessageDate
        
    }
    
}

