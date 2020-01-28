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
    
    private var imageObjects = [ImageObject]() {
        didSet {
            title = "Photos: \(imageObjects.count)"
            self.entriesCV.reloadData()
        }
    }
    
    public let dataPersistence = DataPersistence<ImageObject>(filename: "images.plist")
  
    override func viewDidLoad() {
        super.viewDidLoad()
        entriesCV.dataSource = self
        entriesCV.delegate = self
        loadImages()
    }
    
    private func loadImages() {
        do {
            imageObjects = try dataPersistence.loadItems()
        } catch {
            print("Couldnt load images: \(error)")
        }
    }
    
    @IBAction func addPhoto(_ sender: UIBarButtonItem) {
        showAddingVC()
    }
    
    
    private func showAddingVC() {
        guard let addVC = storyboard?.instantiateViewController(identifier: "AddingVC") as? AddingVC else {
            fatalError()
        }
        addVC.delegate = self
        present(addVC, animated: true)
    }
}

extension EntriesVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? ImageCell else {
            fatalError("Couldn't down cast to ImageCell")
        }
        let imageObject = imageObjects[indexPath.row]
        cell.configureCell(imageObject: imageObject)
        return cell
    }
}

extension EntriesVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxWidth: CGFloat = UIScreen.main.bounds.size.width // width of the device
        let itemWidth: CGFloat = maxWidth * 0.90
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

extension EntriesVC: AddingPicDelegate {
    func addedPic(imageObject: ImageObject) {
        self.imageObjects.append(imageObject)
    }
}


