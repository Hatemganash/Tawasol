
import UIKit

class StatusTableViewController: UITableViewController {
    let statuses = ["Available" , "Busy" , "Sleeping" , "Tawasol Only" , ]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return statuses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = statuses[indexPath.row]
        
        let userStatus = User.currentUser?.status
        cell.accessoryType = userStatus == statuses[indexPath.row] ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userStatus = tableView.cellForRow(at: indexPath)?.textLabel?.text
        
        var user = User.currentUser
        user?.status = userStatus!
        saveUserLocally(user!)
        FUserListner.shared.saveUserToFirestore(user!)
        tableView.reloadData()

    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "colorTableview")
        
        return headerView
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 0.5
    }
    
}
   
