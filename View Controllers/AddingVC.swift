//
//  AddingVC.swift
//  Pursuit-Core-iOS-PhotoJournal-Assignment
//
//  Created by Tsering Lama on 1/25/20.
//  Copyright © 2020 Tsering Lama. All rights reserved.
//

import UIKit
import AVFoundation

protocol AddingPicDelegate: AnyObject {
    func addedPic(imageObject: ImageObject)
}

class AddingVC: UIViewController {
    
    @IBOutlet weak var picDescription: UITextField!
    @IBOutlet weak var userPic: UIImageView!
    
    private var imagePicker = UIImagePickerController()
    
    public var theObject: ImageObject!
    
    weak var delegate: AddingPicDelegate?
    
    public let dataPersistence = DataPersistence<ImageObject>(filename: "images.plist")
    
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
    
    @IBAction func savePhoto(_ sender: UIButton) {
        // converting UIImage to data
        let theImage = userPic.image
        
        guard let image = theImage else {
            return
        }
        
        // size image
        let size = UIScreen.main.bounds.size
        
        // we will maintain aspect ratio
        let rect = AVMakeRect(aspectRatio: image.size, insideRect: CGRect(origin: CGPoint.zero, size: size))
        
        // resize image
        let resizeImage = image.resizeImage(to: rect.size.width, height: rect.size.height)
        
        // converts UIImage to data
        guard let resizeImageData = resizeImage.jpegData(compressionQuality: 1.0) else {
            return
        }
        
        // imageObject array
        let imageObject = ImageObject(imageData: resizeImageData, date: Date(), description: picDescription.text!)
        theObject = imageObject
        delegate?.addedPic(imageObject: imageObject)
        do {
            try dataPersistence.createItem(item: imageObject)
        } catch {
            print("couldnt save object \(error)")
        }
        dismiss(animated: true)
    }
    
    
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

extension AddingVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        userPic.image = image
        dismiss(animated: true)
    }
}

