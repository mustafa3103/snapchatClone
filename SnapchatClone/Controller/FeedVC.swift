//
//  FeedVC.swift
//  SnapchatClone
//
//  Created by Mustafa on 17.07.2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import SDWebImage
class FeedVC: UIViewController {

    
    @IBOutlet var tableView: UITableView!
    let firebaseDatastore = Firestore.firestore()
    var snapArray = [Snap]()
    var choosenSnap: Snap?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        getSnapsFromFirebase()
        getUserInfo()
    }
    
    //MARK: - Segue Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.toSnapVC {
            let destinationVC = segue.destination as! SnapVC
            destinationVC.selectedSnap = choosenSnap
        }
    }
    
    //MARK: - Alert
    func makeAlert(title: String, message: String) {
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Okay", style: .default)
        ac.addAction(okButton)
        present(ac, animated: true)
    }
}

//MARK: - TableView delegate methods.
extension FeedVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        choosenSnap = snapArray[indexPath.row]
        performSegue(withIdentifier: K.toSnapVC, sender: nil)
    }
}

//MARK: - TableView datasource methods.
extension FeedVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Cell, for: indexPath) as! FeedCell
        
        cell.feedUsernameLabel.text = snapArray[indexPath.row].username
        let imageUrl = URL(string: snapArray[indexPath.row].imageUrlArray[0])
        cell.feedImageView.sd_setImage(with: imageUrl)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snapArray.count
    }
}

//MARK: - Firebase Functions
extension FeedVC {
    func getUserInfo() {
        
        guard let userEmail = Auth.auth().currentUser!.email else { return }
        
        firebaseDatastore.collection(K.Firestore.userInfo).whereField(K.Firestore.email, isEqualTo: userEmail).getDocuments { snapshot, error in
            if let e = error {
                self.makeAlert(title: K.errorWasOccured, message: "Error is: \(e.localizedDescription)")
            }else {
                if snapshot?.isEmpty == false && snapshot != nil {
                    for document in snapshot!.documents {
                        if let username = document.get(K.Firestore.username) as? String {
                            UserSingleton.sharedUserInfo.email = userEmail
                            UserSingleton.sharedUserInfo.username = username
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - Taking Data from firebase
    func getSnapsFromFirebase() {
        firebaseDatastore.collection(K.Firestore.Snaps).order(by: K.Firestore.date, descending: true).addSnapshotListener { snapshot, error in
            if let e = error {
                self.makeAlert(title: K.errorWasOccured, message: "Error is: \(e.localizedDescription)")
            }else {
                if snapshot?.isEmpty == false && snapshot != nil {
                    self.snapArray.removeAll()
                    for document in snapshot!.documents {
                        let documentId = document.documentID
                        
                        if let username = document.get(K.Firestore.snapOwner) as? String {
                            if let imageUrlArray = document.get(K.Firestore.imageUrlArray) as? [String] {
                                if let date = document.get(K.Firestore.date) as? Timestamp {
                                    
                                    if let difference = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour {
                                        if difference >= 24 {
                                            //Delete
                                            self.firebaseDatastore.collection(K.Firestore.Snaps).document(documentId).delete { error in
                                                if let e = error {
                                                    self.makeAlert(title: K.errorWasOccured, message: "Error is: \(e.localizedDescription)")
                                                }
                                            }
                                        } else {
                                            let snap = Snap(username: username, imageUrlArray: imageUrlArray, date: date.dateValue(), timeDifference: 24 - difference)
                                            self.snapArray.append(snap)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
}
