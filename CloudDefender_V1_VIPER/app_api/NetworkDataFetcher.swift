//
//  NetworkDataFetcher.swift
//  CloudDefender_V1_VIPER
//
//  Created by maksim on 01.08.2020.
//  Copyright © 2020 maksim. All rights reserved.
//

import Foundation

final class NetworkDataFetcher {
    
    let networkService = NetworkService()
    
    func fetchFolders(urlString: String, folderId : String, userId : String, httpMethod : String, parameters : [String : Any], response: @escaping (Folder?) -> Void) {
        networkService.requestFolders(urlString: urlString, userId : userId, httpMethod : httpMethod, parameters : parameters ) { (result) in
            
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
    
    func fetchFolderAction(urlString: String, folderId : String, userId : String, httpMethod : String, parameters : [String : Any], response: @escaping (Data?) -> Void) {
        networkService.requestFolders(urlString: urlString, userId : userId, httpMethod : httpMethod, parameters : parameters ) { (result) in
            switch result {
            case .success(let data):
                response(data)
            case .failure(let error):
                print("Ошибка при запросе данных: \(error.localizedDescription)")
                response(nil)
            }
        }
    }
    
    func fetchFile(urlString: String, userId : String, httpMethod : String, parameters : [String : Any], response: @escaping (Data?) -> Void) {
        networkService.requestFile(urlString: urlString, userId: userId, httpMethod: httpMethod, parameters : parameters){ (result) in
            switch result {
            case .success(let data):
                response(data)
            case .failure(let error):
                print("Ошибка при запросе данных: \(error.localizedDescription)")
                response(nil)
            }
        }
    }
    
    func fetchUploadFile(urlString: String, userId : String, fileName : String, httpMethod: String, mime : String, data : Data, parameters : [[String : Any]], response: @escaping (Data?) -> Void) {
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
    
    func fetchRegister(urlString: String, httpMethod: String, parameters : [String : Any], response: @escaping (Data?) -> Void) {
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
