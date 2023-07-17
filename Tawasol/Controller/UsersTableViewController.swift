

import UIKit

class UsersTableViewController: UITableViewController {

   var allUsers : [User] = []
    var filteredUsers : [User] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView =  UIView()

        //allUsers = [User.currentUser!]
        // createDummyUsers()
        
        downloadUsers()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Users"
        definesPresentationContext = true
       searchController.searchResultsUpdater = self
        
        self.refreshControl = UIRefreshControl()
        self.tableView.refreshControl = self.refreshControl
       
    }
    
    // MARK: - Scroll Delegate Func
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //refresh users
        
        if self.refreshControl!.isRefreshing {
            self.downloadUsers()
            self.refreshControl!.endRefreshing()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? filteredUsers.count : allUsers.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UsersTableViewCell
        let user = searchController.isActive ? filteredUsers[indexPath.row] : allUsers [indexPath.row]
        
        cell.configureCell(user: user)
            return cell
        }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = searchController.isActive ? filteredUsers[indexPath.row] : allUsers[indexPath.row]
        
        showUserProfile(user)
    }
    
    // MARK: - Dowenload All Users From FireStore
    
    private func downloadUsers(){
        
        FUserListner.shared.dowenloadAllUsersFromFirestore { firestoreAllUsers in
            
            self.allUsers = firestoreAllUsers
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }

    
}


// MARK: - Extentions

extension UsersTableViewController : UISearchResultsUpdating {
   
    func updateSearchResults(for searchController: UISearchController) {
        
        filteredUsers = allUsers.filter({ user in
            return user.username.lowercased().contains(searchController.searchBar.text!.lowercased())
            
            
        })
        
        tableView.reloadData()
        
    }
    
    private func showUserProfile(_ user : User) {
        let profileView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileView") as! profileTableViewController
        
        profileView.user = user
        
        navigationController?.pushViewController(profileView, animated: true)
    }
    
}
