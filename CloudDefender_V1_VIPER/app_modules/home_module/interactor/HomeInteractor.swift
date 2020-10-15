//
//  HomeInteractor.swift
//  CloudDefender_V1_VIPER
//
//  Created by maksim on 31.07.2020.
//  Copyright © 2020 maksim. All rights reserved.
//

import Foundation
import UIKit

final class HomeInteractor : PresenterToHomeInteractorProtocol{
    
    var presenter: InteractorToHomePresenterProtocol?
    
    fileprivate let networkDataFetcher : NetworkDataFetcher = NetworkDataFetcher()
    fileprivate let coreData : CoreData = CoreData()
    
    fileprivate var folderResponse: Folder?
    
    fileprivate var lastFolderId = [String]()
    fileprivate var lastFolderName = [String]()
    fileprivate var userId : String? = nil
    
    func getFoldersRequest(folderId : String?, direction : String?, userId : String?) {
        
        guard let folderId = folderId, let userId = userId else { return }
        networkDataFetcher.fetchFolders(folderId: folderId, userId : userId, parameters: [:]) { (folderResponse) in
            guard let folderResponse = folderResponse else { return }
            self.folderResponse = folderResponse
            if direction == "forward"{
                if self.lastFolderId.contains(where: {$0 == "\((self.folderResponse?.folder?.folderId)!)"}) {
                } else {
                    self.lastFolderId.append((self.folderResponse?.folder?.folderId)!)
                    self.lastFolderName.append((self.folderResponse?.folder?.folderName)!)
                    if self.lastFolderId.count == 1 && self.lastFolderId.last != "00000000-0000-0000-0000-000000000000"{
                        
                    }else{
                        UserDefaults.standard.set(self.lastFolderId, forKey: "lastFolderIdArray")
                        UserDefaults.standard.set(self.lastFolderName, forKey: "lastFolderNameArray")
                    }
                }
            }else{
            }
            self.presenter?.fetchedSuccessFolders(folders : folderResponse)
        }
    }
    
    func forwardGetFoldersRequest(folderId : String?, userId : String?){
        
        self.userId = userId
        Reachability.isConnectedToNetwork{ (isConnected) in
            if isConnected {
                if UserDefaults.standard.stringArray(forKey: "lastFolderIdArray")?.count == nil {
                    getFoldersRequest(folderId : "00000000-0000-0000-0000-000000000000", direction : "forward", userId:  userId)
                }else{
                    if self.lastFolderId.count == 0{
                        getFoldersRequest(folderId : "00000000-0000-0000-0000-000000000000", direction : "forward", userId: userId)
                    }else{
                        getFoldersRequest(folderId : folderId, direction : "forward", userId: userId)
                    }
                }
            } else {
                self.presenter?.errorAlert(errorMessage : "У Вас отсутствует интернет-соединение - обновите! Как исправите - сделайте свайп вверх для обновления")
            }
        }
    }
    
