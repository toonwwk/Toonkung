//
//  PostViewController.swift
//  Toonkung
//
//  Created by Kanokporn Wongwaitayakul on 30/1/2563 BE.
//  Copyright © 2563 Kanokporn Wongwaitayakul. All rights reserved.
//

import UIKit
import Firebase
class PostViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var postBody: UITextView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var postButton: UIBarButtonItem!
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        postBody.text = "Type Here :-)"
        postBody.textColor = .lightGray
        postBody.textAlignment = .center
        postBody.delegate = self
        addImageButton.layer.cornerRadius = addImageButton.frame.size.width / 25

    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(false)
        postBody.text = "Type Here :-)"
        postBody.textColor = .lightGray
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = UIColor.init(named: "FontColor")
        }
        return true
    }
}

// MARK: - for acess photo and camera

extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBAction func addImagePressed(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        let actionSheet = UIAlertController(title: "Photo Source", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet,animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        postImage.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - update to Firebase
extension PostViewController {
    @IBAction func postButtonPressed(_ sender: UIBarButtonItem) {
        let body = postBody.text
        let image = postImage.image?.jpegData(compressionQuality: 1.0)
        if body == "Type Here :-)"{
            postBody.text = nil
        }
        if body != nil || image != nil{
            db.collection("Toonkung").addDocument(data: [
                    "body": body,
                    "image": image,
                    "date": Date().timeIntervalSince1970
                ]) { (error) in
                    if let e = error {
                        print("There was an issue saving data to firestore, \(e)")
                    } else {
                        print("Successfully saved data.")
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
        }
}
