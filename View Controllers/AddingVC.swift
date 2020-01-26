//
//  AddingVC.swift
//  Pursuit-Core-iOS-PhotoJournal-Assignment
//
//  Created by Tsering Lama on 1/25/20.
//  Copyright © 2020 Tsering Lama. All rights reserved.
//

import UIKit

class AddingVC: UIViewController {
    
    @IBOutlet weak var picDescription: UITextField!
    @IBOutlet weak var userPic: UIImageView!
    
    private var imagePicker = UIImagePickerController()

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
    
}
