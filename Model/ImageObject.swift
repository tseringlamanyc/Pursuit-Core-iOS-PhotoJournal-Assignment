//
//  ImageObject.swift
//  Pursuit-Core-iOS-PhotoJournal-Assignment
//
//  Created by Tsering Lama on 1/23/20.
//  Copyright © 2020 Tsering Lama. All rights reserved.
//

import Foundation

struct ImageObject: Codable & Equatable {
    let imageData: Data
    let date: Date
    let identifier = UUID().uuidString
}
