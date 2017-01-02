//
//  PostCell.swift
//  social78
//
//  Created by Dennis Hedlund on 2016-12-28.
//  Copyright © 2016 Dennis Hedlund. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    
    var post: Post!
    var likesRef: FIRDatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // TapGesture på vår like img, vi lägger till den här då den vi får många celler i listan
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImg.addGestureRecognizer(tap)
        likeImg.isUserInteractionEnabled = true
    }
    
    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
        likesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        
        if img != nil {
            // om den finns i chache
            self.postImg.image = img
        } else {
            // om vi inte har en bild i cahe så laddar vi ner den.
            let ref = FIRStorage.storage().reference(forURL: post.imageUrl)
            // sätter en gräns på 2 mb.
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("Dennis: Unable to download image from Firebase storage")
                } else {
                    print("Dennis: Image downloaded from Firebase storage ")
                    
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.postImg.image = img
                            
                            // spara till chache
                            FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                        }
                        
                    }
                }
            })
        }
        
    
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            // firebase retunerar inte nil utan NSNull om det inte finns något.
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "empty-heart")
            } else {
                self.likeImg.image = UIImage(named: "filled-heart")
            }
        })
        
        
    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
     
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            // firebase retunerar inte nil utan NSNull om det inte finns något.
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(addLike: true)
                // lägger till under user vika likes den har
                self.likesRef.setValue(true)
            } else {
                self.likeImg.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addLike: false)
                // tar bort likes under user
                self.likesRef.removeValue()
            }
        })

    }
    
}
