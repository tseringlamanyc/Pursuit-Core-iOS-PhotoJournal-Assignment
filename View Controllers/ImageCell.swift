//
//  ImageCell.swift
//  Pursuit-Core-iOS-PhotoJournal-Assignment
//
//  Created by Tsering Lama on 1/23/20.
//  Copyright © 2020 Tsering Lama. All rights reserved.
//

import UIKit

// TODO: make delegate here for edit button
protocol EditButtonDelegate: AnyObject {
    func editButtonPressed(imageObject: ImageObject)
}

class ImageCell: UICollectionViewCell {
    
    weak var delegate: EditButtonDelegate?
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var picName: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    public func configureCell(imageObject: ImageObject) {
        // convering data to UIImage
        guard let image = UIImage(data: imageObject.imageData) else {
            return
        }
        delegate?.editButtonPressed(imageObject: imageObject)
        userImage.image = image
        picName.text = imageObject.description
        dateLabel.text = imageObject.date.description
    }
}

