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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
    
    
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
