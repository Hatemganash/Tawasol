

import UIKit

class profileTableViewController: UITableViewController {
    
    
    var user :User?
    // MARK: - Outlets
    
    @IBOutlet weak var avatarImgReview: UIImageView!
    @IBOutlet weak var usernameLabelOutlet: UILabel!
    @IBOutlet weak var statusLabelOutlet: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        tableView.tableFooterView = UIView()
        
        setupUI()
        
    }
    
    
    private func setupUI() {
        if user != nil {
            self.title = user!.username
            usernameLabelOutlet.text = user?.username
            statusLabelOutlet.text = user?.status
            
            if user?.avatarLink != "" {
                FileStorage.dowenloadImg(imgUrl: user!.avatarLink) { [self] avatarImage in
                    avatarImgReview.image = avatarImage?.circleMasked
                }
                
            }
            
        }
    }
       
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 5.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "colorTableview")
        
        return headerView
    }
       
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            print("Start Chatting")
            
            let chatId = startChat(sender: User.currentUser!, reciever: user!)
            
            let privateMSGView = MSGViewController(chatId: chatId, recipientId: user!.id, recipientName: user!.username)
            
            navigationController?.pushViewController(privateMSGView, animated: true)
        }
    }
    
}
