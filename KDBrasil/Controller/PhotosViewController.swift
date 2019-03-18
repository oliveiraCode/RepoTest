//
//  PhotosViewController.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-03-17.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit

protocol PhotosDelegate {
    func photosValueSelected(photosValue: [UIImage])
}

class PhotosViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionViewPhotos: UICollectionView!
    
    var arrayPhotos:[UIImage] = []
    var indexPathItemForImage:Int?
    var delegate: PhotosDelegate?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.delegate?.photosValueSelected(photosValue: arrayPhotos)
    }
    
    
    //MARK: CollectionView Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayPhotos.count <= 3 ? arrayPhotos.count : 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCollectionViewCell
        
        cell.imageCellBusiness.image = arrayPhotos[indexPath.item]
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.pickImage(_:)))
        cell.imageCellBusiness.isUserInteractionEnabled = true
        cell.imageCellBusiness.tag = indexPath.item
        cell.imageCellBusiness.addGestureRecognizer(tapGestureRecognizer)
        
        return cell
    }
    
    
    //MARK -> PickImage's method
    @objc func pickImage(_ sender:AnyObject) {
        
        indexPathItemForImage = sender.view.tag //to know witch item was selected.
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: LocalizationKeys.buttonCamera, style: .default, handler: { action in
            let cameraPicker = UIImagePickerController()
            cameraPicker.delegate = self
            cameraPicker.sourceType = .camera
            cameraPicker.allowsEditing = true
            self.present(cameraPicker, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: LocalizationKeys.buttonPhotoLibrary, style: .default, handler: { action in
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true)
        }))
        
        if self.indexPathItemForImage! < self.arrayPhotos.count-1 {
            alert.addAction(UIAlertAction(title: LocalizationKeys.buttonDelete, style: .destructive, handler: { action in
                self.arrayPhotos.remove(at: self.indexPathItemForImage!)
                
                if self.indexPathItemForImage! == self.arrayPhotos.count {
                    self.arrayPhotos.append(UIImage(named: "placeholder_photo_new_ad")!)
                }
                self.collectionViewPhotos.reloadData()
            }))
        }
        
        alert.addAction(UIAlertAction(title: LocalizationKeys.buttonCancel, style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}


//MARK: PickerImage Delegate
extension PhotosViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            if (arrayPhotos.count - 1) == indexPathItemForImage {
                arrayPhotos.insert(pickedImage, at: indexPathItemForImage!)
            } else {
                arrayPhotos.remove(at: indexPathItemForImage!)
                arrayPhotos.insert(pickedImage, at: indexPathItemForImage!)
            }
        }
        
        picker.dismiss(animated: true, completion: {self.collectionViewPhotos.reloadData()})
    }
    
}

