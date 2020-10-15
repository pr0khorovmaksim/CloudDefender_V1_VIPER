//
//  HomePresenter.swift
//  CloudDefender_V1_VIPER
//
//  Created by maksim on 31.07.2020.
//  Copyright © 2020 maksim. All rights reserved.
//

import Foundation
import UIKit

final class HomePresenter : ViewToHomePresenterProtocol{
    
    var view: PresenterToHomeViewProtocol?
    var interactor: PresenterToHomeInteractorProtocol?
    var router: PresenterToHomeRouterProtocol?
    
    func fetchFolders(folderId : String?, userId : String?){
        interactor?.forwardGetFoldersRequest(folderId: folderId, userId : userId)
    }
    
    func deleteFolder(folderId: String?, folderName : String?) {
        interactor?.deleteFolderRequest(folderId: folderId, folderName : folderName)
    }
    
    func createFolder(folderId: String?, newFolderName: String?) {
        interactor?.createFolderRequest(folderId: folderId, newFolderName: newFolderName)
    }
    
    func shareFolder(folderId: String?, folderName : String?, userName: String?, userEmail: String?, accessLevel: Int?) {
        interactor?.shareFolderRequest(folderId: folderId, folderName : folderName, userName: userName, userEmail: userEmail, accessLevel: accessLevel)
    }
    
    func downloadFile(fileId: String?, fileName : String?) {
        interactor?.downloadFileRequest(fileId: fileId, fileName: fileName)
    }
    
    func deleteFile(fileId: String?, fileName : String?) {
        interactor?.deleteFileRequest(fileId: fileId, fileName : fileName)
    }
    
    func uploadFile(folderId : String?, file : Data?, fileName : String?, fileType: String?) {
        interactor?.uploadFileRequest(folderId : folderId, file : file, fileName : fileName, fileType: fileType)
    }
    
    func updateFile(folderId: String?, fileId: String?, updatedfile: Data?, fileName : String?, fileType: String?) {
        interactor?.updateFileRequest(folderId: folderId, fileId: fileId, updatedfile: updatedfile, fileName : fileName, fileType: fileType)
        
    }
    
    func userExit(navigationController : UINavigationController?) {
        interactor?.userExit(navigationController: navigationController)
    }
    
    func back(folderId: String?, userId : String?) {
        interactor?.backGetFoldersRequest(folderId: folderId, userId : userId)
    }
    
    func didselectFolder(folderIndex : Int?){
        interactor?.checkingFolderIndex(folderIndex: folderIndex)
    }
    
    func didselectFile(fileIndex : Int?, navigationController : UINavigationController?){
        interactor?.checkingFileIndex(fileIndex: fileIndex,navigationController : navigationController )
    }
}

extension HomePresenter : InteractorToHomePresenterProtocol{
    func fetchedSuccessFolders(folders: Folder?) {
        view?.showFolders(folders: folders)
    }
    
    func errorAlert(errorMessage : String?){
        view?.showErrorAlert(errorMessage : errorMessage)
    }
    
    func successAlert(successMessage : String?, whois : String?){
        view?.showSuccessAlert(successMessage : successMessage, whois: whois)
    }
    
    func goToFile(navigationController: UINavigationController?, fileURL : URL?, fileName : String?, fileType : String?){
        router?.showFileViewController(navigationController: navigationController, fileURL : fileURL, fileName : fileName, fileType : fileType)
    }
    
    func exitUser(navigationController: UINavigationController?){
        router?.showSignViewController(navigationController: navigationController)
    }
}