    func backGetFoldersRequest(folderId : String?, userId : String?){
        
        Reachability.isConnectedToNetwork { (isConnected) in
            if isConnected {
                self.userId = userId
                
                guard UserDefaults.standard.stringArray(forKey: "lastFolderIdArray")?.count != 0 else { return }
                if UserDefaults.standard.stringArray(forKey: "lastFolderIdArray")?.count ?? 1 > 1{
                    
                    if self.lastFolderId.count == 1 && self.lastFolderId.last != "00000000-0000-0000-0000-000000000000"{
                        
                        var a = UserDefaults.standard.stringArray(forKey: "lastFolderIdArray")
                        var b = UserDefaults.standard.stringArray(forKey: "lastFolderNameArray")
                        
                        a!.removeLast()
                        b!.removeLast()
                        
                        UserDefaults.standard.set(a, forKey: "lastFolderIdArray")
                        UserDefaults.standard.set(b, forKey: "lastFolderNameArray")
                        
                    }else{
                        self.lastFolderId.removeLast()
                        self.lastFolderName.removeLast()
                        
                        UserDefaults.standard.set(self.lastFolderId, forKey: "lastFolderIdArray")
                        UserDefaults.standard.set(self.lastFolderName, forKey: "lastFolderNameArray")
                    }
                    
                }
                
                switch UserDefaults.standard.stringArray(forKey: "lastFolderIdArray")?.count {
                case 0:
                    getFoldersRequest(folderId :  "00000000-0000-0000-0000-000000000000", direction : "back", userId : userId)
                    
                    UserDefaults.standard.removeObject(forKey: "lastFolderIdArray")
                    UserDefaults.standard.removeObject(forKey: "lastFolderNameArray")
                    
                    self.lastFolderId.removeAll()
                    self.lastFolderName.removeAll()
                    
                default:
                    if self.lastFolderId.count == 1 && self.lastFolderId.last != "00000000-0000-0000-0000-000000000000"{
                        
                        getFoldersRequest(folderId : "00000000-0000-0000-0000-000000000000", direction : "back", userId: userId)
                        UserDefaults.standard.removeObject(forKey: "lastFolderIdArray")
                        UserDefaults.standard.removeObject(forKey: "lastFolderNameArray")
                        self.lastFolderId.removeAll()
                        self.lastFolderName.removeAll()
                    }else{
                        
                        getFoldersRequest(folderId :  UserDefaults.standard.stringArray(forKey: "lastFolderIdArray")?.last! ?? "00000000-0000-0000-0000-000000000000", direction : "back", userId: userId)
                    }
                    
                }
            } else {
                self.presenter?.errorAlert(errorMessage : "У Вас отсутствует интернет-соединение - обновите! Как исправите - сделайте свайп вверх для обновления")
            }
        }
    }
    
    func deleteFolderRequest(folderId : String?, folderName : String?) {
        
        let whois = "deleteFolder"
        guard let folderId = folderId, let folderName = folderName, let userId = userId else { return }
        networkDataFetcher.fetch(userId: userId, pathId: folderId, whois: whois, parameters : [:])
        { (folderResponse) in
            guard folderResponse != nil else { return }
            let responseString = String(decoding: folderResponse!, as: UTF8.self)
            if responseString == ""{
                self.presenter?.successAlert(successMessage: "Папка \(folderName) удалена!", whois : "deleteFolder")
            }else{
                self.presenter?.errorAlert(errorMessage: "Ошибка: \(responseString)")
            }
        }
    }
    
    func createFolderRequest(folderId : String?, newFolderName : String?) {
        
        let whois = "createFolder"
        guard let folderId = folderId, let newFolderName = newFolderName else { return }
        let parameters : [String: Any] = [ "parentFolderId" : "\(folderId)", "newFolderName" : "\(newFolderName)"]
        networkDataFetcher.fetch(userId: userId!, pathId: "", whois: whois, parameters : parameters)
        { (folderResponse) in
            guard folderResponse != nil else { return }
            let responseString = String(decoding: folderResponse!, as: UTF8.self)
            let a = responseString.dropLast()
            let b = a.dropFirst()
            if b.count == 36{
                self.presenter?.successAlert(successMessage: "Папка \(newFolderName) создана!", whois: "createFolder")
                self.folderResponse?.folder?.folders?.append(Folders(folderId: "\(b)", folderName: "\(newFolderName)"))
            }else{
                self.presenter?.errorAlert(errorMessage: "Ошибка: \(responseString)")
            }
        }
    }
    
