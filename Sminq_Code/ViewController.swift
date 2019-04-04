//
//  ViewController.swift
//  Sminq_Code
//
//  Created by Manish Prasad on 03/04/19.
//  Copyright © 2019 Manish. All rights reserved.
//

import UIKit
import Cloudinary

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource {
 
    @IBOutlet var tableView : UITableView!
    var imagePicker = UIImagePickerController()
    @IBOutlet var progressView : UIProgressView?
    var publicIdList : [Photo?] = []
    var imagesUrlArray : [Photo?] = []
    
    var cloudinary = CLDCloudinary(configuration: CLDConfiguration(cloudName: "djkdxm8dj", apiKey:"383197146245273", secure: true))

    override func viewDidLoad() {
        super.viewDidLoad()
        progressView?.isHidden = true
        tableView.tableFooterView = UIView(frame: .zero)
        let preview = UIBarButtonItem(title: "Preview", style: .plain, target: self, action: #selector(previewBtnClicked))
        self.navigationItem.rightBarButtonItem = preview

        imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate

        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func uploadBtnClicked() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func previewBtnClicked() {
        if(publicIdList.count == 0){
            setUpAlert()
            return
        }
        let previewVC = storyboard?.instantiateViewController(withIdentifier: "preview_VC") as! PreviewViewController
        previewVC.uploadedImageUrlArray = imagesUrlArray
        navigationController?.pushViewController(previewVC, animated: true)
    }
    
    func setUpAlert(){
        let alert = UIAlertController(title: "Message", message: "Kindly wait for Image to Upload", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
        
    {
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let imageData = UIImageJPEGRepresentation(chosenImage, 1.0)!
       // imagesToUploadArray.append(chosenImage)
       // self.tableView.reloadData()
        dismiss(animated:true, completion: nil)
        progressView?.progress = 0.0
        setCloudinaryUploadImage(data: imageData)
        
    }
    
    func setCloudinaryUploadImage(data:Data){
        let progressHandler = {[unowned self] (progress: Progress) in
            self.progressView?.isHidden = false
            let ratio: CGFloat = CGFloat(progress.completedUnitCount) / CGFloat(progress.totalUnitCount)
            (self.progressView?.setProgress(Float(ratio), animated: true))
        }
        cloudinary.createUploader().upload(data: data, uploadPreset: "klolo9ei", progress: progressHandler) {[unowned self] (result, error) in
            self.progressView?.isHidden = true
            if let error = error {
                print("Error uploading image : \(error)")
            } else {
                if let result = result {
                    let photo = Photo(imageUrl : result.url!,publicId : result.publicId!)
                    self.publicIdList.append(photo)
                    self.imagesUrlArray.append(photo)
                    
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int{
        return publicIdList.count

    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UploadedTableViewCell = self.tableView?.dequeueReusableCell(withIdentifier: "tableCell_identifier") as! UploadedTableViewCell
        
        let photo = publicIdList[indexPath.row]
        let size: CGSize = cell.cellImageView.frame.size
        let transformation = CLDTransformation().setWidth(Int(size.width)).setHeight(Int(size.height)).setCrop(.fit)
       // cell.cellImageView.cldSetImage(url,cloudinary: self.cloudinary,placeholder: UIImage(named:"default_image"))
        if let publicId = photo?.publicId{
        cell.cellImageView.cldSetImage(publicId: publicId, cloudinary: self.cloudinary, signUrl: false, resourceType: .image, transformation: transformation, placeholder: UIImage(named:"default_image"))
       // cell.cellImageView.image = imagesToUploadArray[indexPath.row]
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 290.0
    }

    

    
}

