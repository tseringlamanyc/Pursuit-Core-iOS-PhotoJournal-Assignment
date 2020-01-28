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
    func editButtonPressed(cell: ImageCell)
}

class ImageCell: UICollectionViewCell {
    
    weak var delegate: EditButtonDelegate?
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var picName: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    lazy var dateFormatter:  DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy h:mm a"
        formatter.timeZone = .current
        return formatter
      }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 20.0
    }
    
    public func configureCell(imageObject: ImageObject) {
        // convering data to UIImage
        guard let image = UIImage(data: imageObject.imageData) else {
            return
        }
        delegate?.editButtonPressed(cell: self)
        userImage.image = image
        picName.text = imageObject.description
        dateLabel.text = dateFormatter.string(from: imageObject.date)
    }
}