    func shareFolderRequest(folderId : String?, folderName : String?, userName : String?, userEmail : String?, accessLevel : Int?) {
        
        let whois = "shareFolder"
        guard let folderId = folderId, let folderName = folderName, let userName = userName, let userEmail = userEmail else { return }
        let parameters : [String: Any] = [ "folderId" : "\(folderId)", "userName" : "\(userName)", "email" : "\(userEmail)", "accessLevel" : accessLevel!]
        networkDataFetcher.fetch(userId: userId!, pathId: "", whois: whois, parameters : parameters) { (folderResponse) in
            guard folderResponse != nil else { return }
            let responseString = String(decoding: folderResponse!, as: UTF8.self)
            if responseString == ""{
                self.presenter?.successAlert(successMessage: "Вы поделились доступом к папке \(folderName) с \(userName)!", whois: "shareFolder")
            }else{
                self.presenter?.errorAlert(errorMessage: "Ошибка: \(responseString)")
            }
        }
    }
    
    func downloadFileRequest(fileId : String?, fileName : String?){
        
        let nameType = checkFileType(fileName : fileName!).0
        let whois = "downloadFile"
        guard let fileId = fileId, let userId = userId, let fileName = fileName else { return }
        networkDataFetcher.fetch(userId: userId, pathId: fileId, whois: whois, parameters: [:]) { (file) in
            guard file != nil else {
                let responseString = String(decoding: file!, as: UTF8.self)
                self.presenter?.errorAlert(errorMessage: "Ошибка: \(responseString)")
                return
            }
            switch nameType {
            case "image":
                UIImageWriteToSavedPhotosAlbum(UIImage(data: file!)!, self, nil, nil)
                self.presenter?.successAlert(successMessage: "Файл \(fileName) сохранен в Галерее!", whois: "downloadFile")
            case "document", "video", "audio":
                let pathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(fileName)")
                do {
                    try file!.write(to: pathURL, options: .atomic)
                    self.presenter?.successAlert(successMessage: "Файл \(fileName) сохранен в Files!", whois: "downloadFile")
                }catch{
                    self.presenter?.errorAlert(errorMessage: "Ошибка при записи: \(error)")
                }
            default:
                self.presenter?.errorAlert(errorMessage: "Неизвестный тип файла")
            }
        }
    }
    
    func deleteFileRequest(fileId : String?, fileName : String?){
        
        let whois = "deleteFile"
        guard let fileId = fileId, let userId = userId else { return }
        networkDataFetcher.fetch(userId: userId, pathId: fileId, whois: whois, parameters: [:]) { (file) in
            guard file != nil else { return }
            let responseString = String(decoding: file!, as: UTF8.self)
            if responseString == ""{
                self.presenter?.successAlert(successMessage: "Файл \(fileName!) удален!", whois: "deleteFile")
            }else{
                self.presenter?.errorAlert(errorMessage: "Ошибка: \(responseString)")
            }
        }
    }
    
    func uploadFileRequest(folderId : String?, file : Data?, fileName : String?, fileType: String?){
        
        guard let folderId = folderId, let file = file, let fileName = fileName, let fileType = fileType, let userId = userId else { return }
        let memeType = checkMimeType(filetype : fileType)
        let parameters = [
            [
                "key": "File",
                "file": file,
                "type": "file"
            ],
            [
                "key": "FolderId",
                "value": "\(folderId)",
                "type": "text"
            ]]
        networkDataFetcher.fetchUploadFile(userId: userId, fileName: fileName, mime: memeType, data: file, parameters: parameters) { (response) in
            guard response != nil else { return }
            let responseString = String(decoding: response!, as: UTF8.self)
            let a = responseString.dropLast()
            let b = a.dropFirst()
            if b.count == 36{
                self.presenter?.successAlert(successMessage: "Файл \(fileName)) загружен в CloudDefender!", whois: "uploadFile")
                self.folderResponse?.folder?.files?.append(Files(fileId: "\(b)", fileName: "\(fileName)"))
            }else{
                self.presenter?.errorAlert(errorMessage: "Ошибка: \(responseString)")
            }
        }
    }
    
