//
//  AddingVC.swift
//  Pursuit-Core-iOS-PhotoJournal-Assignment
//
//  Created by Tsering Lama on 1/25/20.
//  Copyright © 2020 Tsering Lama. All rights reserved.
//

import UIKit

protocol AddingDelegate: AnyObject {
    func passInfo(vc: AddingVC)
}

class AddingVC: UIViewController {
    
    @IBOutlet weak var picDescription: UITextField!
    @IBOutlet weak var userPic: UIImageView!
    
    private var imagePicker = UIImagePickerController()
    
    weak var delegate: AddingDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    
    
    @IBAction func photoLibrary(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    
    @IBAction func cameraButton(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true)
    }
    
}

extension AddingVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        userPic.image = image
        delegate?.passInfo(vc: self)
        dismiss(animated: true)
    }
}
