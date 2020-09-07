//
//  HomeCollectionViewController.swift
//  CloudDefender_V1_VIPER
//
//  Created by maksim on 31.07.2020.
//  Copyright © 2020 maksim. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

final class HomeCollectionViewController: UICollectionViewController {
    
    var presenter : ViewToHomePresenterProtocol?
    
    fileprivate var coreData : CoreData = CoreData()
    
    var foldersItem : Folder?
    
    fileprivate var userId : String?
    fileprivate var check : Bool? = false
    fileprivate var indexForLongPress : Int = 0
    var folderId : String? = UserDefaults.standard.stringArray(forKey: "lastFolderIdArray")?.last ?? "00000000-0000-0000-0000-000000000000"
    var fileId : String?
    var userName : String?
    
    @IBOutlet weak var backOutlet: UIButton!
    @IBOutlet weak var addOutlet: UIBarButtonItem!
    @IBOutlet weak var settingsOutlet: UIBarButtonItem!
    
    fileprivate let activityView = UIActivityIndicatorView(style: .large)
    
    override func viewWillAppear(_ animated: Bool) {
        activityView.stopAnimating()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        check = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backOutlet.alpha = 0
        
        userId = coreData.checkingIfAUserExists().0
        userName = coreData.checkingIfAUserExists().1
        
        presenter?.fetchFolders(folderId : folderId!, userId : userId!)
        showActivityIndicatory()
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        longPressGesture.minimumPressDuration = 1.0
        longPressGesture.allowableMovement = 15
        longPressGesture.delegate = self as? UIGestureRecognizerDelegate
        self.collectionView!.addGestureRecognizer(longPressGesture)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.height/6)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(updateData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
    }
    
    @objc func updateData(refreshControl: UIRefreshControl) {
        presenter?.fetchFolders(folderId : folderId!, userId: userId!)
        refreshControl.endRefreshing()
    }
    
    @objc func longPressed(sender: UILongPressGestureRecognizer)
    {
        if sender.state == UIGestureRecognizer.State.ended {
            return
        }
        else if sender.state == UIGestureRecognizer.State.began
        {
            let p = sender.location(in: self.collectionView)
            let indexPath = self.collectionView?.indexPathForItem(at: p)
            if let index = indexPath {
                indexForLongPress = index.row
                if indexPath?.section == 0{
                    let folderName = foldersItem?.folder.folders[indexForLongPress].folderName
                    folderId = foldersItem?.folder.folders[indexForLongPress].folderId
                    FolderLongPressed(folderName: "\(folderName!)", folderId: "\(folderId!)", folderIndex: indexForLongPress)
                    
                }
                if indexPath?.section == 1{
                    let fileName = foldersItem?.folder.files[indexForLongPress].fileName
                    fileId = foldersItem?.folder.files[indexForLongPress].fileId
                    FileLongPressed(fileName: "\(fileName!)", fileId: "\(fileId!)", fileIndex: indexForLongPress)
                }
            } else {
            }
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        presenter?.back(folderId: folderId!, userId : userId!)
    }
    
    @IBAction func settingsCloud(_ sender: UIBarButtonItem) {
        SettingsAlert()
    }
    
    @IBAction func userActionCloud(_ sender: UIBarButtonItem) {
        AddAlert()
    }
    
    func showActivityIndicatory() {
        activityView.alpha = 1
        activityView.center = self.view.center
        self.view.addSubview(activityView)
        activityView.startAnimating()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0{
            presenter?.didselectFolder(folderIndex: indexPath.row)
            indexForLongPress = indexPath.row
            backOutlet.alpha = 1
        }
        if indexPath.section == 1{
            
            if check == false{
                check = true
                presenter?.didselectFile(fileIndex: indexPath.row, navigationController : navigationController!)
                showActivityIndicatory()
            }
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var returnValue = Int()
        let folderCount = foldersItem?.folder.folders.count
        let fileCount = foldersItem?.folder.files.count
        
        if section == 0 && folderCount != 0{
            returnValue = folderCount ?? 0
            
            return returnValue
        }
        if section == 1 && fileCount != 0{
            returnValue = fileCount ?? 0
            
            return returnValue
        }
        return returnValue
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HomeCollectionViewCell
        
        if indexPath.section == 0{
            cell.folderNameLabel.text = foldersItem?.folder.folders[indexPath.row].folderName//?.folder.folderName
            return cell
        }
        if indexPath.section == 1{
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell2", for: indexPath) as! HomeCollectionViewCell2
            let str = foldersItem?.folder.files[indexPath.row].fileName!.lowercased()
            let nsString = str! as NSString
            
            if nsString.length > 0
            {
                cell2.fileNameLabel.text = nsString.substring(with: NSRange(location: 0, length: nsString.length > 30 ? 30 : nsString.length))
            }
            if (foldersItem?.folder.files[indexPath.row].fileName!.lowercased().contains("."))!{
                
                switch foldersItem?.folder.files[indexPath.row].fileName!.lowercased().components(separatedBy: ".")[1]{
                    
                case "png", "heic", "webp", "bmp", "gif", "jpe", "jpeg", "jpg", "svg", "tif", "tiff":
                    cell2.fileImage.image = UIImage(named: "file_image_icon")
                case "webm","mp2","mpa","mpe","mpeg","mpg","mpv2","qt","mov","movie","flv","mp4","ts","3gp","3gpp","3gp2","3gpp2","avi","wmv":
                    cell2.fileImage.image = UIImage(named: "file_video_icon")
                case "pdf","doc","dot","docx","dotx","docm","dotm","xls","xlt","xla","xlsx","xltx","xltm","xlam","xlsb","ppt","pot","pps","ppa","pptx","potx","ppsx","ppam","pptm","potm","ppsm","mdb":
                    cell2.fileImage.image = UIImage(named: "file_document_icon")
                case "wma","mp3","m4a","ogg","wav":
                    cell2.fileImage.image = UIImage(named: "file_audio_icon")
                default:
                    cell2.fileImage.image = UIImage(named: "file_icon")
                }
            }else{
                
            }
            return cell2
        }
        return cell
    }
}

extension HomeCollectionViewController : PresenterToHomeViewProtocol{
    
    func showErrorAlert(errorMessage: String) {
        errorAlert(errorMessage : errorMessage)
        activityView.stopAnimating()
    }
    
    func showSuccessAlert(successMessage: String, whois : String) {
        successAlert(successMessage : successMessage)
        activityView.stopAnimating()
        
        switch whois {
        case "deleteFolder":
            self.foldersItem?.folder.folders.remove(at: indexForLongPress)
            folderId = UserDefaults.standard.stringArray(forKey: "lastFolderIdArray")?.last
        case "deleteFile":
            self.foldersItem?.folder.files.remove(at: indexForLongPress)
        default:
            print("")
        }
        self.collectionView.reloadData()
    }
    
    func showFolders(folders : Folder) {
        foldersItem = folders
        self.navigationItem.title = foldersItem?.folder.folderName
        folderId = foldersItem!.folder.folderId
        self.collectionView.reloadData()
        activityView.stopAnimating()
        if foldersItem?.folder.folderName == "root"{
            backOutlet.alpha = 0
        }
        if  UserDefaults.standard.stringArray(forKey: "lastFolderIdArray")?.count != 0 && foldersItem?.folder.folderName != "root"{
            backOutlet.alpha = 1
        }
    }
}