    func updateFileRequest(folderId : String?, fileId : String?, updatedfile : Data?, fileName : String?, fileType: String?){
        
        guard let folderId = folderId, let fileId = fileId, let updatedfile = updatedfile, let fileName = fileName, let fileType = fileType, let userId = userId else { return }
        let memeType = checkMimeType(filetype : fileType)
        let parameters = [
            [
                "key": "UpdatedFile",
                "file": updatedfile,
                "type": "file"
            ],
            [
                "key": "FolderId",
                "value": "\(folderId)",
                "type": "text"
            ],
            [
                "key": "FileId",
                "value": "\(fileId)",
                "type": "text"
            ]]
        networkDataFetcher.fetchUploadFile(userId: userId, fileName: fileName, mime: memeType, data: updatedfile, parameters: parameters) { (response) in
            guard response != nil else { return }
            let responseString = String(decoding: response!, as: UTF8.self)
            if responseString == ""{
                self.presenter?.successAlert(successMessage: "Файл \(fileName) обновлен в CloudDefender!", whois: "updateFile")
            }else{
                self.presenter?.errorAlert(errorMessage: "Ошибка: \(responseString)")
            }
        }
    }
    
    func userExit(navigationController : UINavigationController?) {
        
        coreData.deleteUser()
        presenter?.exitUser(navigationController: navigationController)
        UserDefaults.standard.removeObject(forKey: "lastFolderIdArray")
        UserDefaults.standard.removeObject(forKey: "lastFolderNameArray")
    }
    
    func checkingFolderIndex(folderIndex : Int?){
        
        guard let folderResponse = folderResponse else { return }
        let folderId = folderResponse.folder?.folders?[folderIndex!].folderId
        getFoldersRequest(folderId: folderId!, direction : "forward", userId: userId!)
    }
    
    func checkingFileIndex(fileIndex: Int?, navigationController : UINavigationController?) {
        
        guard let fileName = folderResponse?.folder?.files?[fileIndex!].fileName, let fileId = folderResponse?.folder?.files?[fileIndex!].fileId, let userId = userId else { return }
        let fileType = checkFileType(fileName: fileName).1
        let whois = "downloadFile"
        
        networkDataFetcher.fetch(userId: userId, pathId: fileId, whois: whois, parameters: [:]) { (file) in
            guard file != nil else {
                let responseString = String(decoding: file!, as: UTF8.self)
                self.presenter?.errorAlert(errorMessage: "Ошибка: \(responseString)")
                return
            }
            let pathURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent("\(fileName)")
            do {
                try file!.write(to: pathURL, options: .atomic)
            }catch{
                self.presenter?.errorAlert(errorMessage: "Ошибка при записи: \(error)")
            }
            self.presenter?.goToFile(navigationController: navigationController, fileURL: pathURL, fileName: fileName, fileType : fileType)
        }
    }
    
    private func checkingFileName(folderIndex: Int) -> String{
        
        guard let folderResponse = folderResponse, let fileName = folderResponse.folder?.files?[folderIndex].fileName else { return "unknown"}
        return fileName
    }
    
