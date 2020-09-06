//
//  HomeViewAlerts.swift
//  CloudDefender_V1_VIPER
//
//  Created by maksim on 17.08.2020.
//  Copyright © 2020 maksim. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

extension HomeCollectionViewController  {
    
    static var operation : String?
    
    func FolderLongPressed(folderName : String, folderId : String, folderIndex : Int){
        
        let alert = UIAlertController(title: "\(folderName)", message: "Что выхотите сделать?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Поделиться доступом", style: UIAlertAction.Style.default, handler:
            
            { action in
                var SummLevel = 0
                var StringValue = ""
                let createValue : Bool? = false
                let readValue : Bool? = false
                let deleteValue : Bool? = false
                let ownerValue : Bool? = false
                let controller = HomeAccessLevelAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                controller.addAction(UIAlertAction(title: "ОК", style: .default, handler:   { action in
                    
                    if createValue == true {
                        SummLevel += 1
                    }
                    if readValue == true {
                        SummLevel += 2
                    }
                    if deleteValue == true {
                        SummLevel += 8
                    }
                    if ownerValue == true {
                        SummLevel = 15
                    }
                    
                    if createValue == true && readValue == false && deleteValue == false{
                        StringValue = "Вы уверены, что хотите поделиться с доступом на создание?"
                    }
                    if createValue == true && readValue == true{
                        StringValue = "Вы уверены, что хотите поделиться с доступом на создание и чтение?"
                    }
                    if createValue == true && deleteValue == true{
                        StringValue = "Вы уверены, что хотите поделиться с доступом на создание и удаление?"
                    }
                    if readValue == true && createValue == false && deleteValue == false{
                        StringValue = "Вы уверены, что хотите поделиться с доступом на чтение?"
                    }
                    if readValue == true && deleteValue == true{
                        StringValue = "Вы уверены, что хотите поделиться с доступом на чтение и удаление?"
                    }
                    if deleteValue == true && readValue == false && createValue == false{
                        StringValue = "Вы уверены, что хотите поделиться с доступом на удаление?"
                    }
                    if createValue == true && deleteValue == true{
                        StringValue = "Вы уверены, что хотите поделиться с доступом на создание и удаление?"
                    }
                    if createValue == true && readValue == true && deleteValue == true{
                        StringValue = "Вы уверены, что хотите поделиться на создание, чтение и удаление?"
                    }
                    if ownerValue == true{
                        StringValue = "Вы уверены, что хотите поделиться максимальным доступом?"
                    }
                    
                    let alert = UIAlertController(title: "Внимание!", message: "\(StringValue)", preferredStyle: UIAlertController.Style.alert)
                    let shareFolder = UIAlertAction(title: "Поделиться", style: .cancel) { (alertAction) in
                        
                        let textField1 = alert.textFields![0] as UITextField
                        let textField2 = alert.textFields![1] as UITextField
                        
                        if  textField1.text != "" && textField2.text != ""{
                            let userName = textField1.text!
                            let userEmail = textField2.text!
                            
                            self.presenter?.shareFolder(folderId: folderId, folderName : folderName, userName: userName, userEmail: userEmail, accessLevel: SummLevel)
                            self.showActivityIndicatory()
                        } else {
                            self.errorAlert(errorMessage: "Ошибка: Вы не заполнили поля")
                        }
                    }
                    
                    alert.addTextField { (textField1) in
                        textField1.placeholder = "Имя пользователя"
                        textField1.borderStyle = UITextField.BorderStyle.roundedRect
                    }
                    alert.addTextField { (textField2) in
                        textField2.placeholder = "email"
                        textField2.borderStyle = UITextField.BorderStyle.roundedRect
                    }
                    
                    let cancel = UIAlertAction(title: "Отменить", style: .destructive) { (alertAction) in }
                    alert.addAction(shareFolder)
                    alert.addAction(cancel)
                    self.present(alert, animated: true, completion: nil)
                    
                }))
                controller.addAction(UIAlertAction(title: "Отменить", style: .destructive, handler: nil))
                self.present(controller, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Владельцы папки", style: UIAlertAction.Style.default, handler:
            
            { action in
                var owners = self.foldersItem?.folder.owners
                if owners?.count == 0{
                    owners?.append("\(self.userName!)")
                }
                let alert = UIAlertController(title: "Владельцы папки", message: "\(owners!)" , preferredStyle: UIAlertController.Style.alert)
                let OKAction = UIAlertAction(title: "OK", style: .cancel) { (alertAction) in }
                alert.addAction(OKAction)
                self.present(alert, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Удалить папку", style: UIAlertAction.Style.destructive, handler:
            
            { action in
                let alert = UIAlertController(title: "Внимание!", message: "Вы уверены, что хотите удалить папку '\(folderName)'?", preferredStyle: UIAlertController.Style.alert)
                let deleteFolder = UIAlertAction(title: "Удалить", style: .cancel) { (alertAction) in
                    self.presenter?.deleteFolder(folderId: folderId, folderName : folderName)
                    self.showActivityIndicatory()
                }
                let cancel = UIAlertAction(title: "Отменить", style: .destructive) { (alertAction) in }
                alert.addAction(deleteFolder)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
        self.present(alert, animated: true)
        
    }
    
    func FileLongPressed(fileName : String, fileId : String, fileIndex : Int){
        
        let alert = UIAlertController(title: "\(fileName)", message: "Что выхотите сделать?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Скачать", style: UIAlertAction.Style.default, handler:
            
            { action in
                let alert = UIAlertController(title: "Внимание!", message: "Вы уверены, что хотите скачать файл?", preferredStyle: UIAlertController.Style.alert)
                let downloadFile = UIAlertAction(title: "Скачать", style: .cancel) { (alertAction) in
                    self.presenter?.downloadFile(fileId: fileId, fileName: fileName)
                    self.showActivityIndicatory()
                }
                let cancel = UIAlertAction(title: "Отменить", style: .destructive) { (alertAction) in }
                alert.addAction(downloadFile)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Обновить", style: UIAlertAction.Style.default, handler:
            
            { action in
                HomeCollectionViewController.operation = "updateFile"
                let alert = UIAlertController(title: "Обновление файла", message: "Выберите файл", preferredStyle: UIAlertController.Style.alert)
                
                let actionManagerFiles = UIAlertAction(title: "Менеджер файлов", style: .default, handler: { (action) -> Void in
                    let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypeData)], in: .import)
                    importMenu.delegate = self
                    self.present(importMenu, animated: true, completion: nil)
                })
                let actionGallery = UIAlertAction(title: "Галерея", style: .default, handler: { (action) -> Void in
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    self.present(imagePicker, animated: true, completion: nil)
                })
                alert.addAction(actionManagerFiles)
                alert.addAction(actionGallery)
                let cancel = UIAlertAction(title: "Отменить", style: .default) { (alertAction) in }
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Удалить", style: UIAlertAction.Style.destructive, handler:
            
            { action in
                let formatFile = "\(fileName)".lowercased().components(separatedBy: ".")[1]
                var fileResult = ""
                switch formatFile {
                case "pdf":
                    fileResult = "документ"
                case "png", "heic", "webp", "bmp", "gif", "jpe", "jpeg", "jpg", "svg", "tif", "tiff":
                    fileResult = "изображение"
                case "webm","mp2","mpa","mpe","mpeg","mpg","mpv2","qt","mov","movie","flv","mp4","ts","3gp","3gpp","3gp2","3gpp2","avi","wmv":
                    fileResult = "видео"
                case "wma","mp3","m4a","ogg","wav":
                    fileResult = "музыку"
                default:
                    fileResult = "файл"
                }
                let alert = UIAlertController(title: "Удаление файла", message: "Вы уверены, что хотите удалить \(fileResult) \(fileName)?", preferredStyle: UIAlertController.Style.alert)
                let deleteFile = UIAlertAction(title: "ОК", style: .default) { (alertAction) in
                    self.presenter?.deleteFile(fileId: fileId, fileName : fileName)
                    self.showActivityIndicatory()
                }
                let cancel = UIAlertAction(title: "Отменить", style: .default) { (alertAction) in }
                alert.addAction(deleteFile)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func SettingsAlert(){
        
        let alert = UIAlertController(title: "Внимание!", message: "Вы уверены, что хотите выйти из аккаунта?", preferredStyle: UIAlertController.Style.alert)
        let leave = UIAlertAction(title: "Выйти", style: .destructive) { (alertAction) in
            self.presenter?.userExit(navigationController: self.navigationController!)
            self.dismiss(animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Отменить", style: .cancel) { (alertAction) in }
        alert.addAction(cancel)
        alert.addAction(leave)
        self.present(alert, animated: true, completion: nil)
    }
    
    func AddAlert(){
        
        let alert = UIAlertController(title: "Добавить", message: "Что выхотите сделать?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Создать папку", style: UIAlertAction.Style.default, handler:
            { action in
                let alert = UIAlertController(title: "Создание папки", message: "Введите название папки", preferredStyle: UIAlertController.Style.alert)
                let createFolder = UIAlertAction(title: "Создать", style: .default) { (alertAction) in
                    let textField = alert.textFields![0] as UITextField
                    if textField.text != "" {
                        let newFolderName = textField.text!
                        self.presenter?.createFolder(folderId: self.folderId ?? "00000000-0000-0000-0000-000000000000", newFolderName: newFolderName)
                        self.showActivityIndicatory()
                    } else {
                        self.errorAlert(errorMessage: "Ошибка: Вы не ввели название папки")
                    }
                }
                alert.addTextField { (textField) in
                    textField.placeholder = "Название папки"
                    textField.borderStyle = UITextField.BorderStyle.roundedRect
                }
                alert.addAction(createFolder)
                let cancel = UIAlertAction(title: "Отменить", style: .default) { (alertAction) in }
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
        }))
        
        if foldersItem?.folder.folderName == "root"{
        }else{
            alert.addAction(UIAlertAction(title: "Загрузить файл в облако", style: UIAlertAction.Style.default, handler:
                { action in
                    HomeCollectionViewController.operation = "uploadFile"
                    let alert = UIAlertController(title: "Загрузка файла", message: "Выберите файл", preferredStyle: UIAlertController.Style.alert)
                    let actionManagerFiles = UIAlertAction(title: "Менеджер файлов", style: .default, handler: { (action) -> Void in
                        let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypeData)], in: .import)
                        importMenu.delegate = self
                        self.present(importMenu, animated: true, completion: nil)
                    })
                    let actionGallery = UIAlertAction(title: "Галерея", style: .default, handler: { (action) -> Void in
                        let imagePicker = UIImagePickerController()
                        imagePicker.delegate = self
                        self.present(imagePicker, animated: true, completion: nil)
                    })
                    alert.addAction(actionManagerFiles)
                    alert.addAction(actionGallery)
                    let cancel = UIAlertAction(title: "Отменить", style: .default) { (alertAction) in }
                    alert.addAction(cancel)
                    self.present(alert, animated: true, completion: nil)
            }))
        }
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func afterCameraAlert(fileName : String, file : Data){
        
        let alert = UIAlertController(title: "Загрузить файл", message: "\(fileName)", preferredStyle: .alert)
        let imageView = UIImageView(frame: CGRect(x: 40, y: 60, width: 200, height: 200))
        imageView.image = UIImage(data: file)
        alert.view.addSubview(imageView)
        let height = NSLayoutConstraint(item: alert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 320)
        let width = NSLayoutConstraint(item: alert.view!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
        alert.view.addConstraint(height)
        alert.view.addConstraint(width)
        let actionСamera = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
        })
        alert.addAction(actionСamera)
        alert.addAction(UIAlertAction(title: "Отменить", style: .destructive, handler: nil))
        self.present(alert, animated: true)
    }
    
    func errorAlert(errorMessage : String){
        
        let alert = UIAlertController(title: "Ошибка!", message: "\(errorMessage)",preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func successAlert(successMessage : String){
        
        let alert = UIAlertController(title: "Успех!", message: "\(successMessage)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

