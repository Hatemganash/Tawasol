
import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageOutlet: UIImageView!
    @IBOutlet weak var userNameLBLOutlet: UILabel!
    @IBOutlet weak var lastMessageLblOutlet: UILabel!
    @IBOutlet weak var dateLblOutlet: UILabel!
    @IBOutlet weak var unreadCounterLblOutlet: UILabel!
    @IBOutlet weak var unreadCounterViewOutlet: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        unreadCounterViewOutlet.layer.cornerRadius = unreadCounterViewOutlet.frame.width/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure (chatRoom : ChatRoom){
        userNameLBLOutlet.text = chatRoom.receiverName
        userNameLBLOutlet.minimumScaleFactor = 0.9
        lastMessageLblOutlet.text = chatRoom.lastMessage
        lastMessageLblOutlet.numberOfLines = 2
        lastMessageLblOutlet.minimumScaleFactor = 0.9
        
        if chatRoom.unreadCounter != 0 {
            self.unreadCounterLblOutlet.text = "\(chatRoom.unreadCounter)"
            self.unreadCounterViewOutlet.isHidden = false

        } else {
            self.unreadCounterViewOutlet.isHidden = true
        }
        if chatRoom.avatarLink != "" {
            FileStorage.dowenloadImg(imgUrl: chatRoom.avatarLink) { avatarimage in
                self.avatarImageOutlet.image = avatarimage?.circleMasked
            }
        } else {
                self.avatarImageOutlet.image = UIImage(named: "Avatar")
            }
        
        dateLblOutlet.text = timeElapsed(chatRoom.date ?? Date())
        }
        
    }


