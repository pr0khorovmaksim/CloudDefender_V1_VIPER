//
//  HomeProtocols.swift
//  CloudDefender_V1_VIPER
//
//  Created by maksim on 31.07.2020.
//  Copyright © 2020 maksim. All rights reserved.
//

import Foundation
import UIKit

protocol ViewToHomePresenterProtocol : class{
    
    var view : PresenterToHomeViewProtocol? { get set}
    var interactor : PresenterToHomeInteractorProtocol? { get set }
    var router : PresenterToHomeRouterProtocol? { get set }
    
    func fetchFolders(folderId : String?, userId : String?)
    func didselectFolder(folderIndex : Int?)
    func didselectFile(fileIndex : Int?, navigationController : UINavigationController?)
    func back(folderId : String?, userId : String?)
    
    func deleteFolder(folderId : String?, folderName : String?)
    func createFolder(folderId : String?, newFolderName : String?)
    func shareFolder(folderId : String?, folderName : String?, userName : String?, userEmail : String?, accessLevel : Int?)
    
    func downloadFile(fileId : String?, fileName : String?)
    func deleteFile(fileId : String?, fileName : String?)
    func uploadFile(folderId : String?, file : Data?, fileName : String?, fileType: String?)
    func updateFile(folderId : String?, fileId : String?, updatedfile : Data?, fileName : String?, fileType: String?)
    
    func userExit(navigationController : UINavigationController?)
}

protocol PresenterToHomeViewProtocol : class{
    
    func showFolders(folders : Folder?)
    func showErrorAlert(errorMessage : String?)
    func showSuccessAlert(successMessage : String?, whois : String?)
}

protocol PresenterToHomeRouterProtocol : class{
    
    static func createHomeModule() -> HomeCollectionViewController
    func showFileViewController(navigationController : UINavigationController?, fileURL : URL?, fileName : String?, fileType : String?)
    func showSignViewController(navigationController : UINavigationController?)
}

protocol PresenterToHomeInteractorProtocol : class{
    
    var presenter : InteractorToHomePresenterProtocol? { get set }
    
    func checkingFolderIndex(folderIndex : Int?)
    func checkingFileIndex(fileIndex: Int?, navigationController : UINavigationController?)
    
    func getFoldersRequest(folderId : String?, direction : String?, userId : String?)
    func forwardGetFoldersRequest(folderId : String?, userId : String?)
    func backGetFoldersRequest(folderId : String?, userId : String?)
    
    func deleteFolderRequest(folderId : String?, folderName : String?)
    func createFolderRequest(folderId : String?, newFolderName : String?)
    func shareFolderRequest(folderId : String?, folderName : String?, userName : String?, userEmail : String?, accessLevel : Int?)
    
    func downloadFileRequest(fileId : String?, fileName : String?)
    func deleteFileRequest(fileId : String?, fileName : String?)
    func uploadFileRequest(folderId : String?, file : Data?, fileName : String?, fileType: String?)
    func updateFileRequest(folderId : String?, fileId : String?, updatedfile : Data?, fileName : String?, fileType: String?)
    
    func userExit(navigationController : UINavigationController?)
}

protocol InteractorToHomePresenterProtocol : class{
    
    func fetchedSuccessFolders(folders : Folder?)
    func errorAlert(errorMessage : String?)
    func successAlert(successMessage : String?, whois : String?)
    func goToFile(navigationController: UINavigationController?, fileURL : URL?, fileName : String?, fileType : String?)
    func exitUser(navigationController: UINavigationController?)
}
