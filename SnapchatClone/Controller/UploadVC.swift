//
//  UploadVC.swift
//  SnapchatClone
//
//  Created by Mustafa on 17.07.2022.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
class UploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var uploadImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //In this line we made our image to touchable.
        uploadImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(choosePicture))
        uploadImageView.addGestureRecognizer(gestureRecognizer)
        
    }

    //MARK: - Buttons
    @IBAction func uploadButtonClicked(_ sender: UIButton) {
        
        //Storage
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child(K.Firestore.media)
         
        if let data = uploadImageView.image?.jpegData(compressionQuality: 0.5) {
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data, metadata: nil) { metadata, error in
                if let e = error {
                    //Show error
                    self.makeAlert(title: K.errorWasOccured, message: "Error is: \(e.localizedDescription)")
                }else {
                    imageReference.downloadURL { url, error in
                        if let e = error {
                            self.makeAlert(title: K.errorWasOccured, message: "Error is:\(e.localizedDescription)")
                        }else {
                            guard let imageUrl = url?.absoluteString else { return }
                            
                            //Firestore
                            
                            let fireStore = Firestore.firestore()
                            
                            fireStore.collection(K.Firestore.Snaps).whereField(K.Firestore.snapOwner, isEqualTo: UserSingleton.sharedUserInfo.username).getDocuments { snapshot, error in
                                if let e = error {
                                    self.makeAlert(title: K.errorWasOccured, message: "Error is: \(e.localizedDescription)")
                                }else {
                                        if snapshot?.isEmpty == false && snapshot != nil {
                                            for document in snapshot!.documents {
                                                let documentId = document.documentID
                                                
                                                if var imageUrlArray = document.get(K.Firestore.imageUrlArray) as? [String] {
                                                    imageUrlArray.append(imageUrl)
                                                    
                                                    let additionalArray = [K.Firestore.imageUrlArray: imageUrlArray] as [String: Any]
                                                    
                                                    fireStore.collection(K.Firestore.Snaps).document(documentId).setData(additionalArray, merge: true) { error in
                                                        if let e = error {
                                                            self.makeAlert(title: K.errorWasOccured, message: "Error is: \(e.localizedDescription)")
                                                        }else {
                                                            self.tabBarController?.selectedIndex = 0
                                                            self.uploadImageView.image = UIImage(systemName: "paintbrush.pointed.fill")
                                                        }
                                                    }
                                                }
                                            }
                                        }else {
                                        //There is no snap
                                            let snapDictionary = [K.Firestore.imageUrlArray: [imageUrl], K.Firestore.snapOwner: UserSingleton.sharedUserInfo.username, K.Firestore.date: FieldValue.serverTimestamp()] as [String: Any]
                                        
                                            fireStore.collection(K.Firestore.Snaps).addDocument(data: snapDictionary) { error in
                                            if let e = error {
                                                self.makeAlert(title: K.errorWasOccured, message: "Error is: \(e.localizedDescription)")
                                            }else {
                                                self.tabBarController?.selectedIndex = 0
                                                self.uploadImageView.image = UIImage(systemName: "paintbrush.pointed.fill")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - Image Picker Functions
    @objc func choosePicture() {
        //Selecting picture.
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        
        uploadImageView.image = selectedImage
        self.dismiss(animated: true)
    }
}
//MARK: - Alert Function
extension UploadVC {
    func makeAlert(title: String, message: String) {
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Okay", style: .default)
        ac.addAction(okButton)
        present(ac, animated: true)
    }
}