    private func checkMimeType(filetype : String) -> String{
        
        let mimeTypeTest = "\(filetype)"
        switch mimeTypeTest {
        // MARK: - Image
        case "png":
            return "image/png"
        case "heic":
            return "image/heic"
        case "webp":
            return "image/webp"
        case "bmp":
            return "image/bmp"
        case "gif":
            return "image/gif"
        case "jpe","jpeg","jpg":
            return "image/jpeg"
        case "jfif":
            return "image/pipeg"
        case "svg":
            return "image/svg+xml"
        case "tif","tiff":
            return "image/tiff"
        // MARK: - Document
        case "pdf":
            return "application/pdf"
        case "doc","dot":
            return "application/msword"
        case "docx":
            return "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        case "dotx":
            return "application/vnd.openxmlformats-officedocument.wordprocessingml.template"
        case "docm":
            return "application/vnd.ms-word.document.macroEnabled.12"
        case "dotm":
            return "application/vnd.ms-word.template.macroEnabled.12"
        case "xls","xlt","xla":
            return "application/vnd.ms-excel"
        case "xlsx":
            return "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        case "xltx":
            return "application/vnd.openxmlformats-officedocument.spreadsheetml.template"
        case "xlsm":
            return "application/vnd.ms-excel.sheet.macroEnabled.12"
        case "xltm":
            return "application/vnd.ms-excel.template.macroEnabled.12"
        case "xlam":
            return "application/vnd.ms-excel.addin.macroEnabled.12"
        case "xlsb":
            return "application/vnd.ms-excel.sheet.binary.macroEnabled.12"
        case "ppt","pot","pps","ppa":
            return "application/vnd.ms-powerpoint"
        case "pptx":
            return "application/vnd.openxmlformats-officedocument.presentationml.presentation"
        case "potx":
            return "application/vnd.openxmlformats-officedocument.presentationml.template"
        case "ppsx":
            return "application/vnd.openxmlformats-officedocument.presentationml.slideshow"
        case "ppam":
            return "application/vnd.ms-powerpoint.addin.macroEnabled.12"
        case "pptm":
            return "application/vnd.ms-powerpoint.presentation.macroEnabled.12"
        case "potm":
            return "application/vnd.ms-powerpoint.template.macroEnabled.12"
        case "ppsm":
            return "application/vnd.ms-powerpoint.slideshow.macroEnabled.12"
        case "mdb":
            return "application/vnd.ms-access"
        // MARK: - Video
        case "webm":
            return "video/webm"
        case "mp2","mpa","mpe","mpeg","mpg","mpv2":
            return "video/mpeg"
        case "qt", "mov":
            return "video/quicktime"
        case "movie":
            return "video/x-sgi-movie"
        case "flv":
            return "video/x-flv"
        case "mp4":
            return "video/mp4"
        case "ts":
            return "video/MP2T"
        case "3gp","3gpp":
            return "video/3gpp"
        case "3gp2","3gpp2":
            return "video/3gpp2"
        case "avi":
            return "video/x-msvideo"
        case "wmv":
            return "video/x-ms-wmv"
        // MARK: - Audio
        case "wma":
            return "audio/x-ms-wma"
        case "mp3":
            return "audio/mpeg"
        case "m4a":
            return "audio/mp4"
        case "ogg":
            return "audio/ogg"
        case "wav":
            return "audio/vnd.wav"
        default:
            return "unknown"
        }
    }
    
    private func checkFileType(fileName : String) -> (String, String){
        let imageType = ["png","heic","webp","bmp","gif","jpe","jpeg","jpg","svg","tif","tiff"]
        let documentType = ["pdf","doc","dot","docx","dotx","docm","dotm","xls","xlt","xla","xlsx","xltx","xltm","xlam","xlsb","ppt","pot","pps","ppa","pptx","potx","ppsx","ppam","pptm","potm","ppsm","mdb"]
        let videoType = ["webm","mp2","mpa","mpe","mpeg","mpg","mpv2","qt","mov","movie","flv","mp4","ts","3gp","3gpp","3gp2","3gpp2","avi","wmv"]
        let audioType = ["wma","mp3","m4a","ogg","wav"]
        
        let typeTest = "\(fileName)".lowercased().components(separatedBy: ".")[1]
        
        for i in 0...imageType.count-1{
            if typeTest == imageType[i]{
                return ("image","\(imageType[i])")
            }else{
            }
        }
        
        for i in 0...documentType.count-1{
            if typeTest == documentType[i]{
                return ("document","\(documentType[i])")
            }else{
            }
        }
        
        for i in 0...videoType.count-1{
            if typeTest == videoType[i]{
                return ("video","\(videoType[i])")
            }else{
            }
        }
        
        for i in 0...audioType.count-1{
            if typeTest == audioType[i]{
                return ("audio","\(audioType[i])")
            }else{
            }
        }
        return ("unknown","uknw")
    }
}
