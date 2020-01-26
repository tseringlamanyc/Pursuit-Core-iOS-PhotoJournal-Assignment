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
}

extension EntriesVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    
}

extension EntriesVC: UICollectionViewDelegateFlowLayout {
    
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


