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
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        // lyssnare för firebase, 
        //.value lyssnar efter samtliga förändringar under posts.
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            
            // gör om data till object
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                        
                    }
                }
            }
            // uppdatera view
            self.tableView.reloadData()
        })
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        print("Dennis: \(post.caption)")

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
