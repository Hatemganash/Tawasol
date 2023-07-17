
import UIKit

class UsersTableViewCell: UITableViewCell {

    
    // MARK: - IB Outlet
    
    @IBOutlet weak var avatarImageViewOutlet: UIImageView!
    
    @IBOutlet weak var usernameLabelOutlet: UILabel!
    
    @IBOutlet weak var statusLabelOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell (user : User){
        
        usernameLabelOutlet.text = user.username
        statusLabelOutlet.text = user.status
        if user.avatarLink != "" {
            FileStorage.dowenloadImg(imgUrl: user.avatarLink) { avatarImage in
                self.avatarImageViewOutlet.image = avatarImage?.circleMasked
            }
        }else {
            self.avatarImageViewOutlet.image = UIImage(named: "avatar")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    

}
