//
//  ViewController.swift
//  SnapchatClone
//
//  Created by Mustafa on 16.07.2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignInVC: UIViewController {
    
    @IBOutlet var emailText: UITextField!
    @IBOutlet var usernameText: UITextField!
    @IBOutlet var passwordText: UITextField!
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        emailText.text?.removeAll()
        usernameText.text?.removeAll()
        passwordText.text?.removeAll()
    }
    
    //MARK: - Buttons
    @IBAction func signInButtonClicked(_ sender: UIButton) {
        if emailText.text != "" && passwordText.text != "" {
            
            Auth.auth().signIn(withEmail: self.emailText.text!, password: passwordText.text!) { result, error in
                if let e = error {
                    self.makeAlert(title: K.errorWasOccured, message: "Error is: \(e.localizedDescription)")
                }else {
                    //Sign in App
                    self.performSegue(withIdentifier: K.toFeedVC, sender: nil)
                }
            }
        }else {
            makeAlert(title: "Empty Area", message: "Fill the whole area to correctly.")
        }
    }
    
    @IBAction func signUpButtonClicked(_ sender: UIButton) {
        if emailText.text != "" && usernameText.text != "" && passwordText.text != "" {
            
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { auth, error in
                if error != nil {
                    self.makeAlert(title: K.errorWasOccured, message: "Error is: \(error!.localizedDescription)")
                }else {
                    
                    let fireStore = Firestore.firestore()
                    let userDictionary = [K.Firestore.email: self.emailText!.text, K.Firestore.username: self.usernameText!.text] as! [String: Any]
                    
                    fireStore.collection(K.Firestore.userInfo).addDocument(data: userDictionary) { error in
                        if let e = error {
                            self.makeAlert(title: K.errorWasOccured, message: "Error is: \(e.localizedDescription)")
                        }else {
                            
                        }
                    }
                    self.performSegue(withIdentifier: K.toFeedVC, sender: nil)
                }
            }
        }else {
            makeAlert(title: "Empty Area", message: "Fill the whole area to correctly.")
        }
    }
}

//MARK: - Alert Function
extension SignInVC {
    func makeAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Okay", style: .default))
        
        present(ac, animated: true)
    }
}
