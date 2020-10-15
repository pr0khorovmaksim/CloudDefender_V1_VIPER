//
//  NetworkService.swift
//  CloudDefender_V1_VIPER
//
//  Created by maksim on 01.08.2020.
//  Copyright © 2020 maksim. All rights reserved.
//

import Foundation

final class NetworkService {
    
    func request(urlString: String?, userId : String?, httpMethod: String?, parameters : [String : Any]?, completion: @escaping (Result<Data, Error>) -> Void) {
        
        var request = URLRequest(url: URL(string: urlString!)!)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("\(userId!)", forHTTPHeaderField: "userID")
        request.httpMethod = httpMethod
        
        guard let parameters = parameters else { return }
        let postData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        request.httpBody = postData
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            completion(.success(data))
        }.resume()
    }
    
    func requestFileUpload(urlString: String?, userId : String?, fileName : String?, httpMethod: String?, mime : String?, data : Data?, parameters : [[String : Any]]?, completion: @escaping (Result<Data, Error>) -> Void) {
        
        var request = URLRequest(url: URL(string: urlString!)!)
        var body = Data()
        let boundary = "Boundary-\(UUID().uuidString)"
        let  mime = mime
        
        request.setValue("\(userId!)", forHTTPHeaderField: "userID")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = httpMethod
        
        guard let parameters = parameters else { return }
        for param in parameters {
            if param["disabled"] == nil {
                let paramName = param["key"]!
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(paramName)\"".data(using: .utf8)!)
                let paramType = param["type"] as! String
                if paramType == "text" {
                    let paramValue = param["value"] as! String
                    body.append("\r\n\r\n\(paramValue)\r\n".data(using: .utf8)!)
                } else {
                    let file = param["file"] as! Data
                    print("file=",file)
                    body.append("; filename=\"\(fileName!)\"\r\n".data(using: .utf8)!)
                    body.append("Content-Type: \"\(mime!)\"\r\n\r\n".data(using: .utf8)!)
                    body.append(file)
                    body.append("\r\n".data(using: .utf8)!)
                }
            }
        }
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        URLSession.shared.uploadTask(with: request, from: body){ (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            completion(.success(data))
        }.resume()
    }
    
    func requestRegister(urlString: String?, httpMethod: String?, parameters : [String : Any]?, completion: @escaping (Result<Data, Error>) -> Void) {
        
        var request = URLRequest(url: URL(string: urlString!)!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = httpMethod
        
        guard let parameters = parameters else { return }
        let postData = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        request.httpBody = postData
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            completion(.success(data))
        }.resume()
    }
}
