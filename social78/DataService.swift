//
//  DataService.swift
//  social78
//
//  Created by Dennis Hedlund on 2016-12-30.
//  Copyright © 2016 Dennis Hedlund. All rights reserved.
//

import Foundation
import Firebase

// https://devslopes-social-b72a5.firebaseio.com/
let DB_BASE = FIRDatabase.database().reference()
let STORAGE_BASE = FIRStorage.storage().reference()

class DataService {
    
    // skapa en singelton class
    static let ds = DataService()
    
    
    // DB references, common endpoints
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    // Storage referneces
    private var _REF_POST_IMAGES = STORAGE_BASE.child("post-pics")
    
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    var RES_POST_IMAGES: FIRStorageReference {
        return _REF_POST_IMAGES
    }
    
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>){
        // om uid inte finns idb så skapar firebase det automatiskt.
        // updateChildValues skriver enbart över den key det är skillnad i värde,
        // finns det ingen key så skapas den.
        REF_USERS.child(uid).updateChildValues(userData)
    }
}
