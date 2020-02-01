//
//  TimelineViewController.swift
//  Toonkung
//
//  Created by Kanokporn Wongwaitayakul on 29/1/2563 BE.
//  Copyright © 2563 Kanokporn Wongwaitayakul. All rights reserved.
//

import UIKit
import Firebase
class TimelineViewController: UIViewController{
    
    @IBOutlet weak var stickyButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    let db = Firestore.firestore()
    var posts: [Post] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        stickyButton.layer.cornerRadius = stickyButton.frame.size.width / 2
        stickyButton.clipsToBounds = true
        loadPosts()
    }
    
    @IBAction func stickyButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "TimelineToPost", sender: self)
    }
    @IBAction func handleGesture(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .ended{
            self.performSegue(withIdentifier: "TimelineToResume", sender: self)
        }
//        let alertController = UIAlertController(title: nil, message:
//            "Long-Press Gesture Detected", preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "OK", style: .default,handler: nil))
//        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - load data from Firebase
extension TimelineViewController{
    func loadPosts(){
        db.collection("Toonkung").order(by: "date").addSnapshotListener { (querySnapshot, error) in
            
            self.posts = []
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        let postBody = data["body"] as? String
                        var postImage: UIImage? = nil

                        if let postImageData = data["image"] as? Data{
                            postImage = UIImage(data: postImageData)
                        }
                        
                        let newPost = Post(body: postBody, image: postImage)
                        self.posts.insert(newPost,at: 0)
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            let indexPath = IndexPath(row: 0, section: 0)
                            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                        }
                        
                    }
                }
            }
        }
    }
}

// MARK: - create table view cell

extension TimelineViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! TableViewCell
        cell.postBody.text = post.body
        if post.image == nil{
            cell.postImage.isHidden = true
        }
        else{
            cell.postImage.image = post.image
            cell.postImage.isHidden = false

        }
        return cell
    }
}
