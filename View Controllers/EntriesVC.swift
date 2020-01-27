//
//  ViewController.swift
//  Pursuit-Core-iOS-PhotoJournal-Assignment
//
//  Created by Tsering Lama on 1/23/20.
//  Copyright © 2020 Tsering Lama. All rights reserved.
//

import UIKit
import AVFoundation

class EntriesVC: UIViewController {
    
    @IBOutlet weak var entriesCV: UICollectionView!
    
    private var imageObjects = [ImageObject]()
    
    public let dataPersistence = DataPersistence<ImageObject>(filename: "images.plist")
    
    private var selectImage: UIImage? {
        didSet {
            appendNewPhoto()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        entriesCV.dataSource = self
        entriesCV.delegate = self
    }
    
    private func loadImages() {
        do {
            imageObjects = try dataPersistence.loadItems()
        } catch {
            print("Couldnt load images: \(error)")
        }
    }
    
    private func appendNewPhoto() {
        // converting UIImage to data
        guard let image = selectImage else {
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
        let imageObject = ImageObject(imageData: resizeImageData, date: Date())
        
        // insert image
        imageObjects.insert(imageObject, at: 0)  // this inserts at top
        
        // create an indexpath that adds to the collection view
        let indexpath = IndexPath(row: 0, section: 0)
        
        // insert one at a time
        entriesCV.insertItems(at: [indexpath])  // adds on at a time
        
        // persist imageObjects to document directory
        do {
            try dataPersistence.createItem(item: imageObject)
        } catch {
            print("Couldnt create \(error)")
        }
    }
    
    
    @IBAction func addPhoto(_ sender: UIBarButtonItem) {
        showAddingVC()
    }
    
    
    private func showAddingVC() {
        guard let addVC = storyboard?.instantiateViewController(identifier: "AddingVC") as? AddingVC else {
            fatalError()
        }
        present(addVC, animated: true)
    }
    
    
}

extension EntriesVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? ImageCell else {
            fatalError("Coudlnt down cast to ImageCell")
        }
        let imageObject = imageObjects[indexPath.row]
        cell.configureCell(imageObject: imageObject)
        return cell
    }
}

extension EntriesVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxWidth: CGFloat = UIScreen.main.bounds.size.width // width of the device
        let itemWidth: CGFloat = maxWidth * 0.80
        return CGSize(width: itemWidth, height: itemWidth)  }
}

extension UIImage {
    func resizeImage(to width: CGFloat, height: CGFloat) -> UIImage {
        let size = CGSize(width: width, height: height)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}


