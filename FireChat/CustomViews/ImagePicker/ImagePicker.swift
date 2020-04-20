//
//  ImagePicker.swift
//  FireChat
//
//  Created by Petre Vane on 20/04/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit

protocol ImagePickerDelegate: AnyObject {
    func didSelect(image: UIImage)
}

class ImagePicker: NSObject {
    
    var imagePickerController: UIImagePickerController
    weak var presentingController: UIViewController?
    weak var delegate: ImagePickerDelegate?
    
    init(presentingController: UIViewController, delegate: ImagePickerDelegate) {
        self.imagePickerController = UIImagePickerController()
        super.init()
        self.presentingController = presentingController
        self.delegate = delegate
        self.imagePickerController.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        self.imagePickerController.allowsEditing = true
        self.imagePickerController.mediaTypes = ["public.image"]
    }
    
    func selectImageFrom(source type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        
        guard UIImagePickerController.isSourceTypeAvailable(type) else { return nil }
        return UIAlertAction(title: title, style: .default) { [unowned self] (action) in
            
            self.imagePickerController.sourceType = type
            self.presentingController?.present(self.imagePickerController, animated: true, completion: nil)
            
        }
    }
    
    func presentAlert(from view: UIView) {
        
        let alertController = UIAlertController(title: "Pick your Image", message: "Select where your image is saved", preferredStyle: .alert)
        
        if let cameraAction = self.selectImageFrom(source: .camera, title: "Camera") {
            alertController.addAction(cameraAction)
        }
        
        if let photoLibraryAction = self.selectImageFrom(source: .photoLibrary, title: "Photo Library") {
            alertController.addAction(photoLibraryAction)
        }
        
        if let savedPhotosAction = self.selectImageFrom(source: .savedPhotosAlbum, title: "Saved Photos") {
            alertController.addAction(savedPhotosAction)
        }
        
        self.presentingController?.present(alertController, animated: true, completion: nil)
    }
    
    func imagePicker(didSelect image: UIImage?, _ controller: UIImagePickerController) {
        
        if let selectedImage = image {
            self.delegate?.didSelect(image: selectedImage)
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
}

extension ImagePicker: UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imagePicker(didSelect: nil, picker)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return self.imagePicker(didSelect: nil, picker) }
        self.imagePicker(didSelect: image, picker)
    }
    
}


extension ImagePicker: UINavigationControllerDelegate { }

