//
//  HomeEntity.swift
//  CloudDefender_V1_VIPER
//
//  Created by maksim on 31.07.2020.
//  Copyright © 2020 maksim. All rights reserved.
//

import Foundation

final class Folder : Codable{
    
    let folder : FolderList
}

final class FolderList : Codable {
    
    var fullPath : String
    var folderName : String
    var folderId : String
    var files : [Files]
    var folders : [Folders]
    var owners : [String]
}

final class Files : Codable{
    
    var fileId : String
    var fileName : String
    
    init(fileId : String, fileName : String) {
        self.fileId = fileId
        self.fileName = fileName
    }
}

final class Folders : Codable{
    
    var folderId : String
    var folderName : String
    
    init(folderId : String, folderName : String) {
        self.folderId = folderId
        self.folderName = folderName
    }
}

final class Owners : Codable{
    
}
