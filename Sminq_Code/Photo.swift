//
//  Photo.swift
//  Sminq_Code
//
//  Created by Shrikant Durge on 04/04/19.
//  Copyright © 2019 Shrikant. All rights reserved.
//

import UIKit

class Photo: NSObject {
    var imageUrl: String?
    var publicId: String?
    init?(imageUrl: String? = nil, publicId: String? = nil) {
        
        self.imageUrl = imageUrl
        self.publicId = publicId
        
    }
}
