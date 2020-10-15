//
//  HomeViewPickerController.swift
//  CloudDefender_V1_VIPER
//
//  Created by maksim on 18.08.2020.
//  Copyright © 2020 maksim. All rights reserved.
//

import Foundation
import UIKit
import Photos
import MobileCoreServices

extension HomeCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIDocumentPickerDelegate {
    
    static var fileName : String?
    static var fileType : String?
    static var indexForLongPress : Int?
    
    func generateNameForImage() -> String {
        let randomNumber = Int.random(in : 0...1000)
        return "IMG_\(randomNumber)"
    }
    
    func generateTypeForImage() -> String {
        let arrayTypes = ["png", "jpg", "img", "heic"]
        let randomTypeIndex = Int(arc4random_uniform(UInt32(arrayTypes.count)))
        return "\(arrayTypes[randomTypeIndex])"
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imageFromPC = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        if let url = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
            let assets = PHAsset.fetchAssets(withALAssetURLs: [url], options: nil)
            
            if let firstAsset = assets.firstObject,
                let firstResource = PHAssetResource.assetResources(for: firstAsset).first {
                HomeCollectionViewController.fileName = firstResource.originalFilename
                HomeCollectionViewController.fileType = firstResource.uniformTypeIdentifier
            } else {
                HomeCollectionViewController.fileName = generateNameForImage()
                HomeCollectionViewController.fileType = generateTypeForImage()
            }
        } else {
            HomeCollectionViewController.fileName = generateNameForImage()
            HomeCollectionViewController.fileType = generateTypeForImage()
        }
        let imageData = imageFromPC.pngData()!
        
        if HomeCollectionViewController.operation == "uploadFile"{
            presenter?.uploadFile(folderId: folderId!, file: imageData, fileName: HomeCollectionViewController.fileName!, fileType: HomeCollectionViewController.fileType!)
            showActivityIndicatory()
        }
        if HomeCollectionViewController.operation == "updateFile"{
            presenter?.updateFile(folderId: folderId!, fileId: fileId!, updatedfile: imageData, fileName: HomeCollectionViewController.fileName!, fileType: HomeCollectionViewController.fileType!)
            showActivityIndicatory()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        guard let myURL = urls.first else { return }
        do {
            let fileData = try (Data.init(contentsOf: myURL))
            HomeCollectionViewController.fileName = myURL.lastPathComponent
            HomeCollectionViewController.fileType = myURL.pathExtension
            
            if HomeCollectionViewController.operation == "uploadFile"{
                presenter?.uploadFile(folderId: folderId!, file: fileData, fileName: HomeCollectionViewController.fileName!, fileType: HomeCollectionViewController.fileType!)
                showActivityIndicatory()
            }
            if HomeCollectionViewController.operation == "updateFile"{
                presenter?.updateFile(folderId: folderId!, fileId: fileId!, updatedfile: fileData, fileName: HomeCollectionViewController.fileName!, fileType: HomeCollectionViewController.fileType!)
                showActivityIndicatory()
            }
        }
        catch (let error) {
            alert(alertTitle: "Ошибка!", alertMessage: "\(error)")
        }
    }
    public func documentMenu(_ documentMenu: UIDocumentPickerViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}
