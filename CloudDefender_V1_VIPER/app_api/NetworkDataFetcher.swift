//
//  NetworkDataFetcher.swift
//  CloudDefender_V1_VIPER
//
//  Created by maksim on 01.08.2020.
//  Copyright © 2020 maksim. All rights reserved.
//

import Foundation

final class NetworkDataFetcher {
    
    fileprivate let networkService : NetworkService = NetworkService()
    fileprivate let constants : Constants = Constants()
    
    func fetchFolders(folderId: String?, userId : String?, parameters : [String : Any]?, response: @escaping (Folder?) -> Void) {
        
        let urlString = constants.urlFolders + folderId!
        let httpMethod = constants.get
        
        networkService.request(urlString: urlString, userId : userId, httpMethod : httpMethod, parameters : parameters ) { (result) in
            switch result {
            case .success(let data):
                do {
                    let folders = try JSONDecoder().decode(Folder.self, from: data)
                    response(folders)
                } catch let jsonError {
                    print("Не удалось декодировать JSON: \(jsonError)")
                    response(nil)
                }
            case .failure(let error):
                print("Ошибка при запросе данных: \(error.localizedDescription)")
                response(nil)
            }
        }
    }
    
    func fetch(userId : String?, pathId : String?, whois : String?, parameters : [String : Any]?, response: @escaping (Data?) -> Void) {
        
        let httpMethod : String?
        let urlString : String?
        
        switch whois{
        case "deleteFolder":
            urlString = constants.urlFolders + pathId!
            httpMethod = constants.delete
        case "createFolder":
            urlString = constants.urlFolders
            httpMethod = constants.post
        case "shareFolder":
            urlString = constants.urlFolders
            httpMethod = constants.patch
        case "downloadFile":
            urlString = constants.urlFiles + pathId!
            httpMethod = constants.get
        case "deleteFile":
            urlString = constants.urlFiles + pathId!
            httpMethod = constants.delete
        default :
            return
        }
        
        networkService.request(urlString: urlString, userId: userId, httpMethod: httpMethod, parameters : parameters){ (result) in
            switch result {
            case .success(let data):
                response(data)
            case .failure(let error):
                print("Ошибка при запросе данных: \(error.localizedDescription)")
                response(nil)
            }
        }
    }
    
    func fetchUploadFile(userId : String?, fileName : String?, mime : String?, data : Data?, parameters : [[String : Any]]?, response: @escaping (Data?) -> Void) {
        
        let urlString = constants.urlFiles
        let httpMethod : String
        
        switch parameters!.count{
        
        case 2 :
            httpMethod = constants.post
        case 3 :
            httpMethod = constants.put
        default :
            httpMethod = constants.post
        }
        
        networkService.requestFileUpload(urlString: urlString, userId: userId, fileName: fileName, httpMethod: httpMethod, mime: mime, data: data, parameters: parameters){ (result) in
            switch result {
            case .success(let data):
                response(data)
            case .failure(let error):
                print("Ошибка при запросе данных: \(error.localizedDescription)")
                response(nil)
            }
        }
    }
    
    func fetchRegister(parameters : [String : Any]?, response: @escaping (Data?) -> Void) {
        
        let urlString = constants.urlRegister
        let httpMethod = constants.post
        
        networkService.requestRegister(urlString: urlString, httpMethod: httpMethod, parameters: parameters){ (result) in
            
            switch result {
            case .success(let data):
                response(data)
            case .failure(let error):
                print("Ошибка при запросе данных: \(error.localizedDescription)")
                response(nil)
            }
        }
    }
}
