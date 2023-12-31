import UIKit
import Firebase

enum Chat: Int, CaseIterable {
    case empty
    case chat
    
    var cellTypes: UITableViewCell.Type {
        switch self {
        case .empty:
            return EmptyTableViewCell.self
        case .chat:
            return ChatTableViewCell.self
        }
    }
}

class ChatViewController: UIViewController {
    
    @IBOutlet weak var chatTableView: UITableView!
    
    private var messageData: [MessageModel] = []
    private let userId = UserDefaultManager.getUserID()
    private var refreshTimer: Timer?
    
    let messageRef = Database.database().reference().child("messages")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        chatTableView.delegate = self
        chatTableView.dataSource = self
        
        Chat.allCases.forEach { cell in
            chatTableView.registerCellWithNib(cell.cellTypes)
        }
        
        fetchMessage()
    }
    
    func fetchMessage() {
        messageRef.observe(.childAdded, with: { [weak self] snapshot in
            guard let strongSelf = self,
                  let messageData = snapshot.value as? [String: Any],
                  let data = messageData["data"] as? [String: Any],
                  let userIdFromSnapshot = data["userId"] as? Int,
                  userIdFromSnapshot == strongSelf.userId else {
                return
            }

            let id = snapshot.key

            let productData = data["product"] as? [String: Any]
            let product = MessageModel.MessageData.MessageProduct(
                productId: productData?["productId"] as? Int,
                productName: productData?["productName"] as? String,
                price: productData?["price"] as? Int,
                image: productData?["image"] as? String
            )

            let message = MessageModel(
                id: id,
                data: MessageModel.MessageData(
                    createdAt: data["createdAt"] as? String ?? "",
                    isFromUser: data["isFromUser"] as? Bool ?? false,
                    message: data["message"] as? String ?? "",
                    userId: userIdFromSnapshot,
                    username: data["username"] as? String ?? "",
                    imageProfile: data["imageProfile"] as? String ?? "",
                    product: product
                )
            )

            if let existingMessage = strongSelf.messageData.first, message.data.createdAt > existingMessage.data.createdAt {
                strongSelf.messageData.insert(message, at: 0)
            } else {
                strongSelf.messageData.append(message)
            }

            DispatchQueue.main.async {
                strongSelf.chatTableView.reloadData()
            }
        })

    }

}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource, EmptyCellDelegate {
    
    func btnAction(inCell cell: EmptyTableViewCell) {
        if let tabBarController = self.tabBarController,
           let navigationController = tabBarController.selectedViewController as? UINavigationController {
            tabBarController.selectedIndex = 0
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageData.isEmpty ? 1 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if messageData.isEmpty {
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as EmptyTableViewCell
            
            cell.configure(withImageNamed: "ic_headset_nil", message: "You've never chatted before", title: "Opss no message yet?")
            cell.delegate = self
            tableView.isScrollEnabled = false
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ChatTableViewCell
  
            let latestMessage = messageData.first!
            cell.configure(with: latestMessage)
            chatTableView.contentInset.top = 15
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !messageData.isEmpty else {
            return
        }
        
        if let navigationController = self.navigationController {
            let ChatScreenViewController = ChatScreenViewController()
            ChatScreenViewController.hidesBottomBarWhenPushed = true
            ChatScreenViewController.navigationController?.isNavigationBarHidden = true 
            navigationController.pushViewController(ChatScreenViewController, animated: true)
        }
    }
}
