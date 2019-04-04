//
//  Photo.swift
//  Sminq_Code
//
//  Created by Manish Prasad on 03/04/19.
//  Copyright © 2019 Manish. All rights reserved.
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
