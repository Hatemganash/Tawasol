
import UIKit

class SettingsTableViewController: UITableViewController {
    // IBOutlet
    
    @IBOutlet weak var avatarImgOutlet: UIImageView!
    
    @IBOutlet weak var usernameLBLOutlet: UILabel!
    
    @IBOutlet weak var statusLBLOutlet: UILabel!
    
    @IBOutlet weak var appVersionLBLOutlet: UILabel!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showUserInfo()
    }
    
    
    
    // IBActions
    
    @IBAction func tellFriendBTN(_ sender: Any) {
        print("Tell A Friend")
    }
    @IBAction func termsAndConditionsBTN(_ sender: Any) {
        print("Terms And Conditions")
        
    }
    
    @IBAction func logOutBTN(_ sender: Any) {
        FUserListner.shared.logoutCurrentUser { error in
            if error == nil {
                let loginView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginView")
                DispatchQueue.main.async {
                    loginView.modalPresentationStyle = .fullScreen
                    self.present(loginView, animated: true )
                    
                }
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "colorTableview")
        
        return headerView
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 0.5
    }
    
    // MARK: - Update UI
    
    private func showUserInfo(){
        if let user = User.currentUser {
            
            usernameLBLOutlet.text = user.username
            statusLBLOutlet.text = user.status
            appVersionLBLOutlet.text = "App Version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "" )"
            
            if user.avatarLink != "" {
                ///// Downillloaaddddd Phhhoooootoooo
            }
        }
    }
    
}
