//
//  SettingsVC.swift
//  SnapchatClone
//
//  Created by Mustafa on 17.07.2022.
//

import UIKit
import FirebaseAuth
class SettingsVC: UIViewController {

    let auth = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - Buttons
    @IBAction func logOutButtonClicked(_ sender: UIButton) {
        //For logout.
        
        do {
            try auth.signOut()
            navigationController?.popToViewController(self, animated: true)
            self.dismiss(animated: true, completion: nil)
            
        } catch {
            self.makeAlert(title: K.errorWasOccured, message: "While sign out application.")
        }
    }
}
//MARK: - Alert Function
extension SettingsVC {
    func makeAlert(title: String, message: String) {
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Okay", style: .default)
        ac.addAction(okButton)
        present(ac, animated: true)
    }

}
