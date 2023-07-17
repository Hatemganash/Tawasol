

import UIKit

class ChatRoomTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChatTableViewCell
        
        let chatRoom = ChatRoom(id: "123" , chatRoomId: "123" , senderId: "123" , senderName: "Hatem" , receiverId: "123" , receiverName: "Ali" , date: Date() , memberIds: [] , lastMessage: "Hello Iam Fine And You How Are Ypu Now Thank You For Calling Me" , unreadCounter: 2  , avatarLink: "")
        
        cell.configure (chatRoom : chatRoom)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
  
   


}
