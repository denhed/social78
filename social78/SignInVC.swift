//
//  SignInVC.swift
//  social78
//
//  Created by Dennis Hedlund on 2016-12-26.
//  Copyright © 2016 Dennis Hedlund. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {

    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var pwdField: FancyField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // vi kan inte ha segue i viewDidLoad -> viewDidAppear.
        // Kolla om vi har uid i keychain.
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookBtnTapped(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            if error != nil {
                print("Dennis: Unable to authenticate with Facebook - \(error)")
            } else if result?.isCancelled == true {
                print("Dennis: User cancelled Facebook authentication")
            } else {
                print("Dennis: Successfully authenticated with Facebook")
                
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                self.firebaseAuth(credential)
                
            }
        }
    } 
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Dennis: Unable to authenticate with Firebase - \(error)")
            } else {
                print("Dennis: Successfully auhtenticated with Firebase")
                
                // spara uid till keychain för auto signin.
                if let user = user {
                    // obs: vi använder credential.provider här
                    let userData = ["provider": credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                }
            }
        })
    }
    
    
    @IBAction func signInTapped(_ sender: Any) {
        
        //Firebase kräver minst 6 tecken för email authetication.
        
        if let email = emailField.text, let pwd = pwdField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("Dennis: Email user authentication with Firebase")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                } else {
                    //om det inte finns en användar med den email -> skapa nytt konto.
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("Dennis: Unable to authenticate with Firebase using email")
                        } else {
                            print("Dennis: Successfully authenticated with Firebase")
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                self.completeSignIn(id: user.uid, userData: userData)
                            }
                        }
                    })
                }
            })
        }
        
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        
        // skapa en användare i firebase databas.
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        
        
        // spara uid till keychain
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("Dennis: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
}

