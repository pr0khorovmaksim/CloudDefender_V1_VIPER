//
//  HomeEntity.swift
//  CloudDefender_V1_VIPER
//
//  Created by maksim on 31.07.2020.
//  Copyright © 2020 maksim. All rights reserved.
//

import Foundation

final class Folder : Codable{
    
    let folder : FolderList?
}

final class FolderList : Codable {
    
    let fullPath : String?
    let folderName : String?
    let folderId : String?
    var files : [Files]?
    var folders : [Folders]?
    let owners : [String]?
}

final class Files : Codable{
    
    let fileId : String?
    let fileName : String?
    
    init(fileId : String, fileName : String) {
        self.fileId = fileId
        self.fileName = fileName
    }
}

final class Folders : Codable{
    
    let folderId : String?
    let folderName : String?
    
    init(folderId : String, folderName : String) {
        self.folderId = folderId
        self.folderName = folderName
    }
}

final class Owners : Codable{
    
}
