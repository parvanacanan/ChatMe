//
//  ChatViewController.swift
//  ChatMe
//
//  Created by parvana on 24.10.25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

var bodyField = "body"
var senderField = "sender"
var dateField = "date"

class ChatViewController: UIViewController ,  UITableViewDelegate  {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    let db = Firestore.firestore()
    var collectionName = "messages"
     
   
    var messages : [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ChatMe"
        navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: "MessageCell", bundle: nil),
                               forCellReuseIdentifier: "ReusableCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        loadMessages()
    }
    func loadMessages() {
    
        db.collection(collectionName).order(by: dateField).addSnapshotListener  { QuerySnapshot, error in
            self.messages = []
            if let e = error {
                print("there was ... \(e)")
            } else {
                if let snapshotDOc =   QuerySnapshot?.documents {
                    for doc in snapshotDOc {
                        let data = doc.data()
                        if let messagesender = data[senderField] as? String , let messageBody = data[bodyField]  as? String{
                            let newMessage = Message(sender: messagesender, body: messageBody)
                            self.messages.append(newMessage) }
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                
                                let indexPath = IndexPath(row: self.messages.count - 1  , section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top , animated: true)
                            }
                            
                        
                    }
                }
            }
        }
    }
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextField.text , let messageSender = Auth.auth().currentUser?.email  {
            db.collection(collectionName).addDocument(data: [senderField : messageSender , bodyField : messageBody , dateField : Date().timeIntervalSince1970]) { error in
                if let e = error {
                    print("There was a issue saving data to firestore , \(e) ")
                } else {
                    print("succesfully saved data")
                    self.messageTextField.text = ""

                }
            }
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true )
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    
}
extension ChatViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier:  "ReusableCell" , for : indexPath) as! MessageCell
        cell.label.text =  message.body
        if message.sender == Auth.auth().currentUser!.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(cgColor: CGColor(red: 0, green: 100/255, blue: 0, alpha: 1))
            cell.label.textColor = UIColor(cgColor: CGColor(red: 0.7, green: 1, blue: 0.7, alpha: 1))
        } else {
            cell.rightImageView.isHidden = true
            cell.leftImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(cgColor: CGColor(red: 0.7, green: 1, blue: 0.7, alpha: 1))
            cell.label.textColor = UIColor(cgColor: CGColor(red: 0, green: 100/255, blue: 0, alpha: 1))
        }
       
        return cell
    }
    
}
