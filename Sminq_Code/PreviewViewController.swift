//
//  PreviewViewController.swift
//  Sminq_Code
//
//  Created by Manish Prasad on 03/04/19.
//  Copyright © 2019 Manish. All rights reserved.
//

import UIKit
import Cloudinary

class PreviewViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    var uploadedImageUrlArray : [Photo?] = []
    @IBOutlet var collectionView : UICollectionView!
    @IBOutlet var activityIndicator : UIActivityIndicatorView!
    
    var cloudinary = CLDCloudinary(configuration: CLDConfiguration(cloudName: "your_cloud_name", apiKey:"api_key", secure: true))
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.startAnimating()
        self.collectionView.reloadData()
    }
    
    
     func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return uploadedImageUrlArray.count
    }
    
     func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "image_collection_cell", for: indexPath) as! ImageCollectionViewCell
        
        let photo = uploadedImageUrlArray[indexPath.row]
        let downloader = cloudinary.createDownloader()
        downloader.fetchImage(photo!.imageUrl!) {[unowned self] (image, error) in
                if let error = error {
                    print("Error downloading image : \(error)")
                }else{
                    DispatchQueue.main.async {
                        self.activityIndicator.isHidden = true
                        cell.imageViewCell.image = image
                }
                }
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let scaleFactor = (screenWidth / 3) - 6
        return CGSize(width: scaleFactor, height: 190)
    
    }

}
