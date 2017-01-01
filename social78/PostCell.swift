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
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
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
    }
    
}
