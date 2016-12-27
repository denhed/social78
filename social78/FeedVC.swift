//
//  FeedVC.swift
//  social78
//
//  Created by Dennis Hedlund on 2016-12-27.
//  Copyright © 2016 Dennis Hedlund. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func signOutBtn(_ sender: Any) {
        
        // Remove uid from keychain
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("Dennis: Removed uid from keychain")
        
        
        // Firebase signout
        try! FIRAuth.auth()?.signOut()
        print("dennis: Logged out from Firebase")
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    

}
